local bg = Image.load("assets/mainmenu/pause_bg.png")
local circle = Image.load("assets/icons/circle.png")
local cross = Image.load("assets/icons/cross.png")


-- load buttons
local buttonsList = {
    {
        static = Image.load("assets/buttons/CONTROLS_ENG_STATIC.png"),
        selected = Image.load("assets/buttons/CONTROLS_ENG_SELECTED.png")
    },
    {
        static = Image.load("assets/buttons/AUDIOVIDEO_ENG_STATIC.png"),
        selected = Image.load("assets/buttons/AUDIOVIDEO_ENG_SELECTED.png")
    },
    {
        static = Image.load("assets/buttons/DEBUG_ENG_STATIC.png"),
        selected = Image.load("assets/buttons/DEBUG_ENG_SELECTED.png")
    }
}

local selectedButton = 1

local function drawButtons()
    for i, button in ipairs(buttonsList) do
        local x = 150                 -- horizontal position for all buttons
        local y = 40 + (i - 1) * 30 -- vertical spacing between buttons

        if i == selectedButton then
            Image.draw(button.selected, x, y)
        else
            Image.draw(button.static, x, y)
        end
    end
end

local function unloadButtons()
    for k, v in pairs(buttonsList) do
        Image.unload(v.static)
        Image.unload(v.selected)
    end
end

while true do
    screen.clear()
    buttons.read()

    

    Image.draw(bg, 0, 0)
    intraFont.printShadowed(218, 25, "Settings", Color.new(255, 255, 255), Color.new(0, 0, 0), font, 90, 1, 0.3, 0)
    Image.draw(cross, 240 - (14 + intraFont.textW(font, "Select", 0.3) + 7 + 14 + intraFont.textW(font, "Previous Menu", 0.3)) / 2, 246, 14, 14)
    intraFont.printShadowed(240 - (14 + intraFont.textW(font, "Select", 0.3) + 10 + 14 + intraFont.textW(font, "Previous Menu", 0.3)) / 2 + 14 + 5, 247, "Select", Color.new(255,255,255), Color.new(0,0,0), font, 90, 1, 0.3, 0)
    Image.draw(circle, 240 - (14 + intraFont.textW(font, "Select", 0.3) + 7 + 14 + intraFont.textW(font, "Previous Menu", 0.3)) / 2 + 14 + intraFont.textW(font, "Select", 0.3) + 10, 246, 14, 14)
    intraFont.printShadowed(240 - (14 + intraFont.textW(font, "Select", 0.3) + 10 + 14 + intraFont.textW(font, "Previous Menu", 0.3)) / 2 + 14 + intraFont.textW(font, "Select", 0.3) + 10 + 14 + 5, 247, "Previous Menu", Color.new(255,255,255), Color.new(0,0,0), font, 90, 1, 0.3, 0)
    
    -- navigation logic
    if buttons.pressed(buttons.up) and selectedButton > 1 then
        selectedButton = selectedButton - 1
        sound.playEasy("assets/sounds/select.wav", sound.WAV_1, false, false)
        sound.volumeEasy(sound.WAV_1, uiLevel * 10)
    end
    if buttons.pressed(buttons.down) and selectedButton < #buttonsList then
        selectedButton = selectedButton + 1
        sound.playEasy("assets/sounds/select.wav", sound.WAV_1, false, false)
        sound.volumeEasy(sound.WAV_1, uiLevel * 10)
    end
    if buttons.pressed(buttons.circle) then
        unloadButtons()
        Image.unload(bg)
        Image.unload(circle)
        Image.unload(cross)
        sound.playEasy("assets/sounds/skeleton_1.wav", sound.WAV_1, false, false)
        sound.volumeEasy(sound.WAV_1, uiLevel * 10)
        break
    end
    if buttons.pressed(buttons.cross) then    
        if selectedButton == 1 then
            -- 'controls' button
            sound.playEasy("assets/sounds/click.wav", sound.WAV_1, false, false)
            sound.volumeEasy(sound.WAV_1, uiLevel * 10)
            dofile("assets/misc/pause_controls.lua")
        elseif selectedButton == 2 then
            -- 'audio/video' button
            sound.playEasy("assets/sounds/click.wav", sound.WAV_1, false, false)
            sound.volumeEasy(sound.WAV_1, uiLevel * 10)
            dofile("assets/misc/pause_audio_video.lua")
        elseif selectedButton == 3 then
            -- 'debug' button
            sound.playEasy("assets/sounds/click.wav", sound.WAV_1, false, false)
            sound.volumeEasy(sound.WAV_1, uiLevel * 10)
            dofile("assets/misc/pause_debug.lua")
        end
    end

    -- Draw buttons
    drawButtons() -- draw buttons

    debugoverlay.draw(debugoverlay.loadSettings())
    screen.flip()
end
