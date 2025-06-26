local choosing = true
local img = Image.load('assets/video/episode3/no_gp/10/exit2.png')

PMP.setVolume(pmpvolume)
PMP.play('assets/video/episode3/no_gp/10/exit_2.pmp', buttons.r)

screen.clear()
Image.draw(img, 0, 0)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()

while choosing do
    buttons.read()

    if buttons.pressed(buttons.square) then
        Image.unload(img)
        choosing = false
        nextscene =  "assets/video/episode3/no_gp/11/help_me_save_the_world.lua"
    elseif buttons.pressed(buttons.circle) then
        Image.unload(img)
        choosing = false
        nextscene =  "assets/video/episode3/no_gp/11/you_need_to_be_a_hero.lua"
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


