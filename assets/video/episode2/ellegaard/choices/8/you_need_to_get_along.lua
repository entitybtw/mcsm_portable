checkFile("assets/saves/gp.txt", "gp")
local choosing = true
local square = Image.load("assets/icons/square.png")
local circle = Image.load("assets/icons/circle.png")

PMP.setVolume(pmpvolume)
local result = PMP.playEasy('assets/video/episode2/ellegaard/choices/8/you_need_to_get_along.pmp', buttons.r, true, 'assets/video/episode2/ellegaard/choices/8/you_need_to_get_along.srt', font, subssize, "#FFFFFF", "#000000/150", subs)
if result == 1 then
    nextscene = "./mainmenu.lua"
    return 1
end
Image.draw(square, 25, 127)
Image.draw(circle, 455, 127)
intraFont.print(45, 127, "Stay out of it, Axel", Color.new(255,255,255), font, 0.4)
intraFont.print(450 - intraFont.textW(font, "Ellegaard calm down", 0.4), 127, "Ellegaard calm down", Color.new(255,255,255), font, 0.4)
intraFont.print(340 - intraFont.textW(font, "Press R to save", 0.63), 230, "Press R to save", Color.new(255,255,255, 150), font, 0.63)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()

while choosing do
    buttons.read()
    if buttons.pressed(buttons.square) then
Image.unload(square)
Image.unload(circle)
        choosing = false
        if gp == "petra" then
            nextscene = "assets/video/episode2/ellegaard_petra/choices/2/stay_out_of_it_axel.lua"
        elseif gp == "gabriel" then
            nextscene = "assets/video/episode2/ellegaard_gabriel/2/stay_out_of_it_axel.lua"
        end
    elseif buttons.pressed(buttons.circle) then
Image.unload(square)
Image.unload(circle)
        choosing = false
        if gp == "petra" then
            nextscene = "assets/video/episode2/ellegaard_petra/choices/2/ellegaard_calm_down.lua"
        elseif gp == "gabriel" then
            nextscene = "assets/video/episode2/ellegaard_gabriel/2/ellegaard_calm_down.lua"
        end
    elseif buttons.pressed(buttons.start) then
Image.unload(square)
Image.unload(circle)
choosing = false
local pause = dofile("assets/misc/pause.lua")
if pause == -1 then nextscene = "./mainmenu.lua" end
    elseif buttons.pressed(buttons.r) then
choosing = false
        SaveGame(2)
end
end
