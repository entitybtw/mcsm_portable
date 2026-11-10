# LuaPlayerYT-MCSM

The PSP program that runs the game: a fork of LuaPlayerYT with Lua 5.1, gLib2D, intraFont, PMP Mod player and pspaalib. It starts `script.lua` from the current folder. An error that reaches the top goes to `error_log.txt` and the crash screen.

```bash
export PSPDEV=$HOME/pspdev PATH=$PSPDEV/bin:$PATH
make -C <engine repo>     # EBOOT.PBP, EBOOT_dev.prx
make DEV_PRX=0            # without EBOOT_dev.prx
./build.sh                # regenerates the built-in resources, then clean + make; takes make arguments
```

The Makefile does not track headers: after changing a `.h` (a struct of the PMP player, say), delete the objects that include it (`rm libs/pmp/*.o lua/graphics.o`) or run `./build.sh`. Stale objects with an old struct layout build without a warning and break at run time.

| File | What |
|---|---|
| `LP.c` | `main`, the crash screen |
| `lua/graphics.c` | `Color`, `intraFont`, `screen`, `Image`, `PMP`, the subtitle parser |
| `lua/mesh.c`, `lua/batch.c` | `Mesh`, `Batch` |
| `lua/audio.c`, `lua/ctrl.c`, `lua/timer.c` | `sound`, `buttons`, `timer` |
| `lua/system.c`, `lua/usb.c`, `lua/LUA.c` | `System`, `System.USB`, `LUA` |
| `lua/vfpu_math.c` | `math`, replaced with VFPU versions |
| `libs/pmp/pmp_play.c` | Video playback: a decode thread and an output thread |
| `res/` | `logo.png` (icon), `bg.png` (XMB background), `error.png`, `error.wav`, `luaFont.pgf` |

`lua/pmp.c`, `lua/particles.c` and `lua/asyncCycle.c` are not built.

In the signatures below, `[x]` is optional. Colours are `Color` values. Coordinates are screen pixels, 480x272, from the top left.

## Color

| Call | Returns |
|---|---|
| `Color.new(r, g, b, [a=255])` | A colour |
| `Color.get(color)` | `{r, g, b, a}` |
| `Color.get(color, "R"\|"G"\|"B"\|"A")` | One number |

## screen

| Call | What |
|---|---|
| `screen.clear([color=black])` | Clears the frame |
| `screen.flip()` | Shows the frame |
| `screen.filledRect(x, y, w, h, color, [rotation=0], [alpha=255], [mode=Image.lUp])` | |
| `screen.drawLine(x1, y1, x2, y2, color)` | |
| `screen.drawCircle(x, y, radius, color)` | |
| `screen.drawTriangle(x1, y1, x2, y2, x3, y3, color)` | |
| `screen.setCamera(use, [x, y])` | Offsets all 2D drawing and text |
| `screen.getCamera()` | `x, y` |

## Image

Images are freed only by `Image.unload`, not by the garbage collector.

| Call | What |
|---|---|
| `Image.load(path)` | Loads a picture |
| `Image.W(img)`, `Image.H(img)` | Size |
| `Image.draw(img, x, y, [w, h], [tint], [srcx, srcy, srcw, srch], [rotation=0], [alpha=255], [mode=Image.lUp], [linear], [repeat])` | Draws; sprites without rotation are batched, so a texture must stay alive until the flip |
| `Image.draweasy(img, x, y, [tint], [rotation=0], [alpha=255], [mode=Image.lUp], [linear], [repeat])` | Draws at its own size, not batched |
| `Image.unload(img)` | Frees it; safe on a freed image |
| `Image.drawCircleOnTex(img, x, y, r, color)` | Draws into the texture |
| `Image.createPlaceholder()` | A placeholder picture |
| `Image.fromScreen()` | A 16-bit copy of the shown screen (277 KB, about 20 ms). Reads the video memory, so it is stale in PPSSPP with a hardware renderer. Not for a video frame: use `PMP.takeLastFrame` |
| `Image.saveThumb(img, path, w, h)` | Saves a small copy of a 16-bit picture, averaged and cut to the proportions, through a temporary file. Returns true when written. Format: `MTH1`, u16 w, u16 h, 5-6-5 pixels |
| `Image.loadThumb(path)` | The picture of `saveThumb`, or nil when the file is missing or not whole |

Modes: `Image.lUp`, `Image.lDn`, `Image.rUp`, `Image.rDn`, `Image.Center`: the point of the image that `x, y` give.

## Batch

Up to 5000 sprites collected and drawn together.

| Call | What |
|---|---|
| `Batch.addDraw(img, x, y, [w, h], [srcx, srcy, srcw, srch])` | Adds a sprite, returns its index |
| `Batch.render()` | Draws them |
| `Batch.clear()` | Empties the batch |

## intraFont

A `font` argument of nil means the built-in font. `x, y` are the top left of the text. `linear` is texture smoothing: leave it off for pixel fonts. All `print*` calls return the x after the text.

| Call | What |
|---|---|
| `intraFont.load(path, [size=11])` | `.ttf`, `.otf` (at `size`, at most 30) or `.pgf` |
| `intraFont.unload(font)` | |
| `intraFont.print(x, y, text, [color], [font], [size=1], [angle], [linear], [align])` | `size` is a scale |
| `intraFont.printColumn(x, y, text, width, [color], [font], [size=1], [align], [linear], [scroll])` | Wraps at `width`, or scrolls |
| `intraFont.printUnderlined(x, y, text, [color], [lineColor], [font], [size], [linear])` | |
| `intraFont.printStriked(x, y, text, [color], [lineColor], [font], [size], [linear])` | |
| `intraFont.printContoured(x, y, text, [color], [contourColor], [font], [size], [angle], [linear])` | |
| `intraFont.printBackground(x, y, text, [color], [bgColor], [font], [size], [linear])` | |
| `intraFont.printShadowed(x, y, text, [color], [shadowColor], [font], [shadowAngle], [lightDistance], [size], [angle], [linear])` | |
| `intraFont.printGradient(x, y, text, [colorStart], [colorEnd], [font], [size], [linear])` | |
| `intraFont.setStyle(font, size, color, angle, [align])` | |
| `intraFont.size(font, size)` | Sets the scale, returns it |
| `intraFont.textW(font, text, [size])` | Width of the text |
| `intraFont.textH(font)` | Height of the letters; the offset of the baseline from `y` |
| `intraFont.lineH(font)` | Distance between lines |
| `intraFont.inkTop(font)`, `intraFont.inkH(font)` | The box of the visible pixels of the font |
| `intraFont.inkBox(font, text)` | `top, height` of that box for this text |
| `intraFont.reverseText(text)` | The text reversed |

Constants: `ALIGN_LEFT`, `ALIGN_CENTER`, `ALIGN_RIGHT`, `SCROLL_LEFT`, `SCROLL_RIGHT`, `SCROLL_SEESAW`, `SCROLL_THROUGH`, all in `intraFont`.

## PMP (video)

| Call | What |
|---|---|
| `PMP.play(path, getPointer, [loop], [srtPath], [interruptButton], [fps=29.97], [startFrame=0])` | With `getPointer`, starts the video and returns its frame as an image, or nil when it cannot start. Otherwise plays to the end before returning. `startFrame` starts it on that frame |
| `PMP.getFrame(frame)` | Updates `frame`. True while playing, and once more after the end, with the last frame |
| `PMP.stop(frame)` | Stops the video; the frame becomes the last frame |
| `PMP.pause()` | Toggles pause |
| `PMP.seek(frame)` | The playing video (of `PMP.play(path, true)`) goes on from `frame`, modulo its length. True when it plays on |
| `PMP.position()` | The number of the frame shown now (0 is the first), or nil when nothing plays |
| `PMP.ready()` | True once the playing video shows a frame of its own (a start in the middle decodes from the key frame before it first) |
| `PMP.frameCount()` | The frames of the playing video, or nil |
| `PMP.setVolume(volume)` | 0..100 |
| `PMP.getTimeCode()` | Seconds as a string, or nil when nothing plays |
| `PMP.getSubs()` | The current subtitle |
| `PMP.takeLastFrame()` | The frame the last video ended on, now owned by the caller, or nil |
| `PMP.freeLastFrame()` | Frees it; the next `PMP.play` does so at the latest |

The game wraps these in `PMP.playExt` (`easy.lua`), which draws the subtitles and the overlay of the last choice. When the overlay function returns `"stop"`, the video stops on that frame and `PMP.playExt` returns 2 (a choice answered over the video).

```lua
local frame = PMP.play("clip.pmp", true, false, "clip.srt")
while frame and PMP.getFrame(frame) do
    screen.clear()
    Image.draw(frame, 0, 0)
    screen.flip()
end
```

The output thread never closes the player: it only ends the video, and `pmp_stop` closes it on the main thread, so a frame stays valid while it is being copied.

**Starting in the middle, seeking.** H.264 decodes only from a key frame. A start on frame N (`startFrame`, `PMP.seek`) finds the key frame before N in the packet index of the file (bit 0 of an entry), and the decode thread decodes from there to N without sound before the first frame is shown; until then the frame image keeps its picture. A new image starts black, except when `PMP.play` starts at a frame (startFrame > 0) and the last video stopped was the same file (`PMP.stop` keeps its frame): the new image starts as a copy of that frame, so a video that goes on after a stop shows where it stopped instead of a black screen. The frame of another file is never copied (the card of the episode menu showed under the fade back to the main menu for a second on a PSP). `PMP.ready()` is true once the video shows a decoded frame of its own; `waitMenuVideo()` (`assets/misc/safe.lua`) waits on black for it, at most 1.5 s, before a menu comes out of black. The cost grows with the distance from the key frame: the menu video has one every 50 to 250 frames (2 to 10 s at 25 fps). In PPSSPP a resume 100 frames after a key frame took about 0.7 s. The decoder puts frame n into the buffer `n % number_of_frame_buffers`, so the output thread starts from the buffer of N. `PMP.seek` opens the same file again at the frame instead of moving the two threads under each other: the frame image, the subtitles, the loop and the pause stay. The menus use it to keep their background video going (`safePlayMenuVideo` in `assets/misc/safe.lua`).

**Subtitles.** `parseSRT`: at most 256 cues, 512 bytes of text each. The clock is `frame / 29.97 - 0.35` s, and the first cue with `start < t < end` shows. File rules: [LANGUAGES.md](LANGUAGES.md).

## Mesh (3D)

3D triangles drawn by the GE between the 2D sprites. Only `mesh.c` may use the matrix stack of libgum.

| Call | What |
|---|---|
| `Mesh.load(path)` | A `.msh` file |
| `Mesh.new(vertices, [indices])` | `vertices`: `{{x, y, z, [color], [u], [v]}, ...}`, `u, v` 0..1. `indices`: 1-based, 3 per triangle |
| `Mesh.unload(mesh)` | |
| `Mesh.setTiles(mesh, {{first, count, xmin, xmax, ymin, zmin, zmax}, ...})` | The parts of a big mesh with their boxes, in index order, for `cull` |
| `Mesh.camera{fov=60, x, y, z, pitch, yaw, roll, near=0.5, far=1000}` | Looks along -z at angle 0; degrees |
| `Mesh.fog(near, far, color)`, `Mesh.fog()` | Fog on, off |
| `Mesh.cull("none"\|"cw"\|"ccw")` | The faces that are not drawn |
| `Mesh.clearDepth()` | Once per frame, before the meshes; also sends the camera to the GE |
| `Mesh.draw(mesh, {...})` | Options below |

`Mesh.draw` options:

| Option | Default | What |
|---|---|---|
| `x, y, z, pitch, yaw, roll` | 0 | Position and angles |
| `scale` or `sx, sy, sz` | 1 | |
| `tint`, `alpha` | white, 255 | The light on the vertex colours, which are the material |
| `texture`, `linear`, `repeat` | none, false, false | A texture is multiplied with the colours |
| `depth` | true | Depth test |
| `depthWrite` | true | false keeps the test but not the depth: for see-through faces |
| `ranges` | | `{first, count, ...}`: draws only these runs of indices; `first` is 0-based, both are multiples of 3 |
| `cull` | false | Draws only the tiles in view, nothing when none is. Needs a mesh that is not turned or scaled. A tile is culled above the view, never below it |

`.msh`, little endian: `"MSH1"`, u32 vertex count, u32 index count, u32 flags (1: has u, v), the vertices as `[float u, v] u32 colour (ABGR), float x, y, z`, then the indices as u16.

## sound

The loader is named `sound.cloud`, not `sound.load`, although its error messages say `sound.load`.

| Call | What |
|---|---|
| `sound.cloud(path, channel, [toRam])` | Loads a `.wav`, `.at3` or `.ogg`. `toRam` is ignored on a PSP-1000 |
| `sound.play(channel, [loop])` | |
| `sound.pause(channel)`, `sound.stop(channel)`, `sound.unload(channel)` | |
| `sound.volume(channel, left, right)` | 0..100 |
| `sound.state(channel)` | `{state = "stopped"\|"paused"\|"playing", free, volume}` |

Channels: `sound.AT3_1` and `AT3_2`, `sound.OGG_1` to `OGG_10`, `sound.WAV_1` to `WAV_31` (`WAV_32` holds the crash sound). `sound.MP3` cannot play: it conflicts with video. `FLAC_1` to `FLAC_4` exist as constants, but the loader rejects those files. `sound.info` does nothing.

## buttons

| Call | What |
|---|---|
| `buttons.read()` | Reads the pad; once per frame, before the others |
| `buttons.pressed(b)`, `buttons.held(b)`, `buttons.released(b)` | true or false |
| `buttons.Lx()`, `buttons.Ly()` | The analog stick, 0..255 |

Buttons: `select home start up right down left l r triangle circle cross square`, all in `buttons`.

## timer

Times are in milliseconds.

| Call | What |
|---|---|
| `timer.create()` | A timer, already running |
| `timer.start(t)`, `timer.stop(t)`, `timer.reset(t)` | |
| `timer.time(t)` | The time so far |
| `timer.remove(t)` | Frees it |

## LUA

| Call | What |
|---|---|
| `LUA.exit()`, `LUA.quit()` | Stops video and exits to the XMB |
| `LUA.sleep(ms)` | |
| `LUA.getRAM()` | Free RAM |
| `LUA.getRandom(min, max)` | An integer; reseeds from the clock in seconds on each call |
| `LUA.screenshot(path, w, h)` | A PNG of the screen. Stale in PPSSPP with a hardware renderer |
| `LUA.print(x, y, text)` | Prints in the built-in font |

## System

**Files**

| Call | What |
|---|---|
| `System.listDir([path])` | `{[0] = {name, size}, ...}`: numbered **from 0**, with `.` and `..`, without a directory flag |
| `System.isFile(path)`, `System.isDir([path])` | |
| `System.rename(file, newName)`, `System.removeFile(path)`, `System.removeDir(path)`, `System.createDir(path)` | |
| `System.currentDir(newDir)` | Changes the folder, returns the old one |
| `System.fileDumpCreate(file)` | Reads a text file: `{pointer, linesCount}` |
| `System.fileDumpGetLine(pointer, pos)` | A line, or nil |
| `System.fileDumpRemove(pointer, linesCount)` | Frees it |

**Console**

| Call | What |
|---|---|
| `System.getTime()` | The local time: `year` (number), `month day hour minutes seconds` (zero-padded strings). Use it, not `os.date` |
| `System.getLang()` | `JP US FR ES DE IT NL PT RU KR TW CN` |
| `System.getModel()`, `System.getOSV()`, `System.getCPU()` | Model string, firmware version, CPU MHz |
| `System.getBatteryPercent()`, `System.getBatteryLifeTime()` | |
| `System.getNickname()`, `System.getGameID()`, `System.getGameTitle()` | |
| `System.GC()` | A full Lua garbage collection |
| `System.PowerTick()` | Keeps the console awake |

**System dialogs.** `cleanBG` and `bgpath` set what is shown behind them.

| Call | What |
|---|---|
| `System.OSK(text, desc, [cleanBG], [bgpath])` | The keyboard: the text, or nil when cancelled |
| `System.message(message, [mode], [cleanBG], [bgpath])` | A message dialog |
| `System.buttonPressed()` | The answer: `"Yes"`, `"No"` or `"Back"` |
| `System.Net()` | The network dialog |
| `System.SaveData(data, subTitle, description, ebootPath, [icon0], [cleanBG], [bgpath])` | System save dialog; not used by the game |
| `System.LoadData([cleanBG], [bgpath])`, `System.DeleteData([cleanBG], [bgpath])` | |
| `System.AutoSave(data, subTitle, description, ebootPath, folder, [icon0])`, `System.AutoLoad(folder)` | |

**USB**: `System.USB.activate()`, `System.USB.deactivate()`, `System.USB.getState()`.

## math

The `math` functions are replaced with single-precision VFPU versions: `abs acos asin atan atan2 ceil cos cosh cot coth deg exp floor fmod frexp ldexp log log10 max min modf pow rad random randomseed sin sinh sqrt tan tanh`.

`math.random()` takes no arguments, unlike standard Lua. For an integer in a range, use `LUA.getRandom`.
