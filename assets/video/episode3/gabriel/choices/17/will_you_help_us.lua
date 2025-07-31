local choosing = true
local square = Image.load("assets/icons/square.png")
local circle = Image.load("assets/icons/circle.png")
PMP.setVolume(pmpvolume)
PMP.playEasy('assets/video/episode3/gabriel/choices/17/will_you_help_us.pmp', buttons.r, true, 'assets/video/episode3/gabriel/choices/17/will_you_help_us.srt', font, subssize, "#FFFFFF", "#000000/150", subs)

Image.draw(square, 25, 127)
Image.draw(circle, 455, 127)
intraFont.print(25 + 15 + 5, 127, "Take Magnus` armor", Color.new(255,255,255), font, 0.4)
intraFont.print(455 - 5 - intraFont.textW(font, "Take Ellegaard`s armor", 0.4), 127, "Take Ellegaard`s armor", Color.new(255,255,255), font, 0.4)
intraFont.print(345 - 5 - intraFont.textW(font, "Press R to save", 0.63), 230, "Press R to save", Color.new(255,255,255, 150), font, 0.63)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()
while choosing do
    buttons.read()

    if buttons.pressed(buttons.square) then
Image.unload(square)
Image.unload(circle)
        wr("ema", "magnus")
        choosing = false
        nextscene =  "assets/video/episode3/gabriel/choices/18/take_magnus_armor.lua"
    elseif buttons.pressed(buttons.circle) then
Image.unload(square)
Image.unload(circle)
        wr("ema", "ellegaard")
        choosing = false
        nextscene =  "assets/video/episode3/gabriel/choices/18/take_ellegaards_armor.lua"
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

