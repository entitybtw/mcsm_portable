local choosing = true
local img = Image.load('assets/video/episode1/choices/24/but_why_me.png')

PMP.play('assets/video/episode1/choices/24/but_why_me.pmp', buttons.r)

screen.clear()
Image.draw(img, 0, 0)
screen.flip()


while choosing do
    buttons.read()

    if buttons.pressed(buttons.square) then
        Image.unload(img)
	wr("gp", "gabriel")
        choosing = false
        dofile("assets/video/episode1/choices/25/save_gabriel.lua")
    elseif buttons.pressed(buttons.circle) then
        Image.unload(img)
	wr("gp", "petra")
        choosing = false
        dofile("assets/video/episode1/choices/25/save_petra.lua")
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
