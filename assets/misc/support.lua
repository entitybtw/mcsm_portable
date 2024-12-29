local img = Image.load("assets/mainmenu/support.png")

screen.clear()
Image.draw(img, 0, 0)
screen.flip()

while true do
    buttons.read()

    if buttons.pressed(buttons.start) then
        dofile("./mainmenu.lua")

    end

end
