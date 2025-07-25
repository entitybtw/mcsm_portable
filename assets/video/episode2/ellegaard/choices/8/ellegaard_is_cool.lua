checkFile("assets/saves/gp.txt", "gp")
local choosing = true
local square = Image.load("assets/icons/square.png")
local circle = Image.load("assets/icons/circle.png")

PMP.setVolume(pmpvolume)
PMP.playEasy('assets/video/episode2/ellegaard/choices/8/ellegaard_is_cool.pmp', buttons.r, true, 'assets/video/episode2/ellegaard/choices/8/ellegaard_is_cool.srt', font, subssize, "#FFFFFF", "#000000/150", subs)

Image.draw(square, 25, 127)
Image.draw(circle, 455, 127)
intraFont.print(25 + 15 + 5, 127, "Stay out of it, Axel", Color.new(255,255,255), font, 0.4)
intraFont.print(455 - 5 - intraFont.textW(font, "Ellegaard calm down", 0.4), 127, "Ellegaard calm down", Color.new(255,255,255), font, 0.4)
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
    elseif buttons.pressed(buttons.l) then
Image.unload(square)
Image.unload(circle)
        choosing = false
        nextscene =  "./mainmenu.lua"
    elseif buttons.pressed(buttons.start) then
Image.unload(square)
Image.unload(circle)
        choosing = false
        SaveGame(2)
        nextscene =  "./mainmenu.lua"
    end

end
