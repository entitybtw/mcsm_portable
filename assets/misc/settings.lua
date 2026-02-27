local selectedButton = 1
local buttonsList = {
    { text = "Controls" },
    { text = "Audio/Video" },
    { text = "Debug" },
    { text = "Credits" }
}

local buttonSprites = {
    selected = { srcx = 0, srcy = 164, srcw = 183, srch = 25 },
    static = { srcx = 184, srcy = 165, srcw = 183, srch = 25 }
}

local function drawButtons()
    local startX, startY, gap = 35, 50, 5
    
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
       break
    end

    drawButtons()

    debugoverlay.draw(debugoverlay.loadSettings())
    intraFont.printShadowed(40, 35, "Settings", Color.new(255, 255, 255), Color.new(0, 0, 0), font, 90, 1, 0.3, 0)
    Image.draw(spritesheet, 40, 233, 14, 14, nil, 399, 0, 15, 15)
    intraFont.printShadowed(38 + 14 + 5, 234, "Select", Color.new(255,255,255), Color.new(0,0,0), font, 90, 1, 0.3, 0)
    Image.draw(spritesheet, 40 + 14 + intraFont.textW(font, "Select", 0.3) + 10, 233, 14, 14, nil, 384, 0, 15, 15)
    intraFont.printShadowed(38 + 14 + intraFont.textW(font, "Select", 0.3) + 10 + 14 + 5, 234, "Previous Menu", Color.new(255,255,255), Color.new(0,0,0), font, 90, 1, 0.3, 0)    
    screen.flip()
end