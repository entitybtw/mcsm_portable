local choosing = true
local square = Image.load("assets/icons/square.png")
local cross = Image.load("assets/icons/cross.png")
local triangle = Image.load("assets/icons/triangle.png")

PMP.setVolume(pmpvolume)
local result = PMP.playEasy('assets/video/episode4/ellegaard_petra/choices/16/bookcase.pmp', buttons.r, true, 'assets/video/episode4/ellegaard_petra/choices/16/bookcase.srt', font, subssize, "#FFFFFF", "#000000/150", subs)
if result == 1 then
    nextscene = "./mainmenu.lua"
    return 1
end
Image.draw(cross, 210, 169)
intraFont.print(210 - intraFont.textW(font, "Gabriel", 0.4) / 2 + 8, 169 + 14, "Gabriel", Color.new(255,255,255), font, 0.4)
Image.draw(square, 272, 119)
intraFont.print(272 - intraFont.textW(font, "Chest", 0.4) / 2 + 8, 119 + 14, "Chest", Color.new(255,255,255), font, 0.4)
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
        nextscene =  "assets/video/episode4/ellegaard_petra/choices/16/chest.lua"
    elseif buttons.pressed(buttons.cross) then
	Image.unload(square)
        Image.unload(cross)
        Image.unload(triangle)
	choosing = false
	nextscene =  "assets/video/episode4/ellegaard_petra/choices/16/gabriel.lua"
    elseif buttons.pressed(buttons.triangle) then
	Image.unload(square)
        Image.unload(cross)
        Image.unload(triangle)
	choosing = false
	nextscene =  "assets/video/episode4/ellegaard_petra/choices/16/redstone_hole.lua"
    elseif buttons.pressed(buttons.r) then
        Image.unload(square)
choosing = false
        SaveGame(2)
end
end
