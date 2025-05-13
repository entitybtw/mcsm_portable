# Minecraft: Story Mode PSP Port - Choices Implementation

This port of **Minecraft: Story Mode** for PSP uses **PMP** videos to present interactive choices to the player. This homebrew uses videos downloaded from **YouTube interactive version**, which were manually dumped from the **Netflix version**. Unlike the original Telltale release, this version doesn't include silence as a choice — that limitation is replicated in this port.

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

Each episode contains PMP video files and PNG images that display the choices after the video ends. Choices are organized into numbered folders (e.g., `choices/1/`, `choices/2/`, etc.), each containing Lua scripts that represent different player decisions.

## How Choices Work

### Workflow Overview

1. **PMP Video Playback:** The game plays a PMP video (`.pmp`).
2. **Image Display:** After the video finishes, a `.png` image with choice overlays is displayed. This image is usually the last frame of the video with added buttons/text in Photoshop.
3. **Button Mapping:** Players press a button (`Square`, `Circle`, etc.) to make a choice.
4. **Script Execution:** The choice triggers the corresponding Lua script from the appropriate folder.

### Example Code

```lua
local choosing = true
local img = Image.load('assets/video/episode1/10_zombie_sized.png') -- load image

PMP.setVolume(pmpvolume) -- set pmp volume from pmpvolume variable
PMP.play('assets/video/episode1/10_zombie_sized.pmp', buttons.r)  -- playing pmp video

screen.clear()
Image.draw(img, 0, 0) -- drawing image
debugoverlay.draw(debugoverlay.loadSettings()) -- display debug text
screen.flip()

while choosing do
    buttons.read()

    if buttons.pressed(buttons.square) then
        Image.unload(img) -- unload image
        choosing = false
        nextscene = "assets/video/episode1/choices/1/cool_mask.lua" -- move to next scene
    elseif buttons.pressed(buttons.circle) then
        Image.unload(img) -- unload image
        choosing = false
        nextscene = "assets/video/episode1/choices/1/not_funny_axel.lua" -- move to next scene
    elseif buttons.pressed(buttons.l) then
        Image.unload(img) -- unload image
        choosing = false
        nextscene = "./mainmenu.lua" -- move to main menu
    elseif buttons.pressed(buttons.start) then
        Image.unload(img) -- unload image
        choosing = false
        SaveGame(1) -- saving game
        nextscene = "./mainmenu.lua" -- move to main menu
    end
end
```

## Preparing PMP Videos and Choice Images

To create the necessary files for a choice segment:

1. **Load the video into Xvid4PSP 5.0.**
2. **Trim the video** at the point where the choice selection frame appears and all characters are silent.
3. **Extract the final frame** from the trimmed video.
4. **Convert the trimmed video to PMP** using **Xvid4PSP 5.0**.
5. **Open the extracted frame in Photoshop** (PSD templates available in the `mcsm_portable_extras` repo).
6. **Add the choice text.**
7. **Save the image as a PNG** using the same base name as the PMP video.

### Tools Used

- **Xvid4PSP 5.0**: Used to trim and convert video to `.pmp`. Available on archive.org.
- **Photoshop**: For editing PNG overlays for choices.
- **Cobalt**: For downloading videos from youtube | https://cobalt.tools

## Notes

- Make sure file paths and folder structure match the examples to avoid load errors.