local img = Image.load("assets/mainmenu/not_yet.png") -- load image

screen.clear()
Image.draw(img, 0, 0) -- draw image
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()

while true do
    buttons.read()

    if buttons.pressed(buttons.start) then
        Image.unload(img)
	    break
    end

end
