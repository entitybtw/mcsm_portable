# Testing

| What changed | How to check |
|---|---|
| Any Lua file | `luac5.1 -p <file>` |
| A screen | PPSSPP test and a look at the screenshot |
| Anything that reads the screen | Also on `--graphics=gles`: the software renderer hides the problem |
| Timing, races, memory, memory stick speed | A real PSP, over PSPLink or from the XMB |

## PSPLink

Runs the game on a real PSP from the folder on the PC, with no copying to the memory stick. PSPLink loads only a PRX, hence `EBOOT_dev.prx`. The PC tools `usbhostfs_pc` and `pspsh` come with pspdev.

**Once:**

1. Extract `psplink.zip` from the [psplinkusb release](https://github.com/pspdev/psplinkusb/releases) into `ms0:/PSP/GAME/`.
2. On Linux, add a udev rule so the tools run without sudo (vendor `054c`, product `01c9`, `MODE="0666"`).

**Each session:**

1. Start PSPLink on the PSP from the XMB and connect the USB cable.
2. In the game folder, start the file server and keep it running. It shows the folder as `host0:`:

   ```bash
   usbhostfs_pc
   ```

3. In a second terminal, start the shell:

   ```bash
   pspsh
   ```

4. Start the game. The folder must be `host0:/`, because the game opens its files by relative path:

   ```
   cd host0:/
   ld host0:/EBOOT_dev.prx
   ```

5. To run a new build or changed Lua, type `reset` and start it again. Files are read straight from the PC, so there is nothing to copy.

Useful `pspsh` commands:

| Command | What |
|---|---|
| `reset` | Back to a clean state |
| `scrshot file.bmp` | A screenshot of the PSP screen |
| `meminfo` | Free memory |
| `modlist`, `thlist` | Loaded modules, threads |
| `exprint` | The last exception |
| `cp host0:/file ms0:/path` | Copies to the memory stick, which the PC cannot mount while PSPLink holds the USB |
| `exit` | Leaves the shell |

**A crash:** PSPLink prints a report with the address. Look it up in the ELF of the same build, built with `-g` (not in the default `CFLAGS`):

```bash
psp-addr2line -e <engine repo>/LuaPlayerYT.elf <address>
```

**Debugger:** `debug host0:/EBOOT_dev.prx` in `pspsh`, then `psp-gdb <engine repo>/LuaPlayerYT.elf -q` and `target remote :10001`.

Do not kill `usbhostfs_pc` in the middle of a transfer: the link then starts a reset loop. Leave `pspsh` with `exit` first; if the loop starts, restart PSPLink on the PSP.

Final checks still run the packed `EBOOT.PBP` from the XMB, as players start it.

## Automated tests in PPSSPP

`PPSSPPHeadless` runs the game without a window. A test lives in its own folder. Use absolute paths: with relative ones the game may not start, and nothing says so.

```bash
PPSSPPHeadless <test>/EBOOT.PBP -r <test> --graphics=software --timeout=150
```

1. Put **copies** of `EBOOT.PBP`, the `.lua` files and `assets/misc/` in `<test>`, with an empty `assets/saves/`. Do not symlink `.lua` files: writing the test's `script.lua` through a symlink once replaced the real one.
2. Symlink the big read-only folders from the game: `assets/video`, `assets/ui`, `assets/langs`, `assets/sounds`, and the font files in `assets/`.
3. Write a `script.lua` that loads what it needs and drives the screen:

   ```lua
   spritesheet = Image.load("assets/ui/menu-spritesheet.png")
   require("sav"); require("easy"); require("saves"); require("debugoverlay"); require("files")
   dofile("assets/misc/lang.lua"); getlang(); lang = "en"; applyFonts(lang); loadStrings(lang)

   local log = io.open("test_log.txt", "w")   -- print does not reach the headless output
   local flip, frames = screen.flip, 0
   screen.flip = function()
       flip(); frames = frames + 1
       if frames == 120 then LUA.screenshot("shot.png", 480, 272); error("DONE") end
   end
   local ok, e = pcall(dofile, "assets/misc/pause_settings.lua")   -- the screen under test
   log:write(tostring(e), "\n"); log:close()
   error("DONE")   -- System.exit does not exist; --timeout stops the emulator
   ```

Notes:

- Buttons are scripted by replacing `buttons.pressed` with your own function.
- A screen may need globals that its caller sets, such as `pause_bg` and `ui_enabled` for the pause settings. A black screenshot often means this, or that the shot was taken during a fade-in.
- After a video, a test must call `System.GC()` as the game does, or later videos may fail to start.
- Lua no longer runs on the crash screen. To take a shot of it, build a throw-away copy of the engine that calls `LUA.screenshot` from the loop in `showErrorScreen`.
- Screenshots need `--graphics=software`. To see what most players see, use `--graphics=gles`, but **always with a memory limit**, and have the test write its results to files:

  ```bash
  systemd-run --user --scope -p MemoryMax=6G -p MemorySwapMax=0 timeout 100 \
      PPSSPPHeadless <test>/EBOOT.PBP -r <test> --graphics=gles --timeout=90
  ```

  Without systemd, use `ulimit -v` in a subshell or a short `--timeout`.

## Known traps

### The emulator is not the PSP

- PPSSPP hides races and timing. A video frozen on its last frame never showed in the emulator.
- With a hardware renderer (OpenGL, Vulkan, the usual setting of PPSSPP) the screen is not written back to the emulated video memory, so anything that reads it gets old data:
  - `LUA.screenshot` returns a stale picture, so test screenshots need `--graphics=software`.
  - `Image.fromScreen` returns an old frame. Keep a picture you need in RAM, and test such code on `--graphics=gles` too.
- `PPSSPPHeadless --graphics=gles` uses about 270 MB more memory every second and keeps running after the test has ended. Without a limit it fills the machine, and the system may kill your terminal along with it.

### PSP

- The memory stick is FAT: file names ignore case (`START.pmp` goes with `start.srt`). A check on a PC must compare paths the same way.
- `System.listDir` gives short folder names in upper case (`assets/langs/RU/...`). Never use a folder name as an identifier: read the code from `lang.json`.
- A PSP-1000 has 32 MB of RAM. Free every image and sound you load, or it runs out after a few scenes.

### Lua

- This is Lua 5.1: there is no `goto`.
- Numbers in the engine are single-precision floats. `k - math.floor(k)` can be slightly negative, and `math.floor` of a small negative number is -1, which `Color.new` reads as 255: a flash on the screen. Clamp fractions.

### Repository

- Most assets and many `.lua` files are in Git LFS, so `git diff` shows pointers. To compare contents: `git show HEAD:path | git lfs smudge > old`, then `diff old path`.
