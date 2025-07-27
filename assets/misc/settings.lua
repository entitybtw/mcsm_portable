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
    }
}

local selectedButton = 1
local circle = Image.load("assets/icons/circle.png")
local cross = Image.load("assets/icons/cross.png")

local function drawButtons()
    for i, button in ipairs(buttonsList) do
        local x = 35
        local y = 50 + (i - 1) * 30

        if i == selectedButton then
            Image.draw(button.selected, x, y)
        else
            Image.draw(button.static, x, y)
        end
    end
end

local function unloadButtons()
    for _, v in ipairs(buttonsList) do
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
            sound.playEasy("assets/sounds/click.wav", sound.WAV_1, false, false)
            sound.volumeEasy(sound.WAV_1, uiLevel * 10)
            dofile("assets/misc/controls.lua")
        elseif selectedButton == 2 then
            sound.playEasy("assets/sounds/click.wav", sound.WAV_1, false, false)
            sound.volumeEasy(sound.WAV_1, uiLevel * 10)
            dofile("assets/misc/audio_video.lua")
        elseif selectedButton == 3 then
            sound.playEasy("assets/sounds/click.wav", sound.WAV_1, false, false)
            sound.volumeEasy(sound.WAV_1, uiLevel * 10)
            dofile("assets/misc/debug.lua")
        elseif selectedButton == 4 then
            sound.playEasy("assets/sounds/click.wav", sound.WAV_1, false, false)
            sound.volumeEasy(sound.WAV_1, uiLevel * 10)
            dofile("assets/misc/credits_episodes.lua")
        end
    end
    if buttons.pressed(buttons.circle) then    
       sound.playEasy("assets/sounds/skeleton_1.wav", sound.WAV_1, false, false)
       unloadButtons()
       Image.unload(circle)
       Image.unload(cross)
       break
    end

    drawButtons()

    debugoverlay.draw(debugoverlay.loadSettings())
    intraFont.printShadowed(40, 40, "Settings", Color.new(255, 255, 255), Color.new(0, 0, 0), font, 90, 1, 0.3, 0)
    Image.draw(cross, 40, 233, 14, 14)
    intraFont.printShadowed(38 + 14 + 5, 234, "Select", Color.new(255,255,255), Color.new(0,0,0), font, 90, 1, 0.3, 0)
    Image.draw(circle, 40 + 14 + intraFont.textW(font, "Select", 0.3) + 10, 233, 14, 14)
    intraFont.printShadowed(38 + 14 + intraFont.textW(font, "Select", 0.3) + 10 + 14 + 5, 234, "Previous Menu", Color.new(255,255,255), Color.new(0,0,0), font, 90, 1, 0.3, 0)    
    screen.flip()
end
