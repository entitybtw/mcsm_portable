local img = Image.load("assets/mainmenu/credits.png")
local loop = true

screen.clear()
Image.draw(img, 0, 0)
screen.flip()

while loop do
    buttons.read()

    if buttons.pressed(buttons.start) then
	Image.unload(img)
	loop = false
    sound.play("assets/sounds/skeleton_1.wav", sound.WAV_1, false, false)
    end

end
