local img = Image.load("assets/mainmenu/github.png")

screen.clear()
Image.draw(img, 0, 0)
screen.flip()

while true do
    buttons.read()

    if buttons.pressed(buttons.start) then
        Image.unload(img)
        sound.play("assets/sounds/skeleton_1.wav", sound.WAV_1, false, false)
        sound.volume(sound.WAV_1, uiLevel * 10)
        break
    end

end