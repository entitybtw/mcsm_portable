local choosing = true
local img = Image.load('assets/video/episode1/choices/3/de.png')

PMP.play('assets/video/episode1/choices/3/de.pmp', buttons.r)

screen.clear()
Image.draw(img, 0, 0)
screen.flip()


while choosing do
    buttons.read()

    if buttons.pressed(buttons.square) then
	Image.unload(img)
	choosing = false
        dofile("assets/video/episode1/choices/4/mtbtw.lua")
    elseif buttons.pressed(buttons.circle) then
	Image.unload(img)
	choosing = false
        dofile("assets/video/episode1/choices/4/wgtcy.lua")
    elseif buttons.pressed(buttons.l) then
        Image.unload(img)
        choosing = false
        dofile("./mainmenu.lua")
    end


end