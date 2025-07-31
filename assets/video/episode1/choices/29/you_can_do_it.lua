local choosing = true
local square = Image.load("assets/icons/square.png")
local circle = Image.load("assets/icons/circle.png")
PMP.setVolume(pmpvolume)
PMP.playEasy('assets/video/episode1/choices/29/you_can_do_it.pmp', buttons.r, true, 'assets/video/episode1/choices/29/you_can_do_it.srt', font, subssize, "#FFFFFF", "#000000/150", subs)

Image.draw(square, 25, 127)
Image.draw(circle, 455, 127)
intraFont.print(25 + 15 + 5, 127, "Build a dirt hut", Color.new(255,255,255), font, 0.4)
intraFont.print(455 - 5 - intraFont.textW(font, "Build a treehouse", 0.4), 127, "Build a treehouse", Color.new(255,255,255), font, 0.4)
intraFont.print(345 - 5 - intraFont.textW(font, "Press R to save", 0.63), 230, "Press R to save", Color.new(255,255,255, 150), font, 0.63)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()

while choosing do
    buttons.read()
    if buttons.pressed(buttons.square) then
Image.unload(square)
Image.unload(circle)
        choosing = false
        nextscene = "assets/video/episode1/choices/30/build_a_dirt_hut.lua"
    elseif buttons.pressed(buttons.circle) then
Image.unload(square)
Image.unload(circle)
        choosing = false
        nextscene = "assets/video/episode1/choices/30/build_a_treehouse.lua"
    elseif buttons.pressed(buttons.start) then
Image.unload(square)
Image.unload(circle)
        choosing = false
dofile("assets/misc/pause.lua")
    elseif buttons.pressed(buttons.r) then
choosing = false
        SaveGame(1)

end
end
