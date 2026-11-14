# The game

## Start of the game

`script.lua`: `getlang()` finds the languages and picks one, then `applyFonts`, `loadStrings`, the intro, the title screen, the loading screen and the scene loop. The loop runs `nextscene` with `pcall`: an error in a scene goes to the debug log, and three in a row return to the main menu. An error outside it reaches the crash screen.

## Episodes

Each episode is one file, `assets/video/episodeN/episodeN.lua`. Its `start.lua` asks the setup questions, stored per save slot, and starts or continues the episode.

`ContinueEpisode(N)` continues only a save that has reached a checkpoint of the episode (`epN_node` in its vars). A new slot is written as episode 1 at once, so without this check its first start skipped the opening of the episode (the tagline "The game series adapts to the choices you make" of episode 1).

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

**Timed choices.** The clips of the choices are not cut after their choice: the rest of the clip is the time to answer, as the idle animation of the original game. `assets/video/episodeN/choice_frames.lua` gives the frame of each clip where its choice appears (where the border of the choice appears in the video). `pvChoice` in every `episodeN.lua` draws the choice over the playing clip from that frame, with a bar of the time left (the bar of the original game, `ui_dialog_timerBar` of `MCSM_pc_UI_txmesh.ttarch2`, cells as the experience bar of Minecraft; the texture is grey and the game tints it by the colour keys of `ui_dialog_timer.chore` (`MCSM_pc_UI_anichore.ttarch2`: green at 0, yellow at 2.5, red from 13 of its 15.5 s, which `GameDialog.lua` stretches over the wait), while its two masks grow from the ends; `drawTimer` does the same with the tint of `Image.draw` (`TIMER_KEYS`); the empty part is the dark strip of the same texture; redrawn at 245x5 into the menu spritesheet at 139,132 (full bar) and 139,140 (empty) by `work/timer/tools/mkbar.py` and `mkbar_sheet.py`, with 3 free palette slots for its lightest colours; it shrinks to its middle); an answer stops the clip there (the overlay of `PMP.playExt` returns `"stop"`, and the function returns 2), and R before the choice skips to it (`PMP.seek`). When the clip ends without an answer, the answer (in episodes 2 to 5 only for a clip listed in `choice_frames.lua`: a clip without a wait keeps its choice on the last frame) of the node's `def` (`"left"`, `"right"`, `"top"`) is taken, else one of the shown answers at random (also the third one of a choice of three, `tri` in episode 4), as the Netflix version takes one of its answers. The original game takes its silence ("..."), but no silence video of male Jesse is known (the Netflix version has none). The characters talk in many of the waits: those lines have subtitles too, added after the human cues of each clip in every language (made from speech recognition by `work/timer/tools/tailsubs.py` and the lines of `work/timer/tails_lines1.py`; episode 2: `work/timer/ep2/`). A subtitle of two or more lines would cover the choice and its bar, which stand right above the subtitle line: `PMP.playExt` (`easy.lua`) sets `SUBS_TOP` to the top of the subtitle it drew, and `pvChoice` moves the choice and the bar up, a few pixels per frame, until they clear it. With the setting "Timed choices" off (audio and video settings, `TimedChoices()` in `lang.lua`, saved as `timed_choices`), the choice stands on the last frame and waits.

`choiceIdle()` redraws the frame, the choice and the save icon while the icon plays. The frame is freed when the next video starts (`PMP.playExt` calls `ChoiceBackdropFree`) and between scenes (`script.lua`).

The save icon is a chest and an arrow, drawn by `drawSaveOverlay()`. Any loop that redraws the screen calls it before the flip.

A save at a choice is written while the choice stands (in episode 1: right after the answer, before the answer changes anything, since the choice stands over a playing clip), and its icon is shown as in the original game: after the answer, over the next video. The choice loops call `AutoSave(N, true)`, which only marks the icon (a local of `saves.lua`: a global flag would be saved with the game), and `PMP.playExt` starts it with the video. A save at a zone shows its icon at once.

## Interactive zones

A zone (`zone = zone_woods` and the like, in every episode) has no picture of its own: it stands over its video. The clip into the zone, and every clip a hotspot plays that comes back to the zone view, run to the end of their uncut source, which zooms out to the view of the zone inside the white border of the Netflix version. From the frame where that border appears (`assets/video/episodeN/zone_frames.lua`) the hotspots stand over the playing video, with no timer, and R skips to that frame. They always come up with a fade of about half a second, all together (and again over the kept frame after a clip without a border); the fade starts once the video shows that frame (`PMP.ready()`, so not while a skip decodes its way there). The zoom-out goes on for up to 5 s after the border, and the hotspots are placed for the final view, which is the same as the old pictures of the zones, so they sit a little off their objects until the camera stops; a hotspot picked there stops the video on that frame. A video that ends stops on its last frame, kept (`PMP.takeLastFrame`) under the hotspots until the next one is picked. A clip not in `zone_frames.lua` keeps the picture the zone had: in episode 4 the talk with Petra or Gabriel in Ivor's house (`*/choices/16/petra`, `gabriel`) ends in a choice and keeps its old cut. A hotspot sets its state ("used") before its clip plays, since the tail of the clip already shows the next view of the zone with its hotspots (Sky City changes its view after the crafting table or the garden, the temple after the pedestal). The hotspot whose clips are playing is not shown over them.

The main loop does not play the clip into a zone: it hands it to the zone (`ZONE_ENTRY`, with the overlay of the answer before it), and the checkpoint of the zone is that clip's node, so a game continued at a zone plays it again. A save made at the zone node itself (older saves) plays the zone's default clip into it (`entry` of its `zoneLoop`) from the frame of the border.

## Saving

The game saves only by itself: `AutoSave` at the choices and the zones, as often as the setting says (off, or every 1 to 10 checkpoints; 5 by default). With "off" the game is not saved at all. There is no manual save: R only skips a video.

Saves are in `assets/misc/savefiles.lua`. Its two questions ("delete save?" and the setup answers of a slot on SELECT) are the window of every question of the game, `assets/misc/dialog.lua`, laid out as the setup questions of the episodes (`choice_setup.lua`). A window fades in and out as one layer: its panel is drawn as pieces that never overlap and everything in it takes the same alpha; the hints of the grid leave in the first half of the fade and those of the window come in the second. The setup questions come out of black (the first one), fade between each other, and `ChoiceSetupEnd()` takes the screen to black before the episode or the main menu.

**Credits.** `PlayCredits(path)` (`easy.lua`) plays the credits of an episode, at the end of the episode and from the credits menu: out of black, back to black at the end or when START skips them, the sound with the picture. The credits menu fades the menu to black first and back after.

The files of the saves:

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

A clip starts right after the choice before it. A clip with a choice after it runs to the end of the uncut source (the wait under the choice: 16 to 48 s after the choice appears in episode 1, 5 to 29 s in episode 2, up to 21 s in episodes 4 and 5). The uncut sources are the structured videos of the maintainer's cloud, and the YouTube nodes of the Netflix version for the clips added later (episode 2: the four `_bow` clips of choice 7 and `magnus_petra/stone/*`). In episodes 2 and 3 only the endings keep their old cut; in episode 4 also the 8 clips of `choices/6`, in episode 5 the 2 of `choices/2`: their sources go into the Netflix title card right after the choice, so there is no wait to play. Episode 5 has no structured videos: its uncut clips come from the YouTube nodes, and so do the `_nopotion` clips of choice 11 and `ellegaard_gabriel/choices/21/*` of episode 4. Elsewhere it ends about a second after the frame of the next choice appears, once the characters are silent and the music has settled; a person chose each end, so the tail after the frame differs (29 to 134 frames). A new version of an existing clip is cut like it: the same first frames, and the same tail after the frame.

Use them for any new or remade video, so that size, quality and decoding cost stay the same across the game.

## Title screen

`assets/misc/title.lua`: a 3D landscape with clouds and haze, mostly baked so that little runs in Lua per frame. Colours are a table made at load, haze is `assets/ui/title/haze.png` (`tools/bake_haze.py`), and clouds are culled in the engine (`Mesh.setTiles`, `cull = true`).
