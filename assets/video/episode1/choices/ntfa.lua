local choosing = true
local img = Image.load('assets/video/episode1/choices/ntfa.png')

PMP.play('assets/video/episode1/choices/not_funny_axel.pmp', buttons.r)

screen.clear()
Image.draw(img, 0, 0)
screen.flip()

while choosing do
    buttons.read()

    if buttons.pressed(buttons.square) then
	Image.unload(img)
        choosing = false
        dofile("assets/video/episode1/choices/1/gia.lua")
    elseif buttons.pressed(buttons.circle) then
        Image.unload(img)
        choosing = false
        dofile("assets/video/episode1/choices/1/nbd.lua")
    elseif buttons.pressed(buttons.l) then
        Image.unload(img)
        choosing = false
        dofile("./mainmenu.lua")
    end

end