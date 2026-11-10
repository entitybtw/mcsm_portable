# The game

## Start of the game

`script.lua`: `getlang()` finds the languages and picks one, then `applyFonts`, `loadStrings`, the intro, the title screen, the loading screen and the scene loop. The loop runs `nextscene` with `pcall`: an error in a scene goes to the debug log, and three in a row return to the main menu. An error outside it reaches the crash screen.

## Episodes

Each episode is one file, `assets/video/episodeN/episodeN.lua`. Its `start.lua` asks the setup questions, stored per save slot, and starts or continues the episode.

Episodes 2 to 4 branch on the setup answers: who was saved (Gabriel or Petra) and whose armour (Magnus or Ellegaard). Episode 4 has four branch folders: `ellegaard_gabriel`, `ellegaard_petra`, `magnus_gabriel`, `magnus_petra`.

An episode is a table of nodes:

```lua
["c15/threat"] = {
	pre = function() sword = "_sword" end,        -- runs before the video
	dv  = function() return "choices/15/threaten_" .. reuben end,   -- video (dynamic); v = "..." for a fixed one
	sq  = { k = "offer_sword", n = "c16/x", fn = function() ... end }, -- square: text key, next node, side effect
	ci  = { k = "threaten",    n = "c16/y" },                          -- circle
	tr  = { ... },                                                     -- triangle (3 choices)
	n   = "endercon_zone",                                             -- no choice: go on
	post = function() ... end,                                         -- ending (credits, main menu)
	zone = zone_woods,                                                 -- interactive zone
},
```

The video and its subtitles share the relative path: `V .. rel .. ".pmp"` and `SubsDir(N) .. rel .. ".srt"`.

Story variables that change the videos, all saved in the slot:

- `reuben` (`reuben` / `noreuben`)
- `building` (`creeper` / `enderman`): the team scenes of episode 1, and the statue in choices 22-23 (`_enderman`)
- `sword` (`""` / `"_sword"`)
- `with_lukas` (`""` / `"_lukas"`): Jesse went after Lukas at choice 19. Choices 21-23 of episode 1 show Lukas with Jesse, and in "Help Lukas" he thanks him. Old saves without it play the videos without Lukas.
- the setup answers `gp`, `bf`, `em`, `ema`; `bf` also picks `_bow` in the fight of Boom Town (episode 2, choice 7)
- `potion` (`""` / `"_nopotion"`) in episode 4: "Let's head back" at choice 9 comes to choice 11 without the potion of leaping (another line and shorter videos), "We need that cake" with it. Old saves play the videos with the potion.
- `mi` and `save` in episode 5. `save` (`lukas` / `founder`, choice 25) picks `_founder` in choices 26-30 and `_lukas` in 33-34: the base videos of 26-30 are the ones where Jesse backed Lukas up, those of 33-34 the ones where he saved the Founder. In 26, 27 ("Bring everyone here") and 29 ("Potion of speed") the Founder's video is the same for Ivor and Milo, so it has no `mi` folder.

A version of a video that one of them changes has the suffix after the name of the base video, in the order of the list: `help_lukas_lukas_enderman.pmp`.

## Choice screens and the save icon

A choice is drawn over the last frame of the video. The engine keeps that frame in RAM when a video ends, and `ChoiceBackdropTake` takes it with `PMP.takeLastFrame`.

`choiceIdle()` redraws the frame, the choice and the save icon while the icon plays. The frame is freed when the next video starts (`PMP.playExt` calls `ChoiceBackdropFree`) and between scenes (`script.lua`).

The save icon is a chest and an arrow, drawn by `drawSaveOverlay()`. Any loop that redraws the screen calls it before the flip.

## Saving

The game saves only by itself: `AutoSave` at the choices and the zones, as often as the setting says (off, or every 1 to 10 checkpoints; 5 by default). With "off" the game is not saved at all. There is no manual save: R only skips a video.

Saves are in `assets/misc/savefiles.lua`:

- There are 4 slots. Each is `assets/saves/slot<N>.json` with `{episode, scene, vars, story, timestamp, name}`, plus the picture of its card in `slot<N>_thumb.raw`.
- Files are written through a `.tmp` file and a rename, so a power cut never leaves half a save.
- `vars`: every global string, number or boolean, except the system ones listed in `SYS_VARS`. A new global that holds a flag is therefore saved unless it is listed there.
- `story`: the setup answers `gp bf em ema`, per slot. A new slot asks the setup again.
- `timestamp`: `SaveTimestamp()`, the local time of the PSP from `System.getTime`.
- Settings common to all slots are in `assets/saves/data.json` (`sav.lua`).

## The save screen

A 2x2 grid of cards.

- **A filled card** shows `slot<N>_thumb.raw`: the last video frame at the last save (`WriteSlotThumb`, called by `AutoSave`; only during the game, so never a frame of a menu video). The pictures are loaded by `refreshSlots` and held only while the screen is open, about 32 KB of RAM each. Without the file, or with a damaged one, the card shows the sprite `thumb`.
- **The sprite `thumb`** comes from the texture `ui_chapter_default.d3dtx` of the original game, baked by `tools/bake_save_thumb.py`.
- **An empty card** shows the floppy and "Empty".

Buttons: Cross loads or creates; Square renames (`System.OSK`, 24 characters at most, empty gives the default name); Triangle deletes; Select shows the setup answers of the slot; Circle goes back.

## Episode menu

`assets/ui/epmenu/epmenu.lua` plays the clips `assets/ui/epmenu/epN.pmp` (`_l` and `_r` for the slide). The game draws the overlay: name, button, hints in `smallFont()`, arrows. The video is paused a few frames before its end to keep the frame.

Each episode shows Start, Continue or Restart, from the keys `N_status` in `data.json`. `SetStatusesFromSave(slot)` recomputes them whenever the slot changes (create, load, delete): episodes before the one of the save get Restart, its episode gets Continue (Start before the first choice), later ones get Start.

## Menu video

The main menu, the episode list, the extras and the settings stand on `assets/ui/mcsm_mainmenu.pmp`. It is stopped whenever a screen needs its memory (the episode menu with its own clips, the credits, a font rebuild), and the menus go on with it where it stopped: `stopMenuVideo` keeps its frame in `MENU_VIDEO` and `safePlayMenuVideo` starts it there (`PMP.play` with a start frame, [ENGINE.md](ENGINE.md)); a menu comes out of black only once the video shows its own frame (`waitMenuVideo`). From the game (the start, "Main menu" of the pause, the end of an episode) `mainmenu.lua` runs as a new scene, and there the video and the music of the menu start from the beginning.

## Videos

Every video of the game is a PMP file made from the original with `pmp-cli` (the PMP command-line converter, kept outside this repository), with the same settings for all of them:

```bash
pmp-cli convert clip.mp4 clip.pmp --crf 27 --preset faster --audio-bitrate 64   # from a source video
pmp-cli compress clip.pmp --crf 27 --preset faster --audio-bitrate 64           # an existing PMP
```

A source bigger than the screen needs `--width 480 --height 272`: pmp-cli keeps the size of the source, and a 720p PMP is about 28 MB for 2.5 minutes, too much for the PSP.

A clip starts right after the choice before it, and ends about a second after the frame of the next choice appears, once the characters are silent and the music has settled; a person chose each end, so the tail after the frame differs (29 to 134 frames). A new version of an existing clip is cut like it: the same first frames, and the same tail after the frame.

Use them for any new or remade video, so that size, quality and decoding cost stay the same across the game.

## Title screen

`assets/misc/title.lua`: a 3D landscape with clouds and haze, mostly baked so that little runs in Lua per frame. Colours are a table made at load, haze is `assets/ui/title/haze.png` (`tools/bake_haze.py`), and clouds are culled in the engine (`Mesh.setTiles`, `cull = true`).
