local bg = Image.load("assets/mainmenu/pause_bg.png")


-- load buttons
local btn_static = Image.load("assets/buttons/static.png")
local btn_selected = Image.load("assets/buttons/selected.png")

local buttonsList = {
    { text = "Controls" },
    { text = "Audio/Video" },
    { text = "Debug" }
}

local selectedButton = 1

local function drawButtons()
    local startX = 150
    local startY = 40
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

    

    Image.draw(bg, 0, 0)
    intraFont.printShadowed(230 - intraFont.textW(font, "Settings", 0.3) / 2 + 14, 25, "Settings", Color.new(255,255,255), Color.new(0, 0, 0), font, 90, 1, 0.3, 0)
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
