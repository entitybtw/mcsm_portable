checkFile("assets/saves/bf.txt", "bf")
local square = Image.load("assets/icons/square.png")
local circle = Image.load("assets/icons/circle.png")
local text

local choosing = true
if bf == "bow" then
    text = "Bow"
elseif bf == "fishing_pole" then
    text = "Fishing Pole"
else
    LUA.quit()
end


PMP.setVolume(pmpvolume)
PMP.playEasy('assets/video/episode2/ellegaard/start.pmp', buttons.r, true, 'assets/video/episode2/ellegaard/start.srt', font, subssize, "#FFFFFF", "#000000/150", subs)

Image.draw(square, 25, 127)
Image.draw(circle, 455, 127)
intraFont.print(25 + 15 + 5, 127, text, Color.new(255,255,255), font, 0.4)
intraFont.print(455 - 5 - intraFont.textW(font, "Sword", 0.4), 127, "Sword", Color.new(255,255,255), font, 0.4)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()

while choosing do
    buttons.read()

    if buttons.pressed(buttons.square) then
        Image.unload(square)
        Image.unload(circle)
        choosing = false
        if bf == "bow" then
            nextscene = "assets/video/episode2/ellegaard/bow.lua"
        elseif bf == "fishing_pole" then
            nextscene = "assets/video/episode2/ellegaard/fishing_pole.lua"
        end
    elseif buttons.pressed(buttons.circle) then
        Image.unload(square)
        Image.unload(circle)
        choosing = false
        nextscene = "assets/video/episode2/ellegaard/sword.lua"
    elseif buttons.pressed(buttons.l) then
        Image.unload(square)
        Image.unload(circle)
        choosing = false
        nextscene = "./mainmenu.lua"
    elseif buttons.pressed(buttons.r) then
        Image.unload(square)
        Image.unload(circle)
        choosing = false
        SaveGame(2)
        nextscene = "./mainmenu.lua"
    end
end
