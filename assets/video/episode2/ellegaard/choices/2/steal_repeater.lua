local choosing = true
local square = Image.load("assets/icons/square.png")
local circle = Image.load("assets/icons/circle.png")

PMP.setVolume(pmpvolume)
PMP.playEasy('assets/video/episode2/ellegaard/choices/2/steal_repeater.pmp', buttons.r, true, 'assets/video/episode2/ellegaard/choices/2/steal_repeater.srt', font, subssize, "#FFFFFF", "#000000/150", subs)

Image.draw(square, 25, 127)
Image.draw(circle, 455, 127)
intraFont.print(25 + 15 + 5, 127, "Don't touch anything", Color.new(255,255,255), font, 0.4)
intraFont.print(455 - 5 - intraFont.textW(font, "No clue what this is", 0.4), 127, "No clue what this is", Color.new(255,255,255), font, 0.4)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()

while choosing do
    buttons.read()

    if buttons.pressed(buttons.square) then
Image.unload(square)
Image.unload(circle)
        choosing = false
        nextscene =  "assets/video/episode2/ellegaard/choices/3/dont_touch_anything.lua"
    elseif buttons.pressed(buttons.circle) then
Image.unload(square)
Image.unload(circle)
        choosing = false
        nextscene =  "assets/video/episode2/ellegaard/choices/3/no_clue_what_this_is.lua"
    elseif buttons.pressed(buttons.l) then
Image.unload(square)
Image.unload(circle)
        choosing = false
        nextscene =  "./mainmenu.lua"
    elseif buttons.pressed(buttons.r) then
Image.unload(square)
Image.unload(circle)
        choosing = false
        SaveGame(2)
        nextscene =  "./mainmenu.lua"
    end

end
