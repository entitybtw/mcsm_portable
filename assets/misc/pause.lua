sound.playEasy("assets/sounds/pause_bg.at3", 5, true, false)
sound.volumeEasy(sound.WAV_2, menumusic * 10)
local fade = 255
local c_black = Color.new(0, 0, 0)
local fade_enabled = 1

local buttonsList = {
    { text = "Resume Game" },
    { text = "Settings" },
    { text = "Main Menu" },
    { text = "Exit Game" }
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

    if fade_enabled == 1 and fade > 0 then
        fade = fade - 2
        if fade < 0 then fade = 0 end
    end    

    Image.draw(pause_bg, 0, 0)
    intraFont.printShadowed(230 - intraFont.textW(font, "Paused", 0.3) / 2 + 14, 25, "Paused", Color.new(255,255,255), Color.new(0, 0, 0), font, 90, 1, 0.3, 0)
    Image.draw(circle, 240 - intraFont.textW(font, "Resume Game", 0.3) / 2 - 8, 233 + 13, 14, 14, nil, nil, nil, nil, nil, nil)
    intraFont.printShadowed(240 - intraFont.textW(font, "Resume Game", 0.3) / 2 + 8, 233 + 14, "Resume Game", Color.new(255,255,255), Color.new(0, 0, 0), font, 90, 1, 0.3, 0) 

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
        PMP.pause()
        break
    end
    if buttons.pressed(buttons.cross) then    
        if selectedButton == 1 then
            sound.playEasy("assets/sounds/click.wav", sound.WAV_1, false, false)
            sound.volumeEasy(sound.WAV_1, uiLevel * 10)
            PMP.pause()
            System.GC()
            break
        elseif selectedButton == 2 then
            sound.playEasy("assets/sounds/click.wav", sound.WAV_1, false, false)
            sound.volumeEasy(sound.WAV_1, uiLevel * 10)
            System.GC()
            dofile("assets/misc/pause_settings.lua")
        elseif selectedButton == 3 then
            sound.playEasy("assets/sounds/click.wav", sound.WAV_1, false, false)
            sound.volumeEasy(sound.WAV_1, uiLevel * 10)
            System.GC()
            return -1
        elseif selectedButton == 4 then
            sound.playEasy("assets/sounds/click.wav", sound.WAV_1, false, false)
            sound.volumeEasy(sound.WAV_1, uiLevel * 10)
            LUA.exit()
        end
    end

    drawButtons()
    debugoverlay.draw(debugoverlay.loadSettings())
    if fade_enabled == 1 and fade > 0 then
        screen.filledRect(0, 0, 480, 272, c_black, 0, fade)
    end    
    screen.flip()
end