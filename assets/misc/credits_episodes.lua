local buttonsList = {
    { text = ui.episode .. " 1" },
    { text = ui.episode .. " 2" },
    { text = ui.episode .. " 3" },
    { text = ui.episode .. " 4" },
    { text = ui.episode .. " 5" }
}

local selectedButton = 1
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
            PMP.setVolume(pmpvolume)
            sound.volumeEasy(5, 0)
            PMP.stop(videoFrame)
            sound.playEasy("assets/sounds/click.wav", sound.WAV_1, false, false)
            sound.volumeEasy(sound.WAV_1, uiLevel * 10)
            PMP.play('assets/video/credits/ep1.pmp', false, false, nil, buttons.start)
            videoFrame = PMP.play("assets/ui/mcsm_mainmenu.pmp", true, nil, nil, 29.97)
            sound.volumeEasy(5, menumusic * 10)
        elseif selectedButton == 2 then
            PMP.setVolume(pmpvolume)
            sound.volumeEasy(5, 0)
            PMP.stop(videoFrame)
            sound.playEasy("assets/sounds/click.wav", sound.WAV_1, false, false)
            sound.volumeEasy(sound.WAV_1, uiLevel * 10)
            PMP.play('assets/video/credits/ep2.pmp', false, false, nil, buttons.start)
            videoFrame = PMP.play("assets/ui/mcsm_mainmenu.pmp", true, nil, nil, 29.97)
            sound.volumeEasy(5, menumusic * 10)
        elseif selectedButton == 3 then
            PMP.setVolume(pmpvolume)
            sound.volumeEasy(5, 0)
            PMP.stop(videoFrame)
            sound.playEasy("assets/sounds/click.wav", sound.WAV_1, false, false)
            sound.volumeEasy(sound.WAV_1, uiLevel * 10)
            PMP.play('assets/video/credits/ep3.pmp', false, false, nil, buttons.start)
            videoFrame = PMP.play("assets/ui/mcsm_mainmenu.pmp", true, nil, nil, 29.97)
            sound.volumeEasy(5, menumusic * 10)
        elseif selectedButton == 4 then
            PMP.setVolume(pmpvolume)
            sound.volumeEasy(5, 0)
            PMP.stop(videoFrame)
            sound.playEasy("assets/sounds/click.wav", sound.WAV_1, false, false)
            sound.volumeEasy(sound.WAV_1, uiLevel * 10)
            PMP.play('assets/video/credits/ep4.pmp', false, false, nil, buttons.start)
            videoFrame = PMP.play("assets/ui/mcsm_mainmenu.pmp", true, nil, nil, 29.97)
            sound.volumeEasy(5, menumusic * 10)
        elseif selectedButton == 5 then
            PMP.setVolume(pmpvolume)
            sound.volumeEasy(5, 0)
            PMP.stop(videoFrame)
            sound.playEasy("assets/sounds/click.wav", sound.WAV_1, false, false)
            sound.volumeEasy(sound.WAV_1, uiLevel * 10)
            PMP.play('assets/video/credits/ep5.pmp', false, false, nil, buttons.start)
            videoFrame = PMP.play("assets/ui/mcsm_mainmenu.pmp", true, nil, nil, 29.97)
            sound.volumeEasy(5, menumusic * 10)
        end
    end
    if buttons.pressed(buttons.circle) then
        sound.playEasy("assets/sounds/skeleton_1.wav", sound.WAV_1, false, false)
        break
    end

    drawButtons()
    debugoverlay.draw(debugoverlay.loadSettings())
    intraFont.printShadowed(40, 35, "Credits", Color.new(255, 255, 255), Color.new(0, 0, 0), font, 90, 1, 0.3, 0)
    Image.draw(spritesheet, 40, 233, 14, 14, nil, 384, 0, 15, 15)
    intraFont.printShadowed(57, 234, "Previous Menu", Color.new(255, 255, 255), Color.new(0, 0, 0), font, 90, 1, 0.3, 0)
    screen.flip()
end