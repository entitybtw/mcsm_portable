checkFile("assets/saves/gp.txt", "gp")
local choosing = true
local img = Image.load('assets/video/episode2/magnus/choices/7/pink_wool/1/what_about_the_plan.png')

PMP.setVolume(pmpvolume)
PMP.play('assets/video/episode2/magnus/choices/7/pink_wool/1/what_about_the_plan.pmp', buttons.r)

screen.clear()
Image.draw(img, 0, 0)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()

while choosing do
    buttons.read()

    if buttons.pressed(buttons.square) then
        Image.unload(img)
        choosing = false
        if gp == "gabriel" then
            nextscene =  "assets/video/episode2/magnus/choices/7/pink_wool/2/hello_boom_town.lua"
        elseif gp == "petra" then
            nextscene = "assets/video/episode2/magnus_petra/pink_wool/hello_boom_town.lua"
        end
    elseif buttons.pressed(buttons.circle) then
        Image.unload(img)
        choosing = false
        if gp == "gabriel" then
            nextscene =  "assets/video/episode2/magnus/choices/7/pink_wool/2/who_likes_explosions.lua"
        elseif gp == "petra" then
            nextscene = "assets/video/episode2/magnus_petra/pink_wool/who_likes_explosions.lua"
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