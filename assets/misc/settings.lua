-- load buttons


local selectedButton = 1

local btn_static = Image.load("assets/buttons/static.png")
local btn_selected = Image.load("assets/buttons/selected.png")

local buttonsList = {
    { text = "Controls" },
    { text = "Audio/Video" },
    { text = "Debug" },
    { text = "Credits" }
}


local function drawButtons()
    local startX = 35
    local startY = 50
    for i, button in ipairs(buttonsList) do
        local x = startX
        local y = startY + (i - 1) * (Image.H(btn_static) / 1.15)
        local bg = (i == selectedButton) and btn_selected or btn_static
        Image.draw(bg, x, y)

        local scale = 0.3
        local tw = intraFont.textW(font, button.text, scale)
        local th = intraFont.textH(font) * scale

        local tx = x + (Image.W(bg) - tw) / 2
        local ty = y + (Image.H(bg) - th)  / 2.7

        local color = (i == selectedButton)
            and Color.new(251, 238, 90)
            or Color.new(255, 255, 255)

        intraFont.printShadowed(
            tx,
            ty,
            button.text,
            color,
            Color.new(0, 0, 0),
            font,
            90,
            1,
            scale,
            0
        )
    end
end

local function unloadButtons()
    Image.unload(btn_static)
    Image.unload(btn_selected)
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
