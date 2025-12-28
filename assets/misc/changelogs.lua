local scrollY = 0
local scrollTarget = 0
local scrollSpeed = 12
local smooth = 0.2



local function printCenteredLine(y, line, scale)
    local textWidth = intraFont.textW(font, line, scale)
    local x = 240 - (textWidth / 2)
    intraFont.printShadowed(x, y, line, Color.new(255, 255, 255), Color.new(0, 0, 0), font, 90, 1, scale, 0)
end

local sep = "\n\n\n\n"

local changelog_0_1 = [[
mcsm_portable 0.1 [prerelease]

THIS IS A PRE-RELEASE, A RAW VERSION BEFORE THE NORMAL RELEASE

Currently not done:

1. Sounds in the menu
2. Saves
3. Episode Menu
4. Credits button in the menu
]]

local changelog_0_2 = [[
mcsm_portable 0.2 [prerelease]

working version with ppsspp

THIS IS A PRE-RELEASE, A RAW VERSION BEFORE THE NORMAL RELEASE

Currently not done:

1. Sounds in the menu
2. Saves
3. Episode Menu
4. Credits button in the menu
]]

local changelog_0_5 = [[
mcsm_portable 0.3 [release]

updated readme
]]

local changelog_0_6 = [[
mcsm_portable 0.6 [release]

updated readme, delete assets/saves/1_save.txt
]]

local changelog_0_7 = [[
mcsm_portable 0.3 [release]

create assets/saves/123.txt
]]

local changelog_0_8 = [[
mcsm_portable 0.6 [prerelease]

- now episode menu is taken from ps4 mcsm version
- added saves menu
- added arrows for mainmenu from the original game
- added "welcome to minecraft story mode" thing from the original game
- updated controls menu
- now names of video-files for ep1 is better
- main menu now is much better, stable

There is a choice in which if you choose something wrong, 
it will give an error, it will be fixed very soon 
i forgot to remove it :skull:
]]

local changelog_1 = [[
mcsm_portable 1.0 [release]

- now episode menu is taken from ps4 mcsm version
- added saves menu
- added arrows for mainmenu from the original game
- added "welcome to minecraft story mode" thing from the original game
- updated controls menu
- now names of video-files for ep1 is better
- main menu now is much better, stable
- updated saving screens (now they look better).
- finally fixed the Reuben choice (run or don’t run) 
and the choice between creeper or enderman.
]]

local changelog_1_1 = [[
mcsm_portable 1.1 [release]

- fixed loading screen glitches
- improved game save system
- improved playstation buttons sprites in mainmenu
- fixed interactive zones bugs
- added sounds in mainmenu
]]

local changelog_1_2 = [[
mcsm_portable 1.2 [release]

Added
- New Settings menu with customization options
- Audio volume sliders for:
    UI sounds
    Menu music
    PMP videos
- Credits button (shows episode credits)
- Debug menu displaying:
    Battery %
    Free RAM
    CPU frequency
    PSP model
    Date & Time
    Nickname
    System language

Changed
- Redesigned main menu Credits section
]]

local changelog_1_3 = [[
mcsm_portable 1.3 [release]

Added
- Episode 2
- Episode 2 Saves Menu
- Episode 2 Rewind System 
(lets you revisit and choose key decisions 
from Episode 1 before starting Episode 2)

Changed
- Changed audio/video menu music text
- Improved saves system
- Improved Episode Menu
Thanks to
Sei-Sou for converting videos for ellegaard_gabriel storyline
]]

local changelog_1_4 = [[
mcsm_portable 1.4 [release]

Added
- Fade-out animation when clicking Play in the main menu
- Readme explaining the choice system in assets/video/
- New global functions like cnt, fileExists, and more
- 'Minecraft is best played with headphones' screen from mobile version
- Screen won’t lower brightness or turn off during gameplay

Changed
- Episode menu now includes: Coming Soon, Continue, and Restart buttons
- Save system improved — now uses a proper system-level structure
- Renamed the "rewind" system to episode choice setup
- Episode menu buttons styled in black & white 
- (exclusive to this port)
- Main menu hints now use PS-style black & white buttons 
(exclusive to this port)
- Changed 'made by entitybtw' screen

Fixed
- Fixed a choice issue in 
assets/video/episode2/magnus_petra/4/shes_awesome.lua

Removed
- Removed the "Not Yet" screen from the episode menu

Thanks to
@r3trob0y for helping improve the save menu system
]]

local changelog_1_5 = [[
mcsm_portable 1.5 [release]

Added
- Episode 3
- 'Chicken Machine 2' button in 'endercon' interactive zone (episode one)

Fixed
- Fixed bugs in episode one choices
- Optimized audio/video tab in settings
- Optimized Chicken Machine button in 'endercon' interactive zone 
(episode one)

Thanks to
@r3trob0y for helping optimize audio/video tab in settings
@antim0118 for helping optimize the chicken machine button in 'endercon' 
interactive zone
]]

local changelog_1_6 = [[
mcsm_portable 1.6 [release]

Added
- Episode 4
- Pause Menu
- 'Paused' screen
- Animated background in main-menu
- Loading in title-screen
- subtitles
- subtitles settings in audio/video tab
- 'The game series adapts to the choices you make' screen for episode one

Fixed
- Threaten or Offer Sword choice in episode 1
- Episode 3 interactive zones

Changed
- Replaced the Credits tab in the main menu with a Changelogs tab
- Now saving is triggered by pressing R
- Controls tab, now it looks like from original game
- Refactored all choices
- Now all menus use button hints (previous menu, etc.).

Removed
- The triangle (exit) button from the main menu.

Note
> Subtitles may be unsynchronized or contain mistakes; if you can, 
> please help with fixing the subtitles.


Thanks to
@r3trob0y for awesome LuaPlayerYT engine beta 2.2
@antim0118 for helping fixing bugs
tyom4style for helping with pause-menu background
@akrgood for helping fixing subtitles a bit for episode three
@dntrnk for helping fixing subtitles a bit for episode one
]]

local changelog_1_7 = [[
mcsm_portable 1.7 [release]

Added
- Episode 5
- Repo Mirrors (codeberg, gitlab)
- SimpleLocalize page (redirect.entitybtw.ru/localize)

Fixed
- Useless calculations from choice-texts drawing, replaced by number

Changed
- Fixed episode 1 subtitles (Thanks to NoHleb)
- Refactored all menus buttons
- Refactored all interactive zones (Thanks to dntrnk)
- New 'Changelogs' tab apparence

Removed
- Removed icons(triangle, square, circle, cross) loading/unloading from choices, interactive zones, menus. Replaced by loading icons at start

repo mirrors
- codeberg -> https://codeberg.org/entitybtw/mcsm_portable
- gitlab -> https://gitlab.com/entitybtw-group/mcsm_portable

Note
> Subtitles may be unsynchronized or contain mistakes; if you can, please help with fixing the subtitles.

Thanks to
@NoHleb for fixing episode 1 subtitles
@dntrnk for helping optimizing port, refactoring interactive zones
]]


local combined_changelog =
    changelog_1_7 .. sep ..
    changelog_1_6 .. sep ..
    changelog_1_5 .. sep ..
    changelog_1_4 .. sep ..
    changelog_1_3 .. sep ..
    changelog_1_2 .. sep ..
    changelog_1_1 .. sep ..
    changelog_1 .. sep ..
    changelog_0_8 .. sep ..
    changelog_0_7 .. sep ..
    changelog_0_6 .. sep ..
    changelog_0_5 .. sep ..
    changelog_0_2 .. sep ..
    changelog_0_1

local colors = {
    Header = Color.new(245, 245, 245),

    Added = Color.new(210, 210, 210),
    Changed = Color.new(200, 200, 200),
    Fixed = Color.new(190, 190, 190),
    Removed = Color.new(180, 180, 180),

    DefaultBullet = Color.new(205, 205, 205),
    Numbered = Color.new(215, 215, 215),

    DefaultText = Color.new(225, 225, 225),
    Thanks = Color.new(195, 195, 195)
}




local lines = {}
for line in combined_changelog:gmatch("[^\r\n]+") do
    table.insert(lines, line)
end

local function getLineHeight(line)
    if line:find("^mcsm_portable") then
        return 20 * 0.4 + 10
    elseif line:find("^%-+$") then
        return 5
    elseif line == "" then
        return 5
    else
        return 20 * 0.3 + 10
    end
end

local totalHeight = 0
for _, line in ipairs(lines) do
    totalHeight = totalHeight + getLineHeight(line)
end
local maxScroll = math.max(0, totalHeight - 250)

while true do
    buttons.read()

    if buttons.held(buttons.up) then
        scrollTarget = scrollTarget - scrollSpeed
    elseif buttons.held(buttons.down) then
        scrollTarget = scrollTarget + scrollSpeed
    end

    if scrollTarget < 0 then scrollTarget = 0 end
    if scrollTarget > maxScroll then scrollTarget = maxScroll end

    scrollY = scrollY + (scrollTarget - scrollY) * smooth

    if buttons.pressed(buttons.start) then
        sound.playEasy("assets/sounds/skeleton_1.wav", sound.WAV_1, false, false)
        sound.volumeEasy(sound.WAV_1, uiLevel * 10)
        break
    end

    screen.clear()

    local exitText = "Press START to exit"
    local exitScale = 0.3
    local exitHeight = 10 * exitScale + 20
    local exitY = 275 - exitHeight

    local y = -scrollY
    for _, line in ipairs(lines) do
        local h = getLineHeight(line)
        if y + h > 0 and y < exitY - 10 then
            if line:find("^mcsm_portable") then
                local scale = 0.4
                local x = 240 - intraFont.textW(font, line, scale) / 2
                intraFont.printShadowed(x, y, line, colors.Header, Color.new(0, 0, 0), font, 90, 1, scale, 0)
            elseif line:find("^%-+$") then
                printCenteredLine(y, line, 0.3)
            elseif line:find("^Added") then
                intraFont.printShadowed(30, y, line, colors.Added, Color.new(0, 0, 0), font, 90, 1, 0.3, 0)
            elseif line:find("^Changed") then
                intraFont.printShadowed(30, y, line, colors.Changed, Color.new(0, 0, 0), font, 90, 1, 0.3, 0)
            elseif line:find("^Fixed") then
                intraFont.printShadowed(30, y, line, colors.Fixed, Color.new(0, 0, 0), font, 90, 1, 0.3, 0)
            elseif line:find("^Removed") then
                intraFont.printShadowed(30, y, line, colors.Removed, Color.new(0, 0, 0), font, 90, 1, 0.3, 0)
            elseif line:find("^Thanks to") then
                intraFont.printShadowed(30, y, line, colors.Thanks, Color.new(0, 0, 0), font, 90, 1, 0.3, 0)
            elseif line:find("^%-") then
                intraFont.printShadowed(30, y, line, colors.DefaultBullet, Color.new(0, 0, 0), font, 90, 1,0.3, 0)
            elseif line:match("^%d+%.") then
                intraFont.printShadowed(30, y, line, colors.Numbered, Color.new(0, 0, 0), font, 90, 1, 0.3, 0)
            else
                intraFont.printShadowed(30, y, line, colors.DefaultText, Color.new(0, 0, 0), font, 90, 1, 0.3, 0)
            end
        end
        y = y + h
        if y > exitY - 10 then break end
    end

    intraFont.printShadowed(240 - intraFont.textW(font, exitText, exitScale) / 2, exitY, exitText, Color.new(255, 255, 255), Color.new(0, 0, 0), font, 90, 1, exitScale, 0)

    debugoverlay.draw(debugoverlay.loadSettings())
    screen.flip()
end
