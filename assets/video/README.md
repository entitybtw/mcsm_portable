# Minecraft: Story Mode PSP Port - Choices Implementation

This is a custom port of **Minecraft: Story Mode** for the PSP. The game uses videos in the **PMP** format, and the interactive choices are displayed after each video plays. Here's how the choices work and how you can modify or extend them.

## How Choices Work

The game is based on the **YouTube interactive version** of Minecraft: Story Mode, which was **dumped manually** from the Netflix version. Unlike the original version, there is **no "mute" option** in the YouTube version, which is why choices are handled differently.

### Key Workflow:
- Each scene is a separate **PMP** video.
- The video plays, and once it ends, a static image (last frame of the video) is displayed. This image contains the overlay for the choice (e.g., buttons and text), which was created manually using Photoshop.
- The player makes a choice by pressing a button (such as Square or Circle). The corresponding choice leads to another video or scene.

### Folder Structure:
The files are organized in the following way:

```assets/
├── video/
│ └── episode1/
│ ├── 10_zombie_sized.pmp # PMP video file
│ ├── 10_zombie_sized.png # PNG image with choice overlays
│ └── choices/
│ └── 1/
│ ├── cool_mask.lua # Lua script for this choice
│ └── not_funny_axel.lua # Lua script for the alternate choice'''


### Choice Handling in Code:
Each episode contains a video and a `.png` file for choices. Below is an example code that shows how a choice works in the port:

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