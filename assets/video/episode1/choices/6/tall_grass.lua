local img = Image.load('assets/video/episode1/choices/6/tall_grass.png')

PMP.play('assets/video/episode1/choices/6/tall_grass.pmp', buttons.r)

screen.clear()
Image.draw(img, 0, 0)
screen.flip()


while true do
    buttons.read()

    if buttons.pressed(buttons.square) then
	Image.unload(img)
        dofile("assets/video/episode1/choices/7/run_i_distract_them.lua")
    elseif buttons.pressed(buttons.circle) then
	Image.unload(img)
        dofile("assets/video/episode1/choices/7/stay_close_i_protect_you.lua")
    elseif buttons.pressed(buttons.l) then
        Image.unload(img)
        choosing = false
        dofile("./mainmenu.lua")
    end


end