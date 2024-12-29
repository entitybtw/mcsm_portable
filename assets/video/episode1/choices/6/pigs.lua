local choosing = true
local img = Image.load('assets/video/episode1/choices/6/pigs.png')

PMP.play('assets/video/episode1/choices/6/pigs.pmp', buttons.r)

screen.clear()
Image.draw(img, 0, 0)
screen.flip()

while choosing do
    buttons.read()
    if buttons.pressed(buttons.square) then
        Image.unload(img)
        choosing = false
	dofile("assets/video/episode1/choices/6/bush.lua")
    elseif buttons.pressed(buttons.circle) then
        Image.unload(img)
        choosing = false
	dofile("assets/video/episode1/choices/6/water_well.lua")
    elseif buttons.pressed(buttons.cross) then
        Image.unload(img)
        choosing = false
	dofile("assets/video/episode1/choices/6/smoke_trail.lua")
    elseif buttons.pressed(buttons.triangle) then
        Image.unload(img)
        choosing = false
	dofile("assets/video/episode1/choices/6/pigs.lua")
    elseif buttons.pressed(buttons.l) then
        Image.unload(img)
        choosing = false
        dofile("./mainmenu.lua")
    end


end








