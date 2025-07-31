local choosing = true
local square = Image.load("assets/icons/square.png")
local circle = Image.load("assets/icons/circle.png")
local cross = Image.load("assets/icons/cross.png")

PMP.setVolume(pmpvolume)
PMP.playEasy('assets/video/episode4/ellegaard_gabriel/choices/16/redstone_hole.pmp', buttons.r, true, 'assets/video/episode4/ellegaard_gabriel/choices/16/redstone_hole.srt', font, subssize, "#FFFFFF", "#000000/150", subs)
Image.draw(cross, 210, 169)
intraFont.print(210 - intraFont.textW(font, "Petra", 0.4) / 2 + 8, 169 + 14, "Petra", Color.new(255,255,255), font, 0.4)
Image.draw(square, 280, 119)
intraFont.print(289 - intraFont.textW(font, "Crafting Table", 0.4) / 2 + 8, 119 + 14, "Crafting Table", Color.new(255,255,255), font, 0.4)
Image.draw(circle, 126, 169)
intraFont.print(126 - intraFont.textW(font, "Bookcase", 0.4) / 2 + 8, 169 + 14, "Bookcase", Color.new(255,255,255), font, 0.4)
intraFont.print(345 - 5 - intraFont.textW(font, "Press R to save", 0.63), 230, "Press R to save", Color.new(255,255,255, 150), font, 0.63)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()

while choosing do
    buttons.read()
    if buttons.pressed(buttons.square) then
        Image.unload(square)
        Image.unload(circle)
        Image.unload(cross)
        choosing = false
        nextscene =  "assets/video/episode4/ellegaard_gabriel/choices/16/crafting_table.lua"
    elseif buttons.pressed(buttons.circle) then
        Image.unload(square)
        Image.unload(circle)
        Image.unload(cross)
        choosing = false
        nextscene =  "assets/video/episode4/ellegaard_gabriel/choices/16/bookcase.lua"
    elseif buttons.pressed(buttons.cross) then
	Image.unload(square)
        Image.unload(circle)
        Image.unload(cross)
	choosing = false
	nextscene =  "assets/video/episode4/ellegaard_gabriel/choices/16/petra.lua"
    elseif buttons.pressed(buttons.start) then
        Image.unload(square)
        Image.unload(circle)
        Image.unload(cross)
        choosing = false
dofile("assets/misc/pause.lua")
    elseif buttons.pressed(buttons.r) then
        Image.unload(square)
choosing = false
        SaveGame(2)
end
end