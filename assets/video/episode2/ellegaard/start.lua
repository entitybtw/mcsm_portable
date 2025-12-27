checkFile("assets/saves/bf.txt", "bf")
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
local result = PMP.playEasy('assets/video/episode2/ellegaard/start.pmp', buttons.r, true, 'assets/video/episode2/ellegaard/start.srt', font, subssize, "#FFFFFF", "#000000/150", subs)
if result == 1 then
    nextscene = "./mainmenu.lua"
    return 1
end
Image.draw(square, 25, 127)
Image.draw(circle, 455, 127)
intraFont.print(45, 127, text, Color.new(255,255,255), font, 0.4)
intraFont.print(450 - intraFont.textW(font, "Sword", 0.4), 127, "Sword", Color.new(255,255,255), font, 0.4)
intraFont.print(340 - intraFont.textW(font, "Press R to save", 0.63), 230, "Press R to save", Color.new(255,255,255, 150), font, 0.63)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()

while choosing do
    buttons.read()
    if buttons.pressed(buttons.square) then
        choosing = false
        if bf == "bow" then
            nextscene = "assets/video/episode2/ellegaard/bow.lua"
        elseif bf == "fishing_pole" then
            nextscene = "assets/video/episode2/ellegaard/fishing_pole.lua"
        end
    elseif buttons.pressed(buttons.circle) then
        choosing = false
        nextscene = "assets/video/episode2/ellegaard/sword.lua"
    elseif buttons.pressed(buttons.start) then
choosing = false
local pause = dofile("assets/misc/pause.lua")
if pause == -1 then nextscene = "./mainmenu.lua" end
    elseif buttons.pressed(buttons.r) then
choosing = false
        SaveGame(2)
end
end
