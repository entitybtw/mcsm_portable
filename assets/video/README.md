--[[
README — How Choices Work in MCSM PSP Port
Author: entitybtw (mcsm_portable)

==========================
Example: Choice Script
==========================

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

==========================
Q: How does it work?
==========================

A:
The game is built entirely using PMP videos. Since the base is the **YouTube interactive version** of Minecraft: Story Mode (based on Netflix, but dumped manually), every scene is a separate video file.

**There is no "stay silent" option in the YouTube version**, unlike in the original Telltale release — that's why the game always forces a player choice.

To handle visual choices, here's how it's done:
- The PMP video ends *right before* the choice UI appears.
- The last frame is captured and saved as a `.png`.
- The actual UI (buttons and text) is baked into the image using Photoshop.
- These PNGs are shown immediately after the video ends.
- Player presses a button (e.g. ◻️ or ⭘), and the corresponding `.lua` script loads the next video/scene.

All assets like `.psd` files used to generate the PNG overlays are stored in the `mcsm_portable_extras` repo.

Videos are converted using **Xvid4PSP 5.0**, available on Archive.org.

==========================
Folder Structure
==========================

assets/
├── video/
│   └── episode1/
│       ├── 10_zombie_sized.pmp
│       ├── 10_zombie_sized.png
│       └── choices/
│           └── 1/
│               ├── cool_mask.lua
│               └── not_funny_axel.lua

Each choice is grouped by number (`1`, `2`, `3`, etc.) inside `choices/`, depending on how many decision points are in an episode.

==========================
2025 entitybtw / mcsm_portable
]]--
