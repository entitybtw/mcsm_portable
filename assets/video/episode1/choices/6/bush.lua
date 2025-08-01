local choosing = true
local cross_choice = "assets/video/episode1/choices/6/smoke_trail.lua"
local square = Image.load("assets/icons/square.png")
local circle = Image.load("assets/icons/circle.png")
local triangle = Image.load("assets/icons/triangle.png")
local cross = Image.load("assets/icons/cross.png")

PMP.setVolume(pmpvolume)
local result = PMP.playEasy('assets/video/episode1/choices/6/bush.pmp', buttons.r, true, 'assets/video/episode1/choices/6/bush.srt', font, subssize, "#FFFFFF", "#000000/150", subs)
if result == 1 then
    nextscene = "./mainmenu.lua"
    return 1
end
if tall_grass == "off" then
    Image.draw(cross, 257, 136)
    intraFont.print(257 - intraFont.textW(font, "Smoke Trail", 0.4) / 2 + 8, 136 + 14, "Smoke Trail", Color.new(255,255,255), font, 0.4)
    cross_choice = "assets/video/episode1/choices/6/smoke_trail.lua"
elseif tall_grass == "on" then
    Image.draw(cross, 201, 130)
    intraFont.print(201 - intraFont.textW(font, "Tall Grass", 0.4) / 2 + 8, 130 + 14, "Tall Grass", Color.new(255,255,255), font, 0.4)
    cross_choice = "assets/video/episode1/choices/6/tall_grass.lua"
end
Image.draw(triangle, 389, 193)
intraFont.print(389 - intraFont.textW(font, "Pigs", 0.4) / 2 + 8, 193 + 14, "Pigs", Color.new(255,255,255), font, 0.4)
Image.draw(square, 88, 63)
intraFont.print(88 - intraFont.textW(font, "Bush", 0.4) / 2 + 8, 63 + 14, "Bush", Color.new(255,255,255), font, 0.4)
Image.draw(circle, 95, 167)
intraFont.print(95 - intraFont.textW(font, "Water Well", 0.4) / 2 + 8, 167 + 14, "Water Well", Color.new(255,255,255), font, 0.4)
intraFont.print(345 - 5 - intraFont.textW(font, "Press R to save", 0.63), 230, "Press R to save", Color.new(255,255,255, 150), font, 0.63)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()
while choosing do
    buttons.read()
    if buttons.pressed(buttons.square) then
        Image.unload(cross)
	Image.unload(triangle)
	Image.unload(square)
	Image.unload(circle)
        choosing = false
	nextscene =  "assets/video/episode1/choices/6/bush.lua"
    elseif buttons.pressed(buttons.circle) then
        Image.unload(cross)
	Image.unload(triangle)
	Image.unload(square)
	Image.unload(circle)
        choosing = false
	nextscene =  "assets/video/episode1/choices/6/water_well.lua"
    elseif buttons.pressed(buttons.cross) then
        Image.unload(cross)
	Image.unload(triangle)
	Image.unload(square)
	Image.unload(circle)
        choosing = false
	nextscene = cross_choice
    elseif buttons.pressed(buttons.triangle) then
        Image.unload(cross)
	Image.unload(triangle)
	Image.unload(square)
	Image.unload(circle)
        choosing = false
	nextscene =  "assets/video/episode1/choices/6/pigs.lua"
    elseif buttons.pressed(buttons.start) then
        Image.unload(cross)
	Image.unload(triangle)
	Image.unload(square)
	Image.unload(circle)
choosing = false
local pause = dofile("assets/misc/pause.lua")
if pause == -1 then nextscene = "./mainmenu.lua" end
    elseif buttons.pressed(buttons.r) then
        Image.unload(cross)
	Image.unload(triangle)
choosing = false
        SaveGame(1)

end
end
