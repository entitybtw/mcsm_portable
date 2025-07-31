local choosing = true
local square = Image.load("assets/icons/square.png")
local circle = Image.load("assets/icons/circle.png")
PMP.setVolume(pmpvolume)
PMP.playEasy('assets/video/episode3/gabriel/choices/13/break_the_fountain.pmp', buttons.r, true, 'assets/video/episode3/gabriel/choices/13/break_the_fountain.srt', font, subssize, "#FFFFFF", "#000000/150", subs)

Image.draw(square, 25, 127)
Image.draw(circle, 455, 127)
intraFont.print(25 + 15 + 5, 127, "Eyes Down", Color.new(255,255,255), font, 0.4)
intraFont.print(455 - 5 - intraFont.textW(font, "Hold onto me", 0.4), 127, "Hold onto me", Color.new(255,255,255), font, 0.4)
intraFont.print(345 - 5 - intraFont.textW(font, "Press R to save", 0.63), 230, "Press R to save", Color.new(255,255,255, 150), font, 0.63)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()
while choosing do
    buttons.read()

    if buttons.pressed(buttons.square) then
Image.unload(square)
Image.unload(circle)
        choosing = false
        nextscene =  "assets/video/episode3/gabriel/choices/14/eyes_down.lua"
    elseif buttons.pressed(buttons.circle) then
Image.unload(square)
Image.unload(circle)
        choosing = false
        nextscene =  "assets/video/episode3/gabriel/choices/14/hold_onto_me.lua"
    elseif buttons.pressed(buttons.start) then
Image.unload(square)
Image.unload(circle)
        choosing = false
dofile("assets/misc/pause.lua")
    elseif buttons.pressed(buttons.r) then
choosing = false
        SaveGame(3)
    end

end

