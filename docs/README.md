# Minecraft: Story Mode Portable

A fan port of Minecraft: Story Mode season 1 to the PSP, built on the interactive video version of the game. Every scene is a PMP video; the choices and menus are Lua scripts run by our engine, LuaPlayerYT-MCSM, kept in a separate repository.

| Page | What |
|---|---|
| [ENGINE.md](ENGINE.md) | The engine and its full Lua API |
| [GAME.md](GAME.md) | Story, saves, menus |
| [LANGUAGES.md](LANGUAGES.md) | Languages and subtitles |
| [TESTING.md](TESTING.md) | PSPLink, PPSSPP tests, known traps |

## Where things are

| Path | What |
|---|---|
| `EBOOT.PBP`, `EBOOT_dev.prx` | The engine: for the XMB and for PSPLink |
| `script.lua` | The start of the game and the scene loop |
| `mainmenu.lua` | The main menu |
| `easy.lua` | Sound helpers, `PMP.playExt` |
| `saves.lua`, `files.lua`, `sav.lua` | Save icon and autosave, key/value storage, settings |
| `debugoverlay.lua` | The debug overlay and its log |
| `assets/misc/` | Screens and helpers: `lang.lua`, `savefiles.lua`, `pause*.lua`, `settings.lua`, `title.lua`, `intro.lua`, ... |
| `assets/video/episodeN/` | Videos, `start.lua` (setup questions), `episodeN.lua` (the story) |
| `assets/langs/<code>/` | A language: strings and subtitles |
| `assets/ui/` | Menu art |

Git-ignored: `assets/saves/`, `tools/` (asset build scripts and their sources), `work/` (long tasks), `docs/NEXT.md` (the open work of the maintainer, kept local).

## Build and run

You need [pspdev](https://github.com/pspdev/pspdev), Git LFS (`git lfs pull` after cloning), and PPSSPP or a PSP with custom firmware.

```bash
export PSPDEV=$HOME/pspdev PATH=$PSPDEV/bin:$PATH
make -C <engine repo>
cp <engine repo>/EBOOT.PBP <engine repo>/EBOOT_dev.prx .
```

`.lua` files and assets need no engine build.

- **PPSSPP:** open `EBOOT.PBP`.
- **PSP:** copy `EBOOT.PBP`, all `.lua` files and `assets/` to `<psp root>/PSP/GAME/<folder>/`.
- **PSPLink:** see [TESTING.md](TESTING.md).
