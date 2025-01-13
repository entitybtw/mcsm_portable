building = "enderman"
local choosing = true
local img = Image.load('assets/video/episode1/choices/1/no_big_deal.png')

PMP.play('assets/video/episode1/choices/1/no_big_deal.pmp', buttons.r)

screen.clear()
Image.draw(img, 0, 0)
screen.flip()

while choosing do
    buttons.read()

    if buttons.pressed(buttons.square) then
	Image.unload(img)
	choosing = false
	building = "creeper"
        dofile("assets/video/episode1/choices/2/build_a_creeper.lua")
    elseif buttons.pressed(buttons.circle) then
	Image.unload(img)
	choosing = false
	building = "enderman"
        dofile("assets/video/episode1/choices/2/build_a_enderman.lua")
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
