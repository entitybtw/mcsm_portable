-- Load libs
local fade = 255
local welanim = 255
local step = -10
local delay_time = 4000
local c_black = Color.new(0, 0, 0)
local cos = math.cos
local stat = sound.state(sound.MP3)
local bg = Image.load('assets/mainmenu/bg.png')
local logo = Image.load('assets/mainmenu/logo.png')
local arrow = Image.load('assets/mainmenu/arrow.png')
local psp_buttons = Image.load('assets/mainmenu/mainmenu_buttons.png')
local welcome = Image.load('assets/mainmenu/welcome.png')
local arrowX = 27
local arrowStep = 0
local menumusicfile = io.open("assets/saves/menumusic.txt", "r")
local videofile = io.open("assets/saves/pmpvolume.txt", "r")
local uifile = io.open("assets/saves/uisounds.txt", "r")
if menumusicfile then
    local saved = tonumber(menumusicfile:read("*l"))
    if saved and saved >= 0 and saved <= 10 then
        currentLevel = saved
        sound.volume(sound.MP3, currentLevel * 10)
    end
    menumusicfile:close()
end
if videofile then
    local saveddd = tonumber(videoFile:read("*l"))
    if saveddd and saveddd >= 0 and saveddd <= 10 then
        videofile = savedd
     end
    videofile:close()
end
if uifile then
    local savedd = tonumber(uifile:read("*l"))
    if savedd and savedd >= 0 and savedd <= 10 then
        uiLevel = savedd
     end
    uifile:close()
end

timered = timer.create()

-- Load button images dynamically based on language
local buttonsList = {
    {
        normalImage = Image.load("assets/buttons/PLAY_ENG_STATIC.png"),
        selectedImage = Image.load("assets/buttons/PLAY_ENG_SELECTED.png")
    },
    {
        normalImage = Image.load("assets/buttons/SUPPORT_ENG_STATIC.png"),
        selectedImage = Image.load("assets/buttons/SUPPORT_ENG_SELECTED.png")
    },
    {
        normalImage = Image.load("assets/buttons/CREDITS_ENG_STATIC.png"),
        selectedImage = Image.load("assets/buttons/CREDITS_ENG_SELECTED.png")
    },
    {
        normalImage = Image.load("assets/buttons/SETTINGS_ENG_STATIC.png"),
        selectedImage = Image.load("assets/buttons/SETTINGS_ENG_SELECTED.png")
    }
}

-- Initialize navigation variables
local selectedButton = 1

-- Function to draw buttons
local function drawButtons()
    for i, button in ipairs(buttonsList) do
        local x = 35                 -- Horizontal position for all buttons
        local y = 100 + (i - 1) * 30 -- Vertical spacing between buttons

        if i == selectedButton then
            Image.draw(button.selectedImage, x, y) -- Highlight selected button
        else
            Image.draw(button.normalImage, x, y)
        end
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
    for k, v in pairs(buttonsList) do
        Image.unload(v.normalImage)
        Image.unload(v.selectedImage)
    end
end

if stat.state == "stopped" then
    sound.play("assets/sounds/bg.mp3", sound.MP3, false, true)
end

-- Main loop
while true do
    screen.clear()
    buttons.read() -- Read button input
    if fade_enabled == 1 then
    	if fade > 0 then fade = fade - 8 end
    end

    if timer.time(timered) == 0 then
        timer.start(timered)
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

    -- Background rendering
    Image.draw(bg, 0, 0)
    Image.draw(logo, 15, 45, 220, 50, white, 0, 0, 183, 37)
    Image.draw(psp_buttons, 35, 230, 150, 30, white, 0, 0, 183, 37)

    -- Navigation logic
    if buttons.pressed(buttons.up) and selectedButton > 1 then
        selectedButton = selectedButton - 1
        sound.play("assets/sounds/select.wav", sound.WAV_1, false, false)
	    sound.volume(sound.WAV_1, uiLevel * 10)
    end
    if buttons.pressed(buttons.down) and selectedButton < #buttonsList then
        selectedButton = selectedButton + 1
        sound.play("assets/sounds/select.wav", sound.WAV_1, false, false)
	    sound.volume(sound.WAV_1, uiLevel * 10)
    end

    if buttons.pressed(buttons.triangle) then
        LUA.quit()
    end

    -- Update arrow
    arrowStep = arrowStep + 0.1
    arrowX = 27 + cos(arrowStep) * 3
    if arrowX == 30 then
        arrowStep = 0
    end

    -- Action on "Cross" button
    if buttons.pressed(buttons.cross) then	
        if selectedButton == 1 then
            -- Action for "Play"
	        fade_enabled = 0
            -- sound.play("assets/sounds/click.wav", sound.WAV_1, false, false)
            -- LUA.sleep(550)
	        local epmenu = dofile("assets/mainmenu/epmenu/epmenu.lua")
            if epmenu == 1 then
                Image.unload(bg) 
	            Image.unload(logo)
                Image.unload(arrow)
	            Image.unload(psp_buttons)
	            Image.unload(welcome)
                unloadButtons()
                break
            end
        elseif selectedButton == 2 then
            -- Action for "Support"
	        fade_enabled = 0
            sound.play("assets/sounds/click.wav", sound.WAV_1, false, false)
	        sound.volume(sound.WAV_1, uiLevel * 10)
            dofile("assets/misc/support.lua")
        elseif selectedButton == 3 then
            -- Action for "Credits"
	        fade_enabled = 0
            sound.play("assets/sounds/click.wav", sound.WAV_1, false, false)
	        sound.volume(sound.WAV_1, uiLevel * 10)
            dofile("assets/misc/credits.lua")
        elseif selectedButton == 4 then
            -- Action for "Controls"
	        fade_enabled = 0
            sound.play("assets/sounds/click.wav", sound.WAV_1, false, false)
	        sound.volume(sound.WAV_1, uiLevel * 10)
            dofile("assets/misc/settings.lua")
        end
    end

    -- Draw buttons
    drawButtons()

    -- Draw arrows
    Image.draw(arrow, arrowX, 107, 14, 22)
    Image.draw(arrow, arrowX, 137, 14, 22)
    -- Update screen
    if fade_enabled == 1 then
        if fade > 0 then
    	    screen.drawRect(0, 0, 480, 272, c_black, 0, fade)
        end
    end
    Image.draw(welcome, 245, 200, 226, 49, white, 0, 0, 226, 49, 0, welanim)
    
    screen.flip()
end
