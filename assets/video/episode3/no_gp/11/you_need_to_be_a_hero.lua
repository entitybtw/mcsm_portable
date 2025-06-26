checkFile("assets/saves/gp.txt", "gp")
local choosing = true
local img = Image.load('assets/video/episode3/no_gp/11/you_need_to_be_a_hero.png')

PMP.setVolume(pmpvolume)
PMP.play('assets/video/episode3/no_gp/11/you_need_to_be_a_hero.pmp', buttons.r)

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
            nextscene = "assets/video/episode3/petra/choices/12/i_guess_so.lua"
        elseif gp == "gabriel" then
            nextscene = "assets/video/episode3/gabriel/choices/12/i_guess_so.lua"
        end
    elseif buttons.pressed(buttons.circle) then
        Image.unload(img)
        choosing = false
        if gp == "petra" then
            nextscene = "assets/video/episode3/petra/choices/12/not_really.lua"
        elseif gp == "gabriel" then
            nextscene = "assets/video/episode3/gabriel/choices/12/not_really.lua"
        end
    elseif buttons.pressed(buttons.l) then
        Image.unload(img)
        choosing = false
        nextscene =  "./mainmenu.lua"
    elseif buttons.pressed(buttons.start) then
        Image.unload(img)
        choosing = false
        SaveGame(3)
        nextscene =  "./mainmenu.lua"
    end

end


