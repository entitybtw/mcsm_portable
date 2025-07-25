local choosing = true
local square = Image.load("assets/icons/square.png")
local circle = Image.load("assets/icons/circle.png")
local triangle = Image.load("assets/icons/triangle.png")

PMP.setVolume(pmpvolume)
PMP.playEasy('assets/video/episode4/ellegaard_petra/choices/23/you_coward_hoe.pmp', buttons.r, true, 'assets/video/episode4/ellegaard_petra/choices/23/you_coward_hoe.srt', font, subssize, "#FFFFFF", "#000000/150", subs)

Image.draw(square, 25, 127)
Image.draw(circle, 455, 127)
Image.draw(triangle, 140, 182)
intraFont.print(25 + 15 + 5, 127, "TNT launcher", Color.new(255,255,255), font, 0.4)
intraFont.print(455 - 5 - intraFont.textW(font, "Rocket minecart", 0.4), 127, "Rocket minecart", Color.new(255,255,255), font, 0.4)
intraFont.print(140 + 15 + 5, 182, "Flying machine", Color.new(255,255,255), font, 0.4)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()

while choosing do
    buttons.read()

    if buttons.pressed(buttons.square) then
        Image.unload(square)
        Image.unload(circle)
        Image.unload(triangle)
        choosing = false
        nextscene = "assets/video/episode4/ellegaard_petra/choices/24/tnt_launcher_hoe.lua"
    elseif buttons.pressed(buttons.circle) then
        Image.unload(square)
        Image.unload(circle)
        Image.unload(triangle)
        choosing = false
        nextscene = "assets/video/episode4/ellegaard_petra/choices/24/rocket_minecart_hoe.lua"
    elseif buttons.pressed(buttons.triangle) then
        Image.unload(square)
        Image.unload(circle)
        Image.unload(triangle)
        choosing = false
        nextscene = "assets/video/episode4/ellegaard_petra/choices/24/flying_machine_hoe.lua"
    elseif buttons.pressed(buttons.l) then
        Image.unload(square)
        Image.unload(circle)
        Image.unload(triangle)
        choosing = false
        nextscene = "./mainmenu.lua"
    elseif buttons.pressed(buttons.start) then
        Image.unload(square)
        Image.unload(circle)
        Image.unload(triangle)
        choosing = false
        SaveGame(3)
        nextscene = "./mainmenu.lua"
    end
end
