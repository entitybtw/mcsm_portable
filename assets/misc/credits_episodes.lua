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
    }
}

local selectedButton = 1
local buttonz = Image.load("assets/mainmenu/previousmenu_eng.png")

-- Function to draw buttons
local function drawButtons()
    for i, button in ipairs(buttonsList) do
        local x = 35                 -- horizontal position for all buttons
        local y = 50 + (i - 1) * 30 -- vertical spacing between buttons

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

    if PMP.getFrame(videoFrame) then
        Image.draw(videoFrame, 0, 0)
    end

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

    if buttons.pressed(buttons.cross) then    
        if selectedButton == 1 then
            -- 'episode 1' button
	        PMP.setVolume(pmpvolume)
	        sound.volumeEasy(sound.MP3, 0)
            PMP.stop(videoFrame)
            sound.playEasy("assets/sounds/click.wav", sound.WAV_1, false, false)
            sound.volumeEasy(sound.WAV_1, uiLevel * 10)
            PMP.play('assets/video/credits/ep1.pmp', false, nil, buttons.start)
            videoFrame = PMP.play("assets/mainmenu/mcsm_mainmenu.pmp", true, nil, nil, 29.97)
	    sound.volumeEasy(sound.MP3, menumusic * 10)
        elseif selectedButton == 2 then
            -- 'episode 2' button
	        PMP.setVolume(pmpvolume)
	        sound.volumeEasy(sound.MP3, 0)
            PMP.stop(videoFrame)
            sound.playEasy("assets/sounds/click.wav", sound.WAV_1, false, false)
            sound.volumeEasy(sound.WAV_1, uiLevel * 10)
            PMP.play('assets/video/credits/ep2.pmp', false, nil, buttons.start)
            videoFrame = PMP.play("assets/mainmenu/mcsm_mainmenu.pmp", true, nil, nil, 29.97)
	    sound.volumeEasy(sound.MP3, menumusic * 10)
        elseif selectedButton == 3 then
            -- 'episode 3' button
	        PMP.setVolume(pmpvolume)
	        sound.volumeEasy(sound.MP3, 0)
            PMP.stop(videoFrame)
            sound.playEasy("assets/sounds/click.wav", sound.WAV_1, false, false)
            sound.volumeEasy(sound.WAV_1, uiLevel * 10)
            PMP.play('assets/video/credits/ep3.pmp', false, nil, buttons.start)
            videoFrame = PMP.play("assets/mainmenu/mcsm_mainmenu.pmp", true, nil, nil, 29.97)
	    sound.volumeEasy(sound.MP3, menumusic * 10)
        elseif selectedButton == 4 then
            -- 'episode 4' button
	        PMP.setVolume(pmpvolume)
	        sound.volumeEasy(sound.MP3, 0)
            PMP.stop(videoFrame)
            sound.playEasy("assets/sounds/click.wav", sound.WAV_1, false, false)
            sound.volumeEasy(sound.WAV_1, uiLevel * 10)
            PMP.play('assets/video/credits/ep4.pmp', false, nil, buttons.start)
            videoFrame = PMP.play("assets/mainmenu/mcsm_mainmenu.pmp", true, nil, nil, 29.97)
	    sound.volumeEasy(sound.MP3, menumusic * 10)
        elseif selectedButton == 5 then
            -- 'episode 5' button
	        PMP.setVolume(pmpvolume)
            sound.volumeEasy(sound.MP3, 0)
            PMP.stop(videoFrame)
            sound.playEasy("assets/sounds/click.wav", sound.WAV_1, false, false)
            sound.volumeEasy(sound.WAV_1, uiLevel * 10)
            PMP.play('assets/video/credits/ep5.pmp', false, nil, buttons.start)
            videoFrame = PMP.play("assets/mainmenu/mcsm_mainmenu.pmp", true, nil, nil, 29.97)
	    sound.volumeEasy(sound.MP3, menumusic * 10)
        end
    end
    if buttons.pressed(buttons.circle) then
        sound.playEasy("assets/sounds/skeleton_1.wav", sound.WAV_1, false, false)
        unloadButtons()
        Image.unload(buttonz)
        break
    end

    drawButtons() -- draw buttons
    
    debugoverlay.draw(debugoverlay.loadSettings())
    intraFont.print(40, 40, "Credits", Color.new(255, 255, 255), font, 0.3)
    Image.draw(buttonz, 35, 230, 145, 29)
    screen.flip()
end
