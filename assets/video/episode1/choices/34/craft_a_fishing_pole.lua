local choosing = true
local img = Image.load('assets/video/episode1/choices/34/craft_a_fishing_pole.png')

PMP.play('assets/video/episode1/choices/34/craft_a_fishing_pole.pmp', buttons.r)

screen.clear()
Image.draw(img, 0, 0)
screen.flip()


while choosing do
    buttons.read()

    if buttons.pressed(buttons.square) then
        Image.unload(img)
        choosing = false
        dofile("assets/video/episode1/choices/35/ivor_isnt_a_hero.lua")
    elseif buttons.pressed(buttons.circle) then
        Image.unload(img)
        choosing = false
        dofile("assets/video/episode1/choices/35/this_explains_a_lot.lua")
    elseif buttons.pressed(buttons.l) then
        Image.unload(img)
        choosing = false
        dofile("./mainmenu.lua")
    end


end
