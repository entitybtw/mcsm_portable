local choosing = true
local img = Image.load('assets/video/episode1/choices/20/after_lukas/sit_tight.png')

PMP.play('assets/video/episode1/choices/20/after_lukas/sit_tight.pmp', buttons.r)

screen.clear()
Image.draw(img, 0, 0)
screen.flip()


while choosing do
    buttons.read()

    if buttons.pressed(buttons.square) then
        Image.unload(img)
        choosing = false
        dofile("assets/video/episode1/choices/21/somebody_stop_him.lua")
    elseif buttons.pressed(buttons.circle) then
        Image.unload(img)
        choosing = false
        dofile("assets/video/episode1/choices/21/this_cant_be_good.lua")
    elseif buttons.pressed(buttons.l) then
        Image.unload(img)
        choosing = false
        dofile("./mainmenu.lua")
    end


end
