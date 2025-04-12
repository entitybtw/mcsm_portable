local choosing = true
local img = Image.load('assets/video/episode1/100_chicken_sized.png')

PMP.setVolume(pmpvolume)
PMP.play('assets/video/episode1/100_chicken_sized.pmp', buttons.r)

screen.clear()
Image.draw(img, 0, 0)
screen.flip()

while choosing do
    buttons.read()

    if buttons.pressed(buttons.square) then
	Image.unload(img)
	choosing = false
        nextscene =  "assets/video/episode1/choices/cool_mask.lua"
    elseif buttons.pressed(buttons.circle) then
	Image.unload(img)
	choosing = false
        nextscene =  "assets/video/episode1/choices/not_funny_axel.lua"
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
