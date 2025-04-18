local bg = Image.load('assets/mainmenu/bg.png')
local creditstext = Image.load("assets/mainmenu/settings/viewcredits_text.png")

-- Load button images dynamically based on language
local buttonsList = {
    {
        normalImage = Image.load("assets/buttons/EP1_ENG_STATIC.png"),
        selectedImage = Image.load("assets/buttons/EP1_ENG_SELECTED.png")
    },
    {
        normalImage = Image.load("assets/buttons/EP2_ENG_STATIC.png"),
        selectedImage = Image.load("assets/buttons/EP2_ENG_SELECTED.png")
    },
    {
        normalImage = Image.load("assets/buttons/EP3_ENG_STATIC.png"),
        selectedImage = Image.load("assets/buttons/EP3_ENG_SELECTED.png")
    },
    {
        normalImage = Image.load("assets/buttons/EP4_ENG_STATIC.png"),
        selectedImage = Image.load("assets/buttons/EP4_ENG_SELECTED.png")
    },
    {
        normalImage = Image.load("assets/buttons/EP5_ENG_STATIC.png"),
        selectedImage = Image.load("assets/buttons/EP5_ENG_SELECTED.png")
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
            y = 20 + (i - 1) * 30 + 50 -- Adding more space for the "Previous Menu" button
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
    end
    if buttons.pressed(buttons.down) and selectedButton < #buttonsList then
        selectedButton = selectedButton + 1
        sound.play("assets/sounds/select.wav", sound.WAV_1, false, false)
    end

    -- Action on "Cross" button
    if buttons.pressed(buttons.cross) then    
        if selectedButton == 1 then
            -- Action for "Episode 1"
	    PMP.setVolume(pmpvolume)
	    sound.volume(sound.MP3, 0)
            PMP.play('assets/video/credits/ep1.pmp', buttons.start)
	    sound.volume(sound.MP3, currentLevel * 10)
        elseif selectedButton == 2 then
            -- Action for "Episode 2"
	    PMP.setVolume(pmpvolume)
	    sound.volume(sound.MP3, 0)
            PMP.play('assets/video/credits/ep2.pmp', buttons.start)
	    sound.volume(sound.MP3, currentLevel * 10)
        elseif selectedButton == 3 then
            -- Action for "Episode 3"
	    PMP.setVolume(pmpvolume)
	    sound.volume(sound.MP3, 0)
            PMP.play('assets/video/credits/ep3.pmp', buttons.start)
	    sound.volume(sound.MP3, currentLevel * 10)
        elseif selectedButton == 4 then
            -- Action for "Episode 4"
	    PMP.setVolume(pmpvolume)
	    sound.volume(sound.MP3, 0)
            PMP.play('assets/video/credits/ep4.pmp', buttons.start)
	    sound.volume(sound.MP3, currentLevel * 10)
        elseif selectedButton == 5 then
            -- Action for "Episode 5"
	    PMP.setVolume(pmpvolume)
            sound.volume(sound.MP3, 0)
            PMP.play('assets/video/credits/ep5.pmp', buttons.start)
	    sound.volume(sound.MP3, currentLevel * 10)
        elseif selectedButton == 6 then
            -- Action for "Previous Menu"
            unloadButtons()
            Image.unload(bg)
	    Image.unload(creditstext)
            sound.play("assets/sounds/skeleton_1.wav", sound.WAV_1, false, false)
            sound.volume(sound.WAV_1, uiLevel * 10)
            break
        end
    end

    -- Draw buttons
    drawButtons()
    Image.draw(creditstext, 10, 38, 120, 13)
    
debugoverlay.draw(debugoverlay.loadSettings())
    screen.flip()
end
