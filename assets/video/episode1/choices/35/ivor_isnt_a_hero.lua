local choosing = true
pedestal = "off"
local img = Image.load('assets/video/episode1/choices/35/ivor_isnt_a_hero.png')

PMP.play('assets/video/episode1/choices/35/ivor_isnt_a_hero.pmp', buttons.r)

screen.clear()
Image.draw(img, 0, 0)
screen.flip()


while choosing do
    buttons.read()

    if buttons.pressed(buttons.square) then
        Image.unload(img)
        choosing = false
        dofile("assets/video/episode1/choices/36/axel.lua")
    elseif buttons.pressed(buttons.circle) then
        Image.unload(img)
        choosing = false
        dofile("assets/video/episode1/choices/36/lukas.lua")
    elseif buttons.pressed(buttons.triangle) then
        Image.unload(img)
        choosing = false
        dofile("assets/video/episode1/choices/36/olivia.lua")
    elseif buttons.pressed(buttons.cross) then
        Image.unload(img)
        choosing = false
        pedestal = "on"
        dofile("assets/video/episode1/choices/36/pedestal.lua")
    elseif buttons.pressed(buttons.l) then
        Image.unload(img)
        choosing = false
        dofile("./mainmenu.lua")
    elseif buttons.pressed(buttons.start) then
        Image.unload(img)
        choosing = false
        SaveGame(1)
        dofile("./mainmenu.lua")
    end


end
