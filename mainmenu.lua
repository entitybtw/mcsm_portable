local fade = 255
local welanim = 255
local step = -10
local delay_time = 4000
local c_black = Color.new(0, 0, 0)
local cos = math.cos
local stat = sound.state(sound.MP3)
local logo = Image.load('assets/mainmenu/logo.png')
local arrow = Image.load('assets/mainmenu/arrow.png')
local cross = Image.load('assets/icons/cross.png')
local welcome = Image.load('assets/mainmenu/welcome.png')
local arrowX = 27
local arrowStep = 0
videoFrame = PMP.play("assets/mainmenu/mcsm_mainmenu.pmp", true, true, nil, nil, 29.97)

local timered = timer.create()
local welanim_duration = timer.create()

local btn_static = Image.load("assets/buttons/static.png")
local btn_selected = Image.load("assets/buttons/selected.png")

local buttonsList = {
    { text = "Play" },
    { text = "Support" },
    { text = "Changelogs" },
    { text = "Settings" }
}

local selectedButton = 1

local function drawButtons()
    local startX = 35
    local startY = 100
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


function stop_sound(channel)
    local state = sound.state(channel)
    if (state.state ~= "stopped") then
        sound.stop(channel)
    end
    sound.stop(channel)
end

local function unloadButtons()
    Image.unload(btn_static)
    Image.unload(btn_selected)
end

if stat.state == "stopped" then
    sound.playEasy("assets/sounds/bg.mp3", sound.MP3)
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

    if timer.time(welanim_duration) == 0 then
        timer.start(welanim_duration)
    end

    if timer.time(welanim_duration) >= 26000 then
        welanim = -1
        timer.stop(timered)
    end

    if timer.time(timered) >= delay_time then
        welanim = welanim + step
        if welanim >= 255 then
            welanim = 255
            step = -10
            timer.reset(timered)
        elseif welanim <= 0 then
            welanim = 0
            step = 10
            timer.reset(timered)
        end
    end

    Image.draw(logo, 32, 38, 190, 61, nil, nil, nil, nil, nil, nil, nil, nil, true)
    intraFont.printShadowed(57, 234, "Select", Color.new(255, 255, 255), Color.new(0, 0, 0), font, 90, 1, 0.3, 0)
    Image.draw(cross, 40, 233, 14, 14)

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
                Image.draw(logo, 32, 38, 190, 61)
                drawButtons()
                Image.draw(arrow, arrowX, 107, 14, 22)
                Image.draw(arrow, arrowX, 137, 14, 22)
                Image.draw(welcome, 245, 200, 226, 49, white, 0, 0, 226, 49, 0, welanim)
                Image.draw(cross, 40, 233, 14, 14)
                intraFont.printShadowed(57, 234, "Select", Color.new(255, 255, 255), Color.new(0, 0, 0), font, 90, 1, 0.3, 0)
                screen.filledRect(0, 0, 480, 272, c_black, 0, fade)
                screen.flip()
                fade = fade + 8
            end
            fade_enabled = 0
            sound.playEasy("assets/sounds/click.wav", sound.WAV_1, false, false)
            sound.volumeEasy(sound.WAV_1, uiLevel * 10)
            PMP.stop(videoFrame)
            local epmenu = dofile("assets/mainmenu/epmenu/epmenu.lua")
            if epmenu == 1 then
                Image.unload(logo)
                Image.unload(arrow)
                Image.unload(cross)
                Image.unload(welcome)
                unloadButtons()
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

    Image.draw(arrow, arrowX, 107, 14, 22)
    Image.draw(arrow, arrowX, 137, 14, 22)

    if fade_enabled == 1 then
        if fade > 0 then
            screen.filledRect(0, 0, 480, 272, c_black, 0, fade)
        end
    end
    if welanim > -1 then 
    Image.draw(welcome, 245, 200, 226, 49, white, 0, 0, 226, 49, 0, welanim)
    intraFont.printShadowed(270, 205, "Welcome to Minecraft: Story Mode!", Color.new(255, 255, 255, welanim), Color.new(0, 0, 0, welanim), font, 90, 1, 0.3, 0)
    intraFont.printShadowed(335, 225, "Visit mcsm_portable github page!", Color.new(255, 255, 255, welanim), Color.new(0, 0, 0, welanim), font, 90, 1, 0.2, 0)
    end
    debugoverlay.draw(debugoverlay.loadSettings())
    screen.flip()
end
