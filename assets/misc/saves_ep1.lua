local img = Image.load("assets/mainmenu/saves_ep1.png")
local loop = true

screen.clear()
Image.draw(img, 0, 0)
screen.flip()

while loop do
    buttons.read()

    if buttons.pressed(buttons.square) then
        Image.unload(img)
	rm("bf", "em", "gp", "1_save")
	loop = false
        dofile("assets/mainmenu/epmenu/epmenu.lua")

    end
    if buttons.pressed(buttons.circle) then
        Image.unload(img)
	loop = false
        dofile("assets/mainmenu/epmenu/epmenu.lua")

    end

end
