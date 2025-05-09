checkFile("assets/saves/gp.txt", "gp")
local choosing = true
local img = Image.load('assets/video/episode2/ellegaard/choices/8/you_need_to_get_along.png')

PMP.setVolume(pmpvolume)
PMP.play('assets/video/episode2/ellegaard/choices/8/you_need_to_get_along.pmp', buttons.r)

screen.clear()
Image.draw(img, 0, 0)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()

while choosing do
    buttons.read()

    if buttons.pressed(buttons.square) then
        Image.unload(img)
        choosing = false
        if gp == "petra" then
            nextscene = "assets/video/episode2/ellegaard_petra/choices/2/stay_out_of_it_axel.lua"
        elseif gp == "gabriel" then
            nextscene = "assets/video/episode2/ellegaard_gabriel/2/stay_out_of_it_axel.lua"
        end
    elseif buttons.pressed(buttons.circle) then
        Image.unload(img)
        choosing = false
        if gp == "petra" then
            nextscene = "assets/video/episode2/ellegaard_petra/choices/2/ellegaard_calm_down.lua"
        elseif gp == "gabriel" then
            nextscene = "assets/video/episode2/ellegaard_gabriel/2/ellegaard_calm_down.lua"
        end
    elseif buttons.pressed(buttons.l) then
        Image.unload(img)
        choosing = false
        nextscene =  "./mainmenu.lua"
    elseif buttons.pressed(buttons.start) then
        Image.unload(img)
        choosing = false
        SaveGame(2)
        nextscene =  "./mainmenu.lua"
    end

end
