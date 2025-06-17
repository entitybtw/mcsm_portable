local bg = Image.load('assets/mainmenu/bg.png') -- load bg
local settingstext = Image.load("assets/mainmenu/settings/settings_text.png") -- load settings text

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
    },
    {
        static = Image.load("assets/buttons/CREDITS_ENG_STATIC.png"),
        selected = Image.load("assets/buttons/CREDITS_ENG_SELECTED.png")
    },
    {
        static = Image.load("assets/buttons/PREVIOUSMENU_ENG_STATIC.png"),
        selected = Image.load("assets/buttons/PREVIOUSMENU_ENG_SELECTED.png")
    }
}

local selectedButton = 1

local function drawButtons()
    for i, button in ipairs(buttonsList) do
        local x = 35                 -- horizontal position for all buttons
        local y = 50 + (i - 1) * 30 -- vertical spacing between buttons

        -- if its last button, add extra space
        if i == #buttonsList then
            y = 50 + (i - 1) * 30 + 50
            x = 0
        end

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

    -- navigation logic
    if buttons.pressed(buttons.up) and selectedButton > 1 then
        selectedButton = selectedButton - 1
        sound.play("assets/sounds/select.wav", sound.WAV_1, false, false)
        sound.volume(sound.WAV_1, uiLevel * 10)
    end
    if buttons.pressed(buttons.down) and selectedButton < #buttonsList then
        selectedButton = selectedButton + 1
        sound.play("assets/sounds/select.wav", sound.WAV_1, false, false)
        sound.volume(sound.WAV_1, uiLevel * 10)
    end

    if buttons.pressed(buttons.cross) then    
        if selectedButton == 1 then
            -- 'controls' button
            sound.play("assets/sounds/click.wav", sound.WAV_1, false, false)
            sound.volume(sound.WAV_1, uiLevel * 10)
            dofile("assets/misc/controls.lua")
        elseif selectedButton == 2 then
            -- 'audio/video' button
            sound.play("assets/sounds/click.wav", sound.WAV_1, false, false)
            sound.volume(sound.WAV_1, uiLevel * 10)
            dofile("assets/misc/audio_video.lua")
        elseif selectedButton == 3 then
            -- 'debug' button
            sound.play("assets/sounds/click.wav", sound.WAV_1, false, false)
            sound.volume(sound.WAV_1, uiLevel * 10)
            dofile("assets/misc/debug.lua")
        elseif selectedButton == 4 then
            -- 'credits' button
            sound.play("assets/sounds/click.wav", sound.WAV_1, false, false)
            sound.volume(sound.WAV_1, uiLevel * 10)
            dofile("assets/misc/credits_episodes.lua")
        elseif selectedButton == 5 then
            -- 'previous menu' button
            unloadButtons()
            Image.unload(bg)
	        Image.unload(settingstext)
            sound.play("assets/sounds/skeleton_1.wav", sound.WAV_1, false, false)
            sound.volume(sound.WAV_1, uiLevel * 10)
            break
        end
    end

    -- Draw buttons
    drawButtons() -- draw buttons
    Image.draw(settingstext, 0, 38, 120, 13) -- draw settingstext

    debugoverlay.draw(debugoverlay.loadSettings())
    screen.flip()
end
