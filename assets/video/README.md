# Minecraft: Story Mode PSP Port - Choices Implementation

This port of **Minecraft: Story Mode** for PSP uses **PMP** videos to present interactive choices to the player. The game is based on the **YouTube interactive version** of the game, which was dumped manually from the **Netflix version**. Due to limitations in the engine during development, the choice system works differently than in the original game.

## Folder Structure

The game's files are structured in the following way:

```
assets/
├── video/
│   ├── episode1/
│   │   ├── 10_zombie_sized.pmp       # PMP video file
│   │   ├── 10_zombie_sized.png       # PNG image for choices
│   │   └── choices/
│   │       ├── 1/
│   │       │   ├── cool_mask.lua     # Lua script for the "cool_mask" choice
│   │       │   └── not_funny_axel.lua # Lua script for the "not_funny_axel" choice
│   │       └── 2/
│   │           ├── another_choice.lua
│   │           └── another_choice_alt.lua
│   └── episode2/
│       └── ...
└── ...
```

Each episode contains a folder with the video files (in **PMP** format) and PNG images that display the choices after the video ends. Each set of choices is located in a numbered folder (e.g., `choices/1/`, `choices/2/`, etc.).

## How Choices Work

### Workflow Overview:
1. **PMP Video File:** The game plays a **PMP** video.
2. **Choice Image:** After the video ends, a **PNG** image is displayed. This image is the last frame of the video with added choice buttons and text.
3. **Choice Handling:** The player makes a choice by pressing a button (e.g., `Square` or `Circle`). Each choice leads to a different outcome and loads a new video or script.
4. **Choice Folder Structure:** Choices are handled by Lua scripts inside the `choices/` folder.

### Example Code:

Here is an example of how the choice system works in the game:

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

### Explanation of the Code:
1. **Loading the Image and Video:**
   - The **PMP** video is played using `PMP.play()`.
   - After the video finishes, a PNG image (`10_zombie_sized.png`) is drawn to the screen with the available choices.
   
2. **Choice Handling:**
   - The player presses a button (`Square`, `Circle`, etc.).
   - Depending on the button pressed, the corresponding Lua script is loaded (`cool_mask.lua`, `not_funny_axel.lua`).

3. **Choice Folders:**
   - Choices are stored in numbered folders (`choices/1/`, `choices/2/`, etc.).
   - Each folder contains Lua scripts representing each choice. These scripts control what happens next in the game.

## Video Conversion Workflow

The **PMP** video format is used for all the scenes. Here's how you can convert videos and prepare the images for choices:

1. **Convert the video to PMP** using **Xvid4PSP 5.0** (a program available on archive.org).
2. **Extract the last frame** of the video and save it as a PNG image.
3. **Add overlays** (e.g., choice buttons and text) using Photoshop.
4. **Save the image** with the same name as the video and place it in the appropriate directory.
5. **Create a Lua script** for each choice inside the `choices/` folder.

## Tools Used

- **Xvid4PSP 5.0**: A program used to convert video files to the PMP format.
- **Photoshop**: For creating the choice overlays on the PNG images.

## Notes

- The choice system uses **PNG images** that are displayed after the video ends, and buttons are mapped to specific actions defined in Lua scripts.
- Make sure to follow the folder structure carefully when adding new episodes or choices.