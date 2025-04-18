local img = Image.load("assets/mainmenu/controls/controls_1.png")
local curimg = 1

screen.clear()
Image.draw(img, 0, 0)
debugoverlay.draw(debugoverlay.loadSettings())
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
debugoverlay.draw(debugoverlay.loadSettings())
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
debugoverlay.draw(debugoverlay.loadSettings())
            screen.flip()
        end
    end

    if buttons.pressed(buttons.start) then
        Image.unload(img)
        sound.play("assets/sounds/skeleton_1.wav", sound.WAV_1, false, false)
        sound.volume(sound.WAV_1, uiLevel * 10)
        break
    end
end
