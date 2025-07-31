checkFile("assets/saves/bf.txt", "bf")
local square = Image.load("assets/icons/square.png")
local circle = Image.load("assets/icons/circle.png")
local text

local choosing = true
if bf == "bow" then
    text = "Bow"
    intraFont.print(25 + 15 + 5, 127, "Bow", Color.new(255,255,255), font, 0.4)
elseif bf == "fishing_pole" then
    text = "Fishing Pole"
    intraFont.print(25 + 15 + 5, 127, "Fishing Pole", Color.new(255,255,255), font, 0.4)
else
    LUA.quit()
end
PMP.setVolume(pmpvolume)
local result = PMP.playEasy('assets/video/episode2/magnus/start.pmp', buttons.r, true, 'assets/video/episode2/magnus/start.srt', font, subssize, "#FFFFFF", "#000000/150", subs)
if result == 1 then
    nextscene = "./mainmenu.lua"
    return 1
end

Image.draw(square, 25, 127)
Image.draw(circle, 455, 127)
intraFont.print(25 + 15 + 5, 127, text, Color.new(255,255,255), font, 0.4)
intraFont.print(455 - 5 - intraFont.textW(font, "Sword", 0.4), 127, "Sword", Color.new(255,255,255), font, 0.4)
intraFont.print(345 - 5 - intraFont.textW(font, "Press R to save", 0.63), 230, "Press R to save", Color.new(255,255,255, 150), font, 0.63)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()
while choosing do
    buttons.read()

    if buttons.pressed(buttons.square) then
        Image.unload(square)
        Image.unload(circle)
        choosing = false
        if bf == "bow" then
            nextscene = "assets/video/episode2/magnus/bow.lua"
        elseif bf == "fishing_pole" then
            nextscene = "assets/video/episode2/magnus/fishing_pole.lua"
        end
    elseif buttons.pressed(buttons.circle) then
        Image.unload(square)
        Image.unload(circle)
        choosing = false
        nextscene = "assets/video/episode2/magnus/sword.lua"
    elseif buttons.pressed(buttons.start) then
        Image.unload(square)
        Image.unload(circle)
        choosing = false
dofile("assets/misc/pause.lua")
    elseif buttons.pressed(buttons.r) then
choosing = false
        SaveGame(2)
    end
end
