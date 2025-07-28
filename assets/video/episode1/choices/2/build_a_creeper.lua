building = "creeper"
local choosing = true
local square = Image.load('assets/icons/square.png')
local circle = Image.load('assets/icons/circle.png')
local triangle = Image.load('assets/icons/triangle.png')

PMP.setVolume(pmpvolume)
PMP.playEasy('assets/video/episode1/choices/2/build_a_creeper.pmp', buttons.r, true, 'assets/video/episode1/choices/2/build_a_creeper.srt', font, subssize, "#FFFFFF", "#000000/150", subs)

Image.draw(square, 25, 127)
Image.draw(circle, 455, 127)
Image.draw(triangle, 140, 182)
intraFont.print(25 + 15 + 5, 127, "We're Dead Enders", Color.new(255,255,255), font, 0.4)
intraFont.print(455 - 5 - intraFont.textW(font, "We're the Nether Maniacs", 0.4), 127, "We're the Nether Maniacs", Color.new(255,255,255), font, 0.4)
intraFont.print(140 + 15 + 5, 182, "We're the Order Of The pig", Color.new(255,255,255), font, 0.4)
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
    elseif buttons.pressed(buttons.l) then
        Image.unload(square)
	Image.unload(circle)
	Image.unload(triangle)
        choosing = false
        nextscene =  "./mainmenu.lua"
    elseif buttons.pressed(buttons.r) then
        Image.unload(square)
	Image.unload(circle)
	Image.unload(triangle)
        choosing = false
        SaveGame(1)
        nextscene =  "./mainmenu.lua"
    end


end
