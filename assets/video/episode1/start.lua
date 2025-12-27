local path = System.LoadData("assets/mainmenu/saves_bg.png")
local choosing = true
local fade = 255
if path then
    PMP.setVolume(pmpvolume)
local result =     PMP.playEasy("assets/mainmenu/loading.pmp")
if result == 1 then
    nextscene = "./mainmenu.lua"
    return 1
end
    nextscene = path.data

    local variablesFile = io.open("assets/saves/1_variables.txt", "r")
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

local square = Image.load('assets/icons/square.png')
local circle = Image.load('assets/icons/circle.png')
PMP.setVolume(pmpvolume)
local result = PMP.playEasy('assets/mainmenu/lsave.pmp')
if result == 1 then
    nextscene = "./mainmenu.lua"
    return 1
end
local yourText = "The game series adapts to the choices you make.\n\n\n          The story is tailored by how you play"
fade = 0

-- Fade in
while fade < 255 do
    fade = math.min(fade + 8, 255)
    screen.clear()
    intraFont.print(230 - intraFont.textW(font, "The game series adapts to the choices you make.\n\n\n          The story is tailored by how you play", 0.3) / 2 + 8, 118 + 14, "The game series adapts to the choices you make.\n\n\n          The story is tailored by how you play", Color.new(255,255,255, fade), font, 0.3)
    screen.flip()
    LUA.sleep(16)
end
LUA.sleep(2000)

-- Fade out
while fade > 0 do
    fade = math.max(fade - 8, 0)
    screen.clear()
    intraFont.print(230 - intraFont.textW(font, "The game series adapts to the choices you make.\n\n\n          The story is tailored by how you play", 0.3) / 2 + 8, 118 + 14, "The game series adapts to the choices you make.\n\n\n          The story is tailored by how you play", Color.new(255,255,255, fade), font, 0.3)
    screen.flip()
    LUA.sleep(16)
end

PMP.setVolume(pmpvolume)
local result = PMP.playEasy('assets/video/episode1/START.pmp', buttons.r, true, "assets/video/episode1/start.srt", font, subssize, "#FFFFFF", "#000000/150", subs)
if result == 1 then
    nextscene = "./mainmenu.lua"
    return 1
end

Image.draw(square, 25, 127)
Image.draw(circle, 455, 127)
intraFont.print(45, 127, "100 chicken-sized\n \n       zombies", Color.new(255,255,255), font, 0.4)
intraFont.print(450 - intraFont.textW(font, "10 zombie-sized\n \n       chickens", 0.4), 127, "10 zombie-sized\n \n       chickens", Color.new(255,255,255), font, 0.4)
intraFont.print(340 - intraFont.textW(font, "Press R to save", 0.63), 230, "Press R to save", Color.new(255,255,255, 150), font, 0.63)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()

while choosing do
    buttons.read()
    if buttons.pressed(buttons.square) then
        Image.unload(square)
        Image.unload(circle)
        nextscene =  "assets/video/episode1/100_chicken_sized.lua"
        choosing = false
    elseif buttons.pressed(buttons.circle) then
        Image.unload(square)
        Image.unload(circle)
        nextscene =  "assets/video/episode1/10_zombie_sized.lua"
        choosing = false
    elseif buttons.pressed(buttons.start) then
        Image.unload(square)
        Image.unload(circle)
choosing = false
local pause = dofile("assets/misc/pause.lua")
if pause == -1 then nextscene = "./mainmenu.lua" end
    end

end
