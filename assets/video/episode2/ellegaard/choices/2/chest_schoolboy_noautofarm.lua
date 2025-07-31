local choosing = true
local square = Image.load("assets/icons/square.png")
local circle = Image.load("assets/icons/circle.png")
PMP.setVolume(pmpvolume)
PMP.playEasy('assets/video/episode2/ellegaard/choices/2/chest_fight.pmp', buttons.r, true, 'assets/video/episode2/ellegaard/choices/2/chest_fight.srt', font, subssize, "#FFFFFF", "#000000/150", subs)

Image.draw(square, 241, 210)
intraFont.print(241 - intraFont.textW(font, "Crafting Table", 0.4) / 2 + 8, 210 + 14, "Crafting Table", Color.new(255,255,255), font, 0.4)
Image.draw(circle, 404, 161)
intraFont.print(404 - intraFont.textW(font, "Steal Repeater", 0.4) / 2 + 8, 161 + 14, "Steal Repeater", Color.new(255,255,255), font, 0.4)
intraFont.print(345 - 5 - intraFont.textW(font, "Press R to save", 0.63), 230, "Press R to save", Color.new(255,255,255, 150), font, 0.63)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()
while choosing do
    buttons.read()

    if buttons.pressed(buttons.square) then
        Image.unload(square)
        Image.unload(circle)
        choosing = false
        nextscene =  "assets/video/episode2/ellegaard/choices/2/crafting_table.lua"
    elseif buttons.pressed(buttons.circle) then
        Image.unload(square)
        Image.unload(circle)
        choosing = false
        nextscene =  "assets/video/episode2/ellegaard/choices/2/steal_repeater.lua"
    elseif buttons.pressed(buttons.start) then
        Image.unload(square)
        Image.unload(circle)
        choosing = false
dofile("assets/misc/pause.lua")
    elseif buttons.pressed(buttons.r) then
choosing = false
        SaveGame(2)
    end

end
