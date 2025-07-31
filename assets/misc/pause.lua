local bg = Image.load("assets/mainmenu/pause_bg.png")
local circle = Image.load("assets/icons/circle.png")
sound.playEasy("assets/sounds/pause_bg.wav", sound.WAV_2, true, false)
sound.volumeEasy(sound.WAV_2, menumusic * 10)
local fade = 255
local c_black = Color.new(0, 0, 0)
local fade_enabled = 1

-- load buttons
local buttonsList = {
    {
        static = Image.load("assets/buttons/RESUME_ENG_STATIC.png"),
        selected = Image.load("assets/buttons/RESUME_ENG_SELECTED.png")
    },
    {
        static = Image.load("assets/buttons/SETTINGS_ENG_STATIC.png"),
        selected = Image.load("assets/buttons/SETTINGS_ENG_SELECTED.png")
    },
    {
        static = Image.load("assets/buttons/MAINMENU_ENG_STATIC.png"),
        selected = Image.load("assets/buttons/MAINMENU_ENG_SELECTED.png")
    },
    {
        static = Image.load("assets/buttons/EXITGAME_ENG_STATIC.png"),
        selected = Image.load("assets/buttons/EXITGAME_ENG_SELECTED.png")
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

    if fade_enabled == 1 and fade > 0 then
        fade = fade - 2
        if fade < 0 then fade = 0 end
    end    
    

    Image.draw(bg, 0, 0)
    intraFont.printShadowed(220, 25, "Paused", Color.new(255, 255, 255), Color.new(0, 0, 0), font, 90, 1, 0.3, 0)
    Image.draw(circle, 240 - intraFont.textW(font, "Resume Game", 0.3) / 2 - 8, 233 + 13, 14, 14, nil, nil, nil, nil, nil, nil)
    intraFont.printShadowed(240 - intraFont.textW(font, "Resume Game", 0.3) / 2 + 8, 233 + 14, "Resume Game", Color.new(255,255,255), Color.new(0, 0, 0), font, 90, 1, 0.3, 0) 
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
        PMP.pause()
        sound.stop(sound.WAV_2)
        unloadButtons()
        Image.unload(bg)
        Image.unload(circle)
        break
    end
    if buttons.pressed(buttons.cross) then    
        if selectedButton == 1 then
            -- 'resume game' button
            sound.playEasy("assets/sounds/click.wav", sound.WAV_1, false, false)
            sound.volumeEasy(sound.WAV_1, uiLevel * 10)
            PMP.pause()
            unloadButtons()
            sound.stop(sound.WAV_2)
            Image.unload(circle)
            Image.unload(bg)
            break
        elseif selectedButton == 2 then
            -- 'settings' button
            sound.playEasy("assets/sounds/click.wav", sound.WAV_1, false, false)
            sound.volumeEasy(sound.WAV_1, uiLevel * 10)
            dofile("assets/misc/pause_settings.lua")
        elseif selectedButton == 3 then
            -- 'mainmenu' button
            sound.playEasy("assets/sounds/click.wav", sound.WAV_1, false, false)
            sound.volumeEasy(sound.WAV_1, uiLevel * 10)
            sound.stop(sound.WAV_2)
            Image.unload(bg)
            Image.unload(circle)
            unloadButtons()
            return -1
        elseif selectedButton == 4 then
            -- 'Exit Game' button
            sound.playEasy("assets/sounds/click.wav", sound.WAV_1, false, false)
            sound.volumeEasy(sound.WAV_1, uiLevel * 10)
            LUA.exit()
        end
    end

    -- Draw buttons
    drawButtons() -- draw buttons

    debugoverlay.draw(debugoverlay.loadSettings())
    if fade_enabled == 1 and fade > 0 then
        screen.filledRect(0, 0, 480, 272, c_black, 0, fade)
    end    
    screen.flip()
end
