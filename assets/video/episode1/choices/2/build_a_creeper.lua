building = "creeper"
local choosing = true
local img = Image.load('assets/video/episode1/choices/2/build_a_creeper.png')

PMP.setVolume(pmpvolume)
PMP.play('assets/video/episode1/choices/2/build_a_creeper.pmp', buttons.r)

screen.clear()
Image.draw(img, 0, 0)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()


while choosing do
    buttons.read()

    if buttons.pressed(buttons.square) then
	Image.unload(img)
	choosing = false
        nextscene =  "assets/video/episode1/choices/3/creeper/dead_enders.lua"
    elseif buttons.pressed(buttons.circle) then
	Image.unload(img)
	choosing = false
        nextscene =  "assets/video/episode1/choices/3/creeper/nether_maniacs.lua"
    elseif buttons.pressed(buttons.triangle) then
	Image.unload(img)
	choosing = false
        nextscene =  "assets/video/episode1/choices/3/creeper/order_of_the_pig.lua"
    elseif buttons.pressed(buttons.l) then
        Image.unload(img)
        choosing = false
        nextscene =  "./mainmenu.lua"
    elseif buttons.pressed(buttons.start) then
        Image.unload(img)
        choosing = false
        SaveGame(1)
        nextscene =  "./mainmenu.lua"
    end


end
