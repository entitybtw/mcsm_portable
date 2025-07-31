local choosing = true
local square = Image.load("assets/icons/square.png")
local circle = Image.load("assets/icons/circle.png")
local triangle = Image.load("assets/icons/triangle.png")

PMP.setVolume(pmpvolume)
local result = PMP.playEasy('assets/video/episode4/ellegaard_gabriel/choices/23/come_back_pickaxe.pmp', buttons.r, true, 'assets/video/episode4/ellegaard_gabriel/choices/23/come_back_pickaxe.srt', font, subssize, "#FFFFFF", "#000000/150", subs)
if result == 1 then
    nextscene = "./mainmenu.lua"
    return 1
end
Image.draw(square, 25, 127)
Image.draw(circle, 455, 127)
Image.draw(triangle, 140, 182)
intraFont.print(25 + 15 + 5, 127, "TNT launcher", Color.new(255,255,255), font, 0.4)
intraFont.print(455 - 5 - intraFont.textW(font, "Rocket minecart", 0.4), 127, "Rocket minecart", Color.new(255,255,255), font, 0.4)
intraFont.print(140 + 15 + 5, 182, "Flying machine", Color.new(255,255,255), font, 0.4)
intraFont.print(345 - 5 - intraFont.textW(font, "Press R to save", 0.63), 230, "Press R to save", Color.new(255,255,255, 150), font, 0.63)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()

while choosing do
    buttons.read()
    if buttons.pressed(buttons.square) then
        Image.unload(square)
        Image.unload(circle)
        Image.unload(triangle)
        choosing = false
        nextscene = "assets/video/episode4/ellegaard_gabriel/choices/24/tnt_launcher_pickaxe.lua"
    elseif buttons.pressed(buttons.circle) then
        Image.unload(square)
        Image.unload(circle)
        Image.unload(triangle)
        choosing = false
        nextscene = "assets/video/episode4/ellegaard_gabriel/choices/24/rocket_minecart_pickaxe.lua"
    elseif buttons.pressed(buttons.triangle) then
        Image.unload(square)
        Image.unload(circle)
        Image.unload(triangle)
        choosing = false
        nextscene = "assets/video/episode4/ellegaard_gabriel/choices/24/flying_machine_pickaxe.lua"
    elseif buttons.pressed(buttons.start) then
        Image.unload(square)
        Image.unload(circle)
        Image.unload(triangle)
choosing = false
local pause = dofile("assets/misc/pause.lua")
if pause == -1 then nextscene = "./mainmenu.lua" end
    elseif buttons.pressed(buttons.r) then
        Image.unload(square)
choosing = false
        SaveGame(3)
end
end
