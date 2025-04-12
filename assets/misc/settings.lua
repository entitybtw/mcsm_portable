local bg = Image.load('assets/mainmenu/bg.png')
local settingstext = Image.load("assets/mainmenu/options/settings_text.png")
local buttonsList = {
    {
        normalImage = Image.load("assets/buttons/CONTROLS_ENG_STATIC.png"),
        selectedImage = Image.load("assets/buttons/CONTROLS_ENG_SELECTED.png")
    },
    {
        normalImage = Image.load("assets/buttons/AUDIOVIDEO_ENG_STATIC.png"),
        selectedImage = Image.load("assets/buttons/AUDIOVIDEO_ENG_SELECTED.png")
    },
    {
        normalImage = Image.load("assets/buttons/GITHUB_ENG_STATIC.png"),
        selectedImage = Image.load("assets/buttons/GITHUB_ENG_SELECTED.png")
    },
    {
        normalImage = Image.load("assets/buttons/CREDITS_ENG_STATIC.png"),
        selectedImage = Image.load("assets/buttons/CREDITS_ENG_SELECTED.png")
    },
    {
        normalImage = Image.load("assets/buttons/PREVIOUSMENU_ENG_STATIC.png"),
        selectedImage = Image.load("assets/buttons/PREVIOUSMENU_ENG_SELECTED.png")
    }
}

-- Initialize navigation variables
local selectedButton = 1

-- Function to draw buttons
local function drawButtons()
    for i, button in ipairs(buttonsList) do
        local x = 35                 -- Horizontal position for all buttons
        local y = 50 + (i - 1) * 30 -- Vertical spacing between buttons

        -- If it's the last button, add extra space between it and others
        if i == #buttonsList then
            y = 50 + (i - 1) * 30 + 50 -- Adding more space for the "Previous Menu" button
            x = 0
        end

        if i == selectedButton then
            Image.draw(button.selectedImage, x, y) -- Highlight selected button
        else
            Image.draw(button.normalImage, x, y)
        end
    end
end

local function unloadButtons()
    for k, v in pairs(buttonsList) do
        Image.unload(v.normalImage)
        Image.unload(v.selectedImage)
    end
end

-- Main loop
while true do
    screen.clear()
    buttons.read() -- Read button input

    -- Background rendering
    Image.draw(bg, 0, 0)

    -- Navigation logic
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

    -- Action on "Cross" button
    if buttons.pressed(buttons.cross) then    
        if selectedButton == 1 then
            -- Action for "Controls"
            sound.play("assets/sounds/click.wav", sound.WAV_1, false, false)
            sound.volume(sound.WAV_1, uiLevel * 10)
            dofile("assets/misc/controls.lua")
        elseif selectedButton == 2 then
            -- Action for "Audio/Video"
            sound.play("assets/sounds/click.wav", sound.WAV_1, false, false)
            sound.volume(sound.WAV_1, uiLevel * 10)
            dofile("assets/misc/audio_video.lua")
        elseif selectedButton == 3 then
            -- Action for "Github"
            sound.play("assets/sounds/click.wav", sound.WAV_1, false, false)
            sound.volume(sound.WAV_1, uiLevel * 10)
            dofile("assets/misc/github.lua")
        elseif selectedButton == 4 then
            -- Action for "Credits"
            sound.play("assets/sounds/click.wav", sound.WAV_1, false, false)
            sound.volume(sound.WAV_1, uiLevel * 10)
            dofile("assets/misc/credits_episodes.lua")
        elseif selectedButton == 5 then
            -- Action for "Previous Menu"
            unloadButtons()
            Image.unload(bg)
	    Image.unload(settingstext)
            sound.play("assets/sounds/skeleton_1.wav", sound.WAV_1, false, false)
            sound.volume(sound.WAV_1, uiLevel * 10)
            break
        end
    end

    -- Draw buttons
    drawButtons()
    Image.draw(settingstext, 0, 38, 120, 13)
    
    screen.flip()
end
