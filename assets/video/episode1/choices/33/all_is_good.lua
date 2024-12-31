local choosing = true
local img = Image.load('assets/video/episode1/choices/33/all_is_good.png')

PMP.play('assets/video/episode1/choices/33/all_is_good.pmp', buttons.r)

screen.clear()
Image.draw(img, 0, 0)
screen.flip()


while choosing do
    buttons.read()

    if buttons.pressed(buttons.square) then
        Image.unload(img)
	wr("bf", "bow")
        choosing = false
        dofile("assets/video/episode1/choices/34/craft_a_bow.lua")
    elseif buttons.pressed(buttons.circle) then
        Image.unload(img)
	wr("bf", "fishing_pole")
        choosing = false
        dofile("assets/video/episode1/choices/34/craft_a_fishing_pole.lua")
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
