local choosing = true
local img = Image.load('assets/video/episode1/choices/32/stay_here.png')

PMP.setVolume(pmpvolume)
PMP.play('assets/video/episode1/choices/32/stay_here.pmp', buttons.r)

screen.clear()
Image.draw(img, 0, 0)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()


while choosing do
    buttons.read()

    if buttons.pressed(buttons.square) then
        Image.unload(img)
	wr("bf", "bow")
        choosing = false
        nextscene =  "assets/video/episode1/choices/34/craft_a_bow.lua"
    elseif buttons.pressed(buttons.circle) then
        Image.unload(img)
	wr("bf", "fishing_pole")
        choosing = false
        nextscene =  "assets/video/episode1/choices/34/craft_a_fishing_pole.lua"
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
