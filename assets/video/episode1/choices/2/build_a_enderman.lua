building = "enderman"
local choosing = true
local square = Image.load('assets/icons/square.png')
local circle = Image.load('assets/icons/circle.png')
local triangle = Image.load('assets/icons/triangle.png')
PMP.setVolume(pmpvolume)
PMP.playEasy('assets/video/episode1/choices/2/build_a_enderman.pmp', buttons.r, true, 'assets/video/episode1/choices/2/build_a_enderman.srt', font, subssize, "#FFFFFF", "#000000/150", subs)

Image.draw(square, 25, 127)
Image.draw(circle, 455, 127)
Image.draw(triangle, 140, 182)
intraFont.print(25 + 15 + 5, 127, "We're Dead Enders", Color.new(255,255,255), font, 0.4)
intraFont.print(455 - 5 - intraFont.textW(font, "We're the Nether Maniacs", 0.4), 127, "We're the Nether Maniacs", Color.new(255,255,255), font, 0.4)
intraFont.print(140 + 15 + 5, 182, "We're the Order Of The pig", Color.new(255,255,255), font, 0.4)
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
        nextscene =  "assets/video/episode1/choices/3/dead_enders.lua"
    elseif buttons.pressed(buttons.circle) then
	Image.unload(square)
	Image.unload(circle)
	Image.unload(triangle)
	choosing = false
        nextscene =  "assets/video/episode1/choices/3/nether_maniacs.lua"
    elseif buttons.pressed(buttons.triangle) then
	Image.unload(square)
	Image.unload(circle)
	Image.unload(triangle)
	choosing = false
        nextscene =  "assets/video/episode1/choices/3/order_of_the_pig.lua"
    elseif buttons.pressed(buttons.start) then
        Image.unload(square)
	Image.unload(circle)
	Image.unload(triangle)
        choosing = false
dofile("assets/misc/pause.lua")
    elseif buttons.pressed(buttons.r) then
        Image.unload(square)
choosing = false
        SaveGame(1)

end
end
