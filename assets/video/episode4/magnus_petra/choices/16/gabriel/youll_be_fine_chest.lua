local choosing = true
local square = Image.load("assets/icons/square.png")
local circle = Image.load("assets/icons/circle.png")
local triangle = Image.load("assets/icons/triangle.png")

PMP.setVolume(pmpvolume)
PMP.playEasy('assets/video/episode4/magnus_petra/choices/16/gabriel/youll_be_fine.pmp', buttons.r, true, 'assets/video/episode4/magnus_petra/choices/16/gabriel/youll_be_fine.srt', font, subssize, "#FFFFFF", "#000000/150", subs)
Image.draw(square, 289, 119)
intraFont.print(289 - intraFont.textW(font, "Crafting Table", 0.4) / 2 + 8, 119 + 14, "Crafting Table", Color.new(255,255,255), font, 0.4)
Image.draw(circle, 126, 169)
intraFont.print(126 - intraFont.textW(font, "Bookcase", 0.4) / 2 + 8, 169 + 14, "Bookcase", Color.new(255,255,255), font, 0.4)
Image.draw(triangle, 397, 147)
intraFont.print(397 - intraFont.textW(font, "Redstone Hole", 0.4) / 2 + 8, 147 + 14, "Redstone Hole", Color.new(255,255,255), font, 0.4)
intraFont.print(345 - 5 - intraFont.textW(font, "Press R to save", 0.63), 230, "Press R to save", Color.new(255,255,255, 150), font, 0.63)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()
while choosing do
    buttons.read()

    if buttons.pressed(buttons.square) then
        Image.unload(square)
        Image.unload(circle)
        Image.unload(triangle)
        choosing = false
        nextscene =  "assets/video/episode4/magnus_petra/choices/16/crafting_table.lua"
    elseif buttons.pressed(buttons.circle) then
        Image.unload(square)
        Image.unload(circle)
        Image.unload(triangle)
        choosing = false
        nextscene =  "assets/video/episode4/magnus_petra/choices/16/bookcase.lua"
    elseif buttons.pressed(buttons.triangle) then
	Image.unload(square)
        Image.unload(circle)
        Image.unload(triangle)
	choosing = false
	nextscene =  "assets/video/episode4/magnus_petra/choices/16/redstone_hole.lua"
    elseif buttons.pressed(buttons.start) then
        Image.unload(square)
        Image.unload(circle)
        Image.unload(triangle)
        choosing = false
dofile("assets/misc/pause.lua")
    elseif buttons.pressed(buttons.r) then
        Image.unload(square)
choosing = false
        SaveGame(2)
    end

end
