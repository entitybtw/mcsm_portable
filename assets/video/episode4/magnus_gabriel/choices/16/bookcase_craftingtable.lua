local choosing = true
local square = Image.load("assets/icons/square.png")
local cross = Image.load("assets/icons/cross.png")
local triangle = Image.load("assets/icons/triangle.png")

PMP.setVolume(pmpvolume)
PMP.playEasy('assets/video/episode4/magnus_petra/choices/16/bookcase.pmp', buttons.r, true, 'assets/video/episode4/magnus_petra/choices/16/bookcase.srt', font, subssize, "#FFFFFF", "#000000/150", subs)
Image.draw(cross, 210, 169)
intraFont.print(210 - intraFont.textW(font, "Petra", 0.4) / 2 + 8, 169 + 14, "Petra", Color.new(255,255,255), font, 0.4)
Image.draw(square, 393, 146)
intraFont.print(393 - intraFont.textW(font, "Put lever", 0.4) / 2 + 8, 146 + 14, "Put Lever", Color.new(255,255,255), font, 0.4)
Image.draw(triangle, 397, 147)
intraFont.print(397 - intraFont.textW(font, "Redstone Hole", 0.4) / 2 + 8, 147 + 14, "Redstone Hole", Color.new(255,255,255), font, 0.4)
intraFont.print(345 - 5 - intraFont.textW(font, "Press R to save", 0.63), 230, "Press R to save", Color.new(255,255,255, 150), font, 0.63)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()

while choosing do
    buttons.read()
    if buttons.pressed(buttons.square) then
        Image.unload(square)
        Image.unload(cross)
        Image.unload(triangle)
        choosing = false
        nextscene =  "assets/video/episode4/magnus_petra/choices/16/put_lever.lua"
    elseif buttons.pressed(buttons.cross) then
	Image.unload(square)
        Image.unload(cross)
        Image.unload(triangle)
	choosing = false
	nextscene =  "assets/video/episode4/magnus_petra/choices/16/petra_craftingtable.lua"
    elseif buttons.pressed(buttons.triangle) then
	Image.unload(square)
        Image.unload(cross)
        Image.unload(triangle)
	choosing = false
	nextscene =  "assets/video/episode4/magnus_petra/choices/16/redstone_hole_craftingtable.lua"
    elseif buttons.pressed(buttons.start) then
        Image.unload(square)
        Image.unload(cross)
        Image.unload(triangle)
        choosing = false
dofile("assets/misc/pause.lua")
    elseif buttons.pressed(buttons.r) then
        Image.unload(square)
choosing = false
        SaveGame(2)
end
end