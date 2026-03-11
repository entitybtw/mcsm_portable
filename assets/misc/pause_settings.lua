local buttonsList = {
    { text = ui.controls },
    { text = ui.audiovideo },
    { text = ui.debug }
}

local selectedButton = 1
local buttonSprites = {
    selected = { srcx = 0, srcy = 164, srcw = 183, srch = 25 },
    static = { srcx = 184, srcy = 165, srcw = 183, srch = 25 }
}

local function drawButtons()
    local startX, startY, gap = 150, 40, 5
    for i, button in ipairs(buttonsList) do
        local sprite = (i == selectedButton) and buttonSprites.selected or buttonSprites.static
        local y = startY + (i - 1) * (sprite.srch + gap)
        
        Image.draw(spritesheet, startX, y, sprite.srcw, sprite.srch, nil, 
                   sprite.srcx, sprite.srcy, sprite.srcw, sprite.srch, nil, nil, nil)

        local scale = 0.3
        local textColor = (i == selectedButton) and Color.new(251, 238, 90) or Color.new(255, 255, 255)
        local textWidth = intraFont.textW(font, button.text, scale)
        local textHeight = intraFont.textH(font) * scale
        
        intraFont.printShadowed(
            startX + (sprite.srcw - textWidth) / 2,
            y + (sprite.srch - textHeight) / 4,
            button.text, textColor, Color.new(0, 0, 0),
            font, 90, 1, scale, 0
        )
    end
end

while true do
    screen.clear()
    buttons.read()

    Image.draw(pause_bg, 0, 0)
    intraFont.printShadowed(230 - intraFont.textW(font, "Settings", 0.3) / 2 + 14, 25, "Settings", Color.new(255,255,255), Color.new(0, 0, 0), font, 90, 1, 0.3, 0)
    Image.draw(spritesheet, 240 - (14 + intraFont.textW(font, "Select", 0.3) + 7 + 14 + intraFont.textW(font, "Previous Menu", 0.3)) / 2, 246, 14, 14, nil, 399, 0, 15, 15)
    intraFont.printShadowed(240 - (14 + intraFont.textW(font, "Select", 0.3) + 10 + 14 + intraFont.textW(font, "Previous Menu", 0.3)) / 2 + 14 + 5, 247, "Select", Color.new(255,255,255), Color.new(0,0,0), font, 90, 1, 0.3, 0)
    Image.draw(spritesheet, 240 - (14 + intraFont.textW(font, "Select", 0.3) + 7 + 14 + intraFont.textW(font, "Previous Menu", 0.3)) / 2 + 14 + intraFont.textW(font, "Select", 0.3) + 10, 246, 14, 14, nil, 384, 0, 15, 15)
    intraFont.printShadowed(240 - (14 + intraFont.textW(font, "Select", 0.3) + 10 + 14 + intraFont.textW(font, "Previous Menu", 0.3)) / 2 + 14 + intraFont.textW(font, "Select", 0.3) + 10 + 14 + 5, 247, "Previous Menu", Color.new(255,255,255), Color.new(0,0,0), font, 90, 1, 0.3, 0)
    
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
        sound.playEasy("assets/sounds/skeleton_1.wav", sound.WAV_1, false, false)
        sound.volumeEasy(sound.WAV_1, uiLevel * 10)
        break
    end
    if buttons.pressed(buttons.cross) then    
        if selectedButton == 1 then
            sound.playEasy("assets/sounds/click.wav", sound.WAV_1, false, false)
            sound.volumeEasy(sound.WAV_1, uiLevel * 10)
            dofile("assets/misc/pause_controls.lua")
        elseif selectedButton == 2 then
            sound.playEasy("assets/sounds/click.wav", sound.WAV_1, false, false)
            sound.volumeEasy(sound.WAV_1, uiLevel * 10)
            dofile("assets/misc/pause_audio_video.lua")
        elseif selectedButton == 3 then
            sound.playEasy("assets/sounds/click.wav", sound.WAV_1, false, false)
            sound.volumeEasy(sound.WAV_1, uiLevel * 10)
            dofile("assets/misc/pause_debug.lua")
        end
    end

    drawButtons()
    debugoverlay.draw(debugoverlay.loadSettings())
    screen.flip()
end