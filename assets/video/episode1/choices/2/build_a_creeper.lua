building = "creeper"
local choosing = true
local square = Image.load('assets/icons/square.png')
local circle = Image.load('assets/icons/circle.png')
local triangle = Image.load('assets/icons/triangle.png')
PMP.setVolume(pmpvolume)
local result = PMP.playEasy('assets/video/episode1/choices/2/build_a_creeper.pmp', buttons.r, true, 'assets/video/episode1/choices/2/build_a_creeper.srt', font, subssize, "#FFFFFF", "#000000/150", subs)
if result == 1 then
    nextscene = "./mainmenu.lua"
    return 1
end

Image.draw(square, 25, 127)
Image.draw(circle, 455, 127)
Image.draw(triangle, 140, 182)
intraFont.print(45, 127, "We're Dead Enders", Color.new(255,255,255), font, 0.4)
intraFont.print(450 - intraFont.textW(font, "We're the Nether Maniacs", 0.4), 127, "We're the Nether Maniacs", Color.new(255,255,255), font, 0.4)
intraFont.print(140 + 15 + 5, 182, "We're the Order Of The pig", Color.new(255,255,255), font, 0.4)
intraFont.print(340 - intraFont.textW(font, "Press R to save", 0.63), 230, "Press R to save", Color.new(255,255,255, 150), font, 0.63)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()

while choosing do
    buttons.read()
    if buttons.pressed(buttons.square) then
	Image.unload(square)
	Image.unload(circle)
	Image.unload(triangle)
	choosing = false
        nextscene =  "assets/video/episode1/choices/3/creeper/dead_enders.lua"
    elseif buttons.pressed(buttons.circle) then
	Image.unload(square)
	Image.unload(circle)
	Image.unload(triangle)
	choosing = false
        nextscene =  "assets/video/episode1/choices/3/creeper/nether_maniacs.lua"
    elseif buttons.pressed(buttons.triangle) then
	Image.unload(square)
	Image.unload(circle)
	Image.unload(triangle)
	choosing = false
        nextscene =  "assets/video/episode1/choices/3/creeper/order_of_the_pig.lua"
    elseif buttons.pressed(buttons.start) then
        Image.unload(square)
	Image.unload(circle)
	Image.unload(triangle)
choosing = false
local pause = dofile("assets/misc/pause.lua")
if pause == -1 then nextscene = "./mainmenu.lua" end
    elseif buttons.pressed(buttons.r) then
        Image.unload(square)
choosing = false
        SaveGame(1)

end
end
