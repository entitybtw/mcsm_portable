local fade = 255
local welanim = 255
local step = -10
local delay_time = 4000
local c_black = Color.new(0, 0, 0)
local cos = math.cos
local stat = sound.state(5)
local arrowX = 27
local arrowStep = 0
videoFrame = PMP.play("assets/ui/mcsm_mainmenu.pmp", true, true, nil, nil, 29.97)

local timered = timer.create()
local welanim_duration = timer.create()

local buttonsList = {
    { text = ui.play },
    { text = ui.support },
    { text = ui.changelogs },
    { text = ui.settings }
}

local selectedButton = 1

local buttonSprites = {
    selected = { srcx = 0, srcy = 164, srcw = 183, srch = 25 },
    static = { srcx = 184, srcy = 165, srcw = 183, srch = 25 }
}

local function drawButtons()
    local startX, startY, gap = 35, 105, 5
    
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

function stop_sound(channel)
    local state = sound.state(channel)
    if (state.state ~= "stopped") then
        sound.stop(channel)
    end
    sound.stop(channel)
end

if stat.state == "stopped" then
    sound.playEasy("assets/sounds/bg.at3", 5)
end

while true do
    screen.clear()
    buttons.read()
    if PMP.getFrame(videoFrame) then
        Image.draw(videoFrame, 0, 0)
    end

    if fade_enabled == 1 then
        if fade > 0 then fade = fade - 8 end
    end

    if timer.time(timered) == 0 then
        timer.start(timered)
    end

    if timer.time(welanim_duration) == 1 then
        timer.start(welanim_duration)
    end

    if timer.time(welanim_duration) >= 26000 then
        welanim = 0
        timer.stop(timered)
    end

    if timer.time(timered) >= delay_time then
        welanim = welanim + step
        if welanim >= 255 then
            welanim = 255
            step = -10
            timer.reset(timered)
        elseif welanim <= 1 then
            welanim = 1
            step = 10
            timer.reset(timered)
        end
    end

    Image.draw(spritesheet, 32, 38, 190, 61, nil, 0, 48, 210, 61, nil, nil, nil, true)
    intraFont.printShadowed(57, 237, "Select", Color.new(255, 255, 255), Color.new(0, 0, 0), font, 90, 1, 0.3, 0)
    Image.draw(spritesheet, 40, 233, 14, 14, nil, 399, 0, 15, 15)

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

    if buttons.pressed(buttons.triangle) then
        LUA.quit()
    end

    arrowStep = arrowStep + 0.2
    arrowX = 27 + cos(arrowStep) * 3
    if arrowStep >= 360 then
        arrowStep = 0
    end

    if buttons.pressed(buttons.cross) then
        if selectedButton == 1 then
            fade = 0
            while fade < 255 do
                screen.clear()
                Image.draw(spritesheet, 32, 38, 190, 61, nil, 0, 48, 210, 61, nil, nil, nil, true)
                drawButtons()
                Image.draw(spritesheet, arrowX, 107, 14, 22, nil, 444, 0, 7, 11)
                Image.draw(spritesheet, arrowX, 137, 14, 22, nil, 444, 0, 7, 11)
                Image.draw(spritesheet, 245, 200, 226, 49, white, 2, 111, 226, 49, 0, welanim)
                Image.draw(spritesheet, 40, 233, 14, 14, nil, 399, 0, 15, 15)
                intraFont.printShadowed(57, 237, "Select", Color.new(255, 255, 255), Color.new(0, 0, 0), font, 90, 1, 0.3, 0)
                screen.filledRect(0, 0, 480, 272, c_black, 0, fade)
                screen.flip()
                fade = fade + 8
            end
            fade_enabled = 0
            sound.playEasy("assets/sounds/click.wav", sound.WAV_1, false, false)
            sound.volumeEasy(sound.WAV_1, uiLevel * 10)
            PMP.stop(videoFrame)
            local epmenu = dofile("assets/ui/epmenu/epmenu.lua")
            if epmenu == 1 then
                break
            end
        elseif selectedButton == 2 then
            fade_enabled = 0
            sound.playEasy("assets/sounds/click.wav", sound.WAV_1, false, false)
            sound.volumeEasy(sound.WAV_1, uiLevel * 10)
            dofile("assets/misc/support.lua")
        elseif selectedButton == 3 then
            fade_enabled = 0
            sound.playEasy("assets/sounds/click.wav", sound.WAV_1, false, false)
            sound.volumeEasy(sound.WAV_1, uiLevel * 10)
            dofile("assets/misc/changelogs.lua")
        elseif selectedButton == 4 then
            fade_enabled = 0
            sound.playEasy("assets/sounds/click.wav", sound.WAV_1, false, false)
            sound.volumeEasy(sound.WAV_1, uiLevel * 10)
            dofile("assets/misc/settings.lua")
        end
    end

    drawButtons()
    Image.draw(spritesheet, arrowX, 107, 14, 22, nil, 444, 0, 7, 11)
    Image.draw(spritesheet, arrowX, 137, 14, 22, nil, 444, 0, 7, 11)

    if fade_enabled == 1 and fade > 0 then
        screen.filledRect(0, 0, 480, 272, c_black, 0, fade)
    end

    Image.draw(spritesheet, 245, 200, 226, 49, white, 2, 111, 225, 48, 0, welanim)
    intraFont.printShadowed(270, 205, "Welcome to Minecraft: Story Mode!", Color.new(255, 255, 255, welanim), Color.new(0, 0, 0, welanim), font, 90, 1, 0.3, 0)
    intraFont.printShadowed(335, 225, "Visit mcsm_portable github page!", Color.new(255, 255, 255, welanim), Color.new(0, 0, 0, welanim), font, 90, 1, 0.2, 0)

    debugoverlay.draw(debugoverlay.loadSettings())
    screen.flip()
end