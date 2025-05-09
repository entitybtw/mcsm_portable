local choosing = true
local img = Image.load('assets/video/episode2/ellegaard/choices/1/they_could_teach_you.png')

PMP.setVolume(pmpvolume)
PMP.play('assets/video/episode2/ellegaard/choices/1/they_could_teach_you.pmp', buttons.r)

screen.clear()
Image.draw(img, 0, 0)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()

while choosing do
    buttons.read()

    if buttons.pressed(buttons.square) then
        Image.unload(img)
        choosing = false
        nextscene =  "assets/video/episode2/ellegaard/choices/2/chest.lua"
    elseif buttons.pressed(buttons.circle) then
        Image.unload(img)
        choosing = false
        nextscene =  "assets/video/episode2/ellegaard/choices/2/intellectual.lua"
    elseif buttons.pressed(buttons.cross) then
	Image.unload(img)
	choosing = false
	nextscene =  "assets/video/episode2/ellegaard/choices/2/autofarm.lua"
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
