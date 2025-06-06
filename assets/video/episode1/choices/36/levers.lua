local choosing = true
local img = Image.load('assets/video/episode1/choices/36/levers.png')

PMP.setVolume(pmpvolume)
PMP.play('assets/video/episode1/choices/36/levers.pmp', buttons.r)

screen.clear()
Image.draw(img, 0, 0)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()


while choosing do
    buttons.read()

    if buttons.pressed(buttons.square) then
        Image.unload(img)
	wr("em", "ellegaard")
    pedestal = nil
    temple_script = nil
        choosing = false
        nextscene =  "assets/video/episode1/choices/37/go_for_ellegaard.lua"
    elseif buttons.pressed(buttons.circle) then
        Image.unload(img)
	wr("em", "magnus")
    pedestal = nil
    temple_script = nil
        choosing = false
        nextscene =  "assets/video/episode1/choices/37/go_for_magnus.lua"
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
