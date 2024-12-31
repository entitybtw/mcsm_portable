-- Load libraries
local stat = sound.state(sound.MP3)
local bg = Image.load('assets/mainmenu/bg.png')
local logo = Image.load('assets/mainmenu/logo.png')

-- Load button images dynamically based on language
local buttonsList = {
    {
        name = "Play",
        normalImage = Image.load("assets/buttons/PLAY_ENG_STATIC.png"),
        selectedImage = Image.load("assets/buttons/PLAY_ENG_SELECTED.png")
    },
    {
        name = "Credits",
        normalImage = Image.load("assets/buttons/CREDITS_ENG_STATIC.png"),
        selectedImage = Image.load("assets/buttons/CREDITS_ENG_SELECTED.png")
    },
    {
     	name = "Controls",
        normalImage = Image.load("assets/buttons/CONTROLS_ENG_STATIC.png"),
        selectedImage = Image.load("assets/buttons/CONTROLS_ENG_SELECTED.png")
    },
    {
        name = "Support",
        normalImage = Image.load("assets/buttons/SUPPORT_ENG_STATIC.png"),
        selectedImage = Image.load("assets/buttons/SUPPORT_ENG_SELECTED.png")
    }
}

-- Initialize navigation variables
local selectedButton = 1 -- 1: Play, 2: Credits, 3: Support

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
    sound.unload(channel)
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

    -- Background rendering
    Image.draw(bg, 0, 0)
    Image.draw(logo, 15, 45, 220, 50, white, 0, 0, 183, 37)

    -- Navigation logic
    if buttons.pressed(buttons.up) and selectedButton > 1 then
        selectedButton = selectedButton - 1
    end
    if buttons.pressed(buttons.down) and selectedButton < #buttonsList then
        selectedButton = selectedButton + 1
    end

    if buttons.pressed(buttons.triangle) then
        LUA.quit()
    end

    -- Action on "Cross" button
    if buttons.pressed(buttons.cross) then
        Image.unload(bg)
        Image.unload(logo)
	unloadButtons()
	
        if selectedButton == 1 then
            -- Action for "Play"
	    dofile("assets/mainmenu/epmenu/epmenu.lua")
        elseif selectedButton == 2 then
            -- Action for "Credits"
            dofile("assets/misc/credits.lua")
        elseif selectedButton == 3 then
            -- Action for "Controls"
            dofile("assets/misc/controls.lua")
        elseif selectedButton == 4 then
            -- Action for "Support"
            dofile("assets/misc/support.lua")
        end
    end

    -- Draw buttons
    drawButtons()
    -- Update screen
    screen.flip()

end
