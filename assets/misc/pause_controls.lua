local img = Image.load("assets/mainmenu/controls/psp.png")
local circle = Image.load("assets/icons/circle.png")
local bg = Image.load("assets/mainmenu/pause_bg.png")
local imgfade = 0
local imgtimer = timer.create()

while true do
    buttons.read()
    screen.clear()

    Image.draw(bg, 0, 0)


    local elapsed = timer.time(imgtimer)
    if elapsed >= 300 and imgfade < 255 then
        imgfade = math.min(imgfade + 15, 255)
    end
    creditfade = math.min(imgfade * 0.6, 100)

    Image.draw(img, 47.5, 26, 385, 220, nil, nil, nil, nil, nil, nil, imgfade)
    Image.draw(circle, 240 - intraFont.textW(font, "Previous Menu", 0.3) / 2 - 8, 233 + 13, 14, 14, nil, nil, nil, nil, nil, nil)
    intraFont.printShadowed(240 - intraFont.textW(font, "Previous Menu", 0.3) / 2 + 8, 233 + 14, "Previous Menu", Color.new(255,255,255), Color.new(0, 0, 0), font, 90, 1, 0.3, 0)    
    intraFont.printShadowed(225 - intraFont.textW(font, "Controls", 0.2) / 2 + 8, 5 + 14, "Controls", Color.new(255,255,255), Color.new(0, 0, 0), font, 90, 1, 0.3, 0)
    intraFont.printShadowed(390, 75, "Skip current\n\n   cutscene", Color.new(255, 255, 255, imgfade), Color.new(0, 0, 0, imgfade), font, 90, 1, 0.3, 0)
    intraFont.printShadowed(380, 135, "Actions/\n\nDialog Choices", Color.new(255, 255, 255, imgfade), Color.new(0, 0, 0, imgfade), font, 90, 1, 0.3, 0)
    intraFont.printShadowed(360, 190, "Pause Menu", Color.new(255, 255, 255, imgfade), Color.new(0, 0, 0, imgfade), font, 90, 1, 0.3, 0)
    intraFont.printShadowed(280 - intraFont.textW(font, "Pause Game", 0.3) / 2 + 8, 193 + 14, "Pause Game", Color.new(255,255,255, imgfade), Color.new(0, 0, 0, imgfade), font, 90, 1, 0.3, 0)
    intraFont.printShadowed(3, 259, "art by Ossi101", Color.new(255, 255, 255, creditfade), Color.new(0, 0, 0, creditfade), font, 90, 1, 0.3, 0)

    debugoverlay.draw(debugoverlay.loadSettings())
    screen.flip()

    if buttons.pressed(buttons.circle) then
        Image.unload(img)
        Image.unload(bg)
        Image.unload(circle)
        sound.playEasy("assets/sounds/skeleton_1.wav", sound.WAV_1, false, false)
        sound.volumeEasy(sound.WAV_1, uiLevel * 10)
        break
    end
end
