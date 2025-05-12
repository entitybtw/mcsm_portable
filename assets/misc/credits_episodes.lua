local bg = Image.load('assets/mainmenu/bg.png') -- load bg
local creditstext = Image.load("assets/mainmenu/settings/viewcredits_text.png") -- load creditstext

-- load buttons
local buttonsList = {
    {
        static = Image.load("assets/buttons/EP1_ENG_STATIC.png"),
        selected = Image.load("assets/buttons/EP1_ENG_SELECTED.png")
    },
    {
        static = Image.load("assets/buttons/EP2_ENG_STATIC.png"),
        selected = Image.load("assets/buttons/EP2_ENG_SELECTED.png")
    },
    {
        static = Image.load("assets/buttons/EP3_ENG_STATIC.png"),
        selected = Image.load("assets/buttons/EP3_ENG_SELECTED.png")
    },
    {
        static = Image.load("assets/buttons/EP4_ENG_STATIC.png"),
        selected = Image.load("assets/buttons/EP4_ENG_SELECTED.png")
    },
    {
        static = Image.load("assets/buttons/EP5_ENG_STATIC.png"),
        selected = Image.load("assets/buttons/EP5_ENG_SELECTED.png")
    },
    {
        static = Image.load("assets/buttons/PREVIOUSMENU_ENG_STATIC.png"),
        selected = Image.load("assets/buttons/PREVIOUSMENU_ENG_SELECTED.png")
    }
}

local selectedButton = 1

-- Function to draw buttons
local function drawButtons()
    for i, button in ipairs(buttonsList) do
        local x = 35                 -- horizontal position for all buttons
        local y = 50 + (i - 1) * 30 -- vertical spacing between buttons

        -- if its last button, add extra space
        if i == #buttonsList then
            y = 20 + (i - 1) * 30 + 50
            x = 0
        end

        if i == selectedButton then
            Image.draw(button.selected, x, y)
        else
            Image.draw(button.static, x, y)
        end
    end
end

-- unload buttons function
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
    end
    if buttons.pressed(buttons.down) and selectedButton < #buttonsList then
        selectedButton = selectedButton + 1
        sound.play("assets/sounds/select.wav", sound.WAV_1, false, false)
    end

    if buttons.pressed(buttons.cross) then    
        if selectedButton == 1 then
            -- episode 1 button
	        PMP.setVolume(pmpvolume)
	        sound.volume(sound.MP3, 0)
            PMP.play('assets/video/credits/ep1.pmp', buttons.start)
	    sound.volume(sound.MP3, currentLevel * 10)
        elseif selectedButton == 2 then
            -- episode 2 button
	        PMP.setVolume(pmpvolume)
	        sound.volume(sound.MP3, 0)
            PMP.play('assets/video/credits/ep2.pmp', buttons.start)
	    sound.volume(sound.MP3, currentLevel * 10)
        elseif selectedButton == 3 then
            -- episode 3 button
	        PMP.setVolume(pmpvolume)
	        sound.volume(sound.MP3, 0)
            PMP.play('assets/video/credits/ep3.pmp', buttons.start)
	    sound.volume(sound.MP3, currentLevel * 10)
        elseif selectedButton == 4 then
            -- episode 4 button
	        PMP.setVolume(pmpvolume)
	        sound.volume(sound.MP3, 0)
            PMP.play('assets/video/credits/ep4.pmp', buttons.start)
	    sound.volume(sound.MP3, currentLevel * 10)
        elseif selectedButton == 5 then
            -- episode 5 button
	        PMP.setVolume(pmpvolume)
            sound.volume(sound.MP3, 0)
            PMP.play('assets/video/credits/ep5.pmp', buttons.start)
	    sound.volume(sound.MP3, currentLevel * 10)
        elseif selectedButton == 6 then
            -- previous menu button
            unloadButtons()
            Image.unload(bg)
	        Image.unload(creditstext)
            sound.play("assets/sounds/skeleton_1.wav", sound.WAV_1, false, false)
            sound.volume(sound.WAV_1, uiLevel * 10)
            break
        end
    end

    drawButtons() -- draw buttons
    Image.draw(creditstext, 10, 38, 120, 13) -- draw creditstext
    
    debugoverlay.draw(debugoverlay.loadSettings())
    screen.flip()
end
