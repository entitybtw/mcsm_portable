-- initialize variables
local fade = 255
local welanim = 255
local step = -10
local delay_time = 4000
local c_black = Color.new(0, 0, 0)
local cos = math.cos
local stat = sound.state(sound.MP3)
local logo = Image.load('assets/mainmenu/logo.png')
local arrow = Image.load('assets/mainmenu/arrow.png')
local psp_buttons = Image.load('assets/mainmenu/mainmenu_buttons.png')
local welcome = Image.load('assets/mainmenu/welcome.png')
local arrowX = 27
local arrowStep = 0
videoFrame = PMP.play("assets/mainmenu/mcsm_mainmenu.pmp", true, true, nil, nil, 29.97)

local timered = timer.create()
local welanim_duration = timer.create()

-- load buttons
local buttonsList = {
    {
        static = Image.load("assets/buttons/PLAY_ENG_STATIC.png"),
        selected = Image.load("assets/buttons/PLAY_ENG_SELECTED.png")
    },
    {
        static = Image.load("assets/buttons/SUPPORT_ENG_STATIC.png"),
        selected = Image.load("assets/buttons/SUPPORT_ENG_SELECTED.png")
    },
    {
        static = Image.load("assets/buttons/CHANGELOGS_ENG_STATIC.png"),
        selected = Image.load("assets/buttons/CHANGELOGS_ENG_SELECTED.png")
    },
    {
        static = Image.load("assets/buttons/SETTINGS_ENG_STATIC.png"),
        selected = Image.load("assets/buttons/SETTINGS_ENG_SELECTED.png")
    }
}

local selectedButton = 1

-- buttons draw function
local function drawButtons()
    for i, button in ipairs(buttonsList) do
        local x = 35
        local y = 100 + (i - 1) * 30

        if i == selectedButton then
            Image.draw(button.selected, x, y)
        else
            Image.draw(button.static, x, y)
        end
    end
end

-- stop_sound function
function stop_sound(channel)
    local state = sound.state(channel)
    if (state.state ~= "stopped") then
        sound.stop(channel)
    end
    sound.stop(channel)
end

-- unload buttons function
local function unloadButtons()
    for k, v in pairs(buttonsList) do
        Image.unload(v.static)
        Image.unload(v.selected)
    end
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
        welanim = 0
        timer.stop(timered)  -- останавливаем таймер timered после 10 секунд
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

    Image.draw(logo, 15, 45, 220, 50, white, 0, 0, 183, 37)
    Image.draw(psp_buttons, 35, 230, 145, 29, white, 0, 0, 183, 37)

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

    -- quit
    if buttons.pressed(buttons.triangle) then
        LUA.quit()
    end

    arrowStep = arrowStep + 0.2
    arrowX = 27 + cos(arrowStep) * 3
    if arrowStep == 360 then
   	arrowStep = 0
    end

    if buttons.pressed(buttons.cross) then	
        if selectedButton == 1 then
            -- play button
            fade = 0
            while fade < 255 do
                screen.clear()
                Image.draw(logo, 15, 45, 220, 50, white, 0, 0, 183, 37)
                drawButtons()
                Image.draw(arrow, arrowX, 107, 14, 22)
                Image.draw(arrow, arrowX, 137, 14, 22)
                Image.draw(welcome, 245, 200, 226, 49, white, 0, 0, 226, 49, 0, welanim)
                Image.draw(psp_buttons, 35, 230, 145, 29, white, 0, 0, 183, 37)
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
	            Image.unload(psp_buttons)
	            Image.unload(welcome)
                unloadButtons()
                break
            end
        elseif selectedButton == 2 then
            -- 'support' button
	        fade_enabled = 0
            sound.playEasy("assets/sounds/click.wav", sound.WAV_1, false, false)
	        sound.volumeEasy(sound.WAV_1, uiLevel * 10)
            dofile("assets/misc/support.lua")
        elseif selectedButton == 3 then
            -- 'changelogs' button
	        fade_enabled = 0
            sound.playEasy("assets/sounds/click.wav", sound.WAV_1, false, false)
	        sound.volumeEasy(sound.WAV_1, uiLevel * 10)
            dofile("assets/misc/changelogs.lua")
        elseif selectedButton == 4 then
            -- 'settings' button
	        fade_enabled = 0
            sound.playEasy("assets/sounds/click.wav", sound.WAV_1, false, false)
	        sound.volumeEasy(sound.WAV_1, uiLevel * 10)
            dofile("assets/misc/settings.lua")
        end
    end

    drawButtons()

    -- draw arrows
    Image.draw(arrow, arrowX, 107, 14, 22)
    Image.draw(arrow, arrowX, 137, 14, 22)
    
    -- fade
    if fade_enabled == 1 then
        if fade > 0 then
    	    screen.filledRect(0, 0, 480, 272, c_black, 0, fade)
        end
    end
    Image.draw(welcome, 245, 200, 226, 49, white, 0, 0, 226, 49, 0, welanim) -- 'welcome to minecraft story mode' popup
    debugoverlay.draw(debugoverlay.loadSettings()) -- debug text draw
    screen.flip()
end
