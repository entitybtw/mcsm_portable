local img = Image.load("assets/mainmenu/not_yet.png")
local loop = true

screen.clear()
Image.draw(img, 0, 0)
screen.flip()

while loop do
    buttons.read()

    if buttons.pressed(buttons.start) then
        Image.unload(img)
	loop = false
	dofile("assets/mainmenu/epmenu/epmenu.lua")
    end

end
