local choosing = true
local square = Image.load("assets/icons/square.png")
local circle = Image.load("assets/icons/circle.png")

local path = System.LoadData("assets/mainmenu/saves_bg.png")
if path then
    PMP.setVolume(pmpvolume)
local result =     PMP.playEasy("assets/mainmenu/loading.pmp")
if result == 1 then
    nextscene = "./mainmenu.lua"
    return 1
end
    nextscene = path.data
        local variablesFile = io.open("assets/saves/5_variables.txt", "r")
    if variablesFile then
        for line in variablesFile:lines() do
            local key, value = line:match("^(%w+) = \"([^\"]+)\"$")
            if key and value then
                _G[key] = value
            end
        end
        variablesFile:close()
    end
    return 1
end

local result = PMP.playEasy('assets/video/episode5/start.pmp', buttons.r, true, 'assets/video/episode5/start.srt', font, subssize, "#FFFFFF", "#000000/150", subs)
if result == 1 then
    nextscene = "./mainmenu.lua"
    return 1
end


Image.draw(square, 25, 127)
Image.draw(circle, 455, 127)
intraFont.print(45, 127, "For glory!", Color.new(255,255,255), font, 0.4)
intraFont.print(450 - intraFont.textW(font, "Let's find treasure!", 0.4), 127, "Let's find treasure!", Color.new(255,255,255), font, 0.4)
intraFont.print(340 - intraFont.textW(font, "Press R to save", 0.63), 230, "Press R to save", Color.new(255,255,255, 150), font, 0.63)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()

while choosing do
    buttons.read()

    if buttons.pressed(buttons.square) then
        Image.unload(square)
        Image.unload(circle)
        choosing = false
        nextscene = "assets/video/episode5/for_glory.lua"
    elseif buttons.pressed(buttons.circle) then
        Image.unload(square)
        Image.unload(circle)
        choosing = false
        nextscene = "assets/video/episode5/lets_find_treasure.lua"
    elseif buttons.pressed(buttons.start) then
Image.unload(square)
Image.unload(circle)
choosing = false
local pause = dofile("assets/misc/pause.lua")
if pause == -1 then nextscene = "./mainmenu.lua" end
    elseif buttons.pressed(buttons.r) then
choosing = false
        SaveGame(5)
    end
end
