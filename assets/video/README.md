# Minecraft: Story Mode PSP Port - Choices Implementation

This port of **Minecraft: Story Mode** for PSP uses **PMP** videos to present interactive choices to the player. The game is based on the **YouTube interactive version**, which was manually dumped from the **Netflix version**. Unlike the original Telltale release, this version doesn't include silence as a choice — that limitation is replicated in this port.

## Folder Structure

The game's files are structured in the following way:

```
assets/
├── video/
│   ├── episode1/
│   │   ├── 10_zombie_sized.pmp        # PMP video file
│   │   ├── 10_zombie_sized.png        # PNG image for choices
│   │   └── choices/
│   │       ├── 1/
│   │       │   ├── cool_mask.lua      # Lua script for the "cool_mask" choice
│   │       │   └── not_funny_axel.lua # Lua script for the "not_funny_axel" choice
│   │       └── 2/
│   │           ├── another_choice.lua
│   │           └── another_choice_alt.lua
│   └── episode2/
│       └── ...
└── ...
```

Each episode contains PMP video files and PNG images that display the choices after the video ends. Choices are organized into numbered folders (e.g., `choices/1/`, `choices/2/`, etc.), each containing Lua scripts corresponding to specific player decisions.

## How Choices Work

### Workflow Overview

1. **PMP Video Playback:** The game plays a PMP video (`.pmp`).
2. **Image Display:** After the video finishes, a `.png` image with choice overlays is displayed. This image is usually the last frame of the video with added buttons/text in Photoshop.
3. **Button Mapping:** Players press a button (`Square`, `Circle`, etc.) to make a choice.
4. **Script Execution:** The choice triggers the corresponding Lua script from the appropriate folder.

### Example Code

```lua
local choosing = true
local img = Image.load('assets/video/episode1/10_zombie_sized.png')

PMP.setVolume(pmpvolume)
PMP.play('assets/video/episode1/10_zombie_sized.pmp', buttons.r)

screen.clear()
Image.draw(img, 0, 0)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()

while choosing do
    buttons.read()

    if buttons.pressed(buttons.square) then
        Image.unload(img)
        choosing = false
        nextscene = "assets/video/episode1/choices/1/cool_mask.lua"
    elseif buttons.pressed(buttons.circle) then
        Image.unload(img)
        choosing = false
        nextscene = "assets/video/episode1/choices/1/not_funny_axel.lua"
    elseif buttons.pressed(buttons.l) then
        Image.unload(img)
        choosing = false
        nextscene = "./mainmenu.lua"
    elseif buttons.pressed(buttons.start) then
        Image.unload(img)
        choosing = false
        SaveGame(1)
        nextscene = "./mainmenu.lua"
    end
end
```

## Preparing PMP Videos and Choice Images

To create the necessary files for a choice segment:

1. **Trim the video** where choice options appear and all characters are silent (this ensures a clean frame for overlays).
2. **Extract the final frame** of that trimmed video.
3. **Open it in Photoshop** (PSD templates available in `mcsm_portable_extras` repo).
4. **Add text and button overlays**.
5. **Save as PNG** using the same base name as the PMP video.
6. **Convert the trimmed video to PMP** using **Xvid4PSP 5.0**.

### Example Tools Used

- **Xvid4PSP 5.0**: Used to trim and convert video to `.pmp`. Available on archive.org.
- **Photoshop**: For editing PNG overlays for choices.

## Notes

- The system replicates YouTube’s interactive format — no “silence” option is included.
- Debug overlay support is included via `debugoverlay.lua`.
- Make sure file paths and folder structure match the examples to avoid load errors.