local psbg = Image.load("assets/mainmenu/pause_bg.png")
local scrollY = -25
local scrollSpeed = 10
local scrollDelay = 0
local scrollCooldown = 2



local function printCenteredLine(y, line, scale)
    local textWidth = intraFont.textW(font, line, scale)
    local x = 240 - (textWidth / 2)
    intraFont.print(x, y, line, Color.new(255, 255, 255), font, scale)
end




local sep = "\n\n------------------------------\n\n"

-- changelogs

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
mcsm_portable 0.5 [release]

updated readme
]]

local changelog_0_6 = [[
mcsm_portable 0.6 [release]

updated readme, delete assets/saves/1_save.txt
]]

local changelog_0_7 = [[
mcsm_portable 0.7 [release]

create assets/saves/123.txt
]]

local changelog_0_8 = [[
mcsm_portable 0.8 [prerelease]

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

- Episode menu buttons styled in black & white (exclusive to this port)

- Main menu hints now use PS-style black & white buttons (exclusive to this port)

- Changed 'made by entitybtw' screen

Fixed

- Fixed a choice issue in assets/video/episode2/magnus_petra/4/shes_awesome.lua

Removed

- Removed the "Not Yet" screen from the episode menu
]]

local changelog_1_5 = [[
mcsm_portable 1.5 [release]

Added

- Episode 3

- 'Chicken Machine 2' button in 'endercon' interactive zone (episode one)

Fixed

- Fixed bugs in episode one choices

- Optimized audio/video tab in settings

- Optimized Chicken Machine button in 'endercon' interactive zone (episode one)
]]

local combined_changelog = 
    changelog_1_5 .. sep .. 
    changelog_1_4 .. sep ..
    changelog_1_3 .. sep ..
    changelog_1_2 .. sep ..
    changelog_1_1 .. sep ..
    changelog_1   .. sep ..
    changelog_0_8 .. sep ..
    changelog_0_7 .. sep ..
    changelog_0_6 .. sep ..
    changelog_0_5 .. sep ..
    changelog_0_2 .. sep ..
    changelog_0_1

    

while true do
    buttons.read()

    if buttons.held(buttons.up) then
        scrollDelay = scrollDelay + 1
        if scrollDelay >= scrollCooldown then
            if scrollY > -25 then scrollY = scrollY - scrollSpeed end
            scrollDelay = 0
        end
    elseif buttons.held(buttons.down) then
        scrollDelay = scrollDelay + 1
        if scrollDelay >= scrollCooldown then
            if scrollY < 1600 then scrollY = scrollY + scrollSpeed end
            scrollDelay = 0
        end
    else
        scrollDelay = 0
    end

    if buttons.pressed(buttons.start) then
        Image.unload(psbg)
        sound.playEasy("assets/sounds/skeleton_1.wav", sound.WAV_1, false, false)
        sound.volumeEasy(sound.WAV_1, uiLevel * 10)
        break
    end

    screen.clear()
    Image.draw(psbg, 0, 0)
    
    -- Настройки текста и отступов
    local exitText = "Press START to exit"
    local exitScale = 0.3
    local exitHeight = 10 * exitScale + 20 -- высота строки + отступ
    local exitY = 275    - exitHeight -- текст прижат к низу
    
    -- Ограниченная зона вывода changelog (до текста снизу)
    local changelogYStart = -scrollY
    local changelogMaxY = exitY - 10 -- 10px отступ перед надписью
    
    -- Рисуем changelog, но только если он не упрется в текст снизу
    local y = changelogYStart
    for line in combined_changelog:gmatch("[^\r\n]+") do
        if y > changelogMaxY then break end
        printCenteredLine(y, line, 0.3)
        y = y + 20 * 0.3 + 10
    end
    
    -- Рисуем кнопку выхода
    intraFont.print(240 - intraFont.textW(font, exitText, exitScale) / 2, exitY, exitText, Color.new(255, 255, 255, 180), font, exitScale)
    
    -- Остальное
    debugoverlay.draw(debugoverlay.loadSettings())
    screen.flip()
    
end
