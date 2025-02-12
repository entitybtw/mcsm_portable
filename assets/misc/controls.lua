local img = Image.load("assets/mainmenu/controls/controls_1.png")
local curimg = 1

screen.clear()
Image.draw(img, 0, 0)
screen.flip()

while true do
    buttons.read()

    if buttons.pressed(buttons.l) then
        if curimg > 1 then
            Image.unload(img)
            curimg = curimg - 1
            img = Image.load("assets/mainmenu/controls/controls_" .. tostring(curimg) .. ".png")
            screen.clear()
            Image.draw(img, 0, 0)
            screen.flip()
        end
    end

    if buttons.pressed(buttons.r) then
        if curimg < 3 then
            Image.unload(img)
            curimg = curimg + 1
            img = Image.load("assets/mainmenu/controls/controls_" .. tostring(curimg) .. ".png")
            screen.clear()
            Image.draw(img, 0, 0)
            screen.flip()
        end
    end

    if buttons.pressed(buttons.start) then
        Image.unload(img)
        sound.play("assets/sounds/skeleton_1.wav", sound.WAV_1, false, false)
        break
    end
end
