local choosing = true
local img = Image.load('assets/video/episode2/ellegaard_gabriel/2/ellegaard_calm_down.png')

PMP.setVolume(pmpvolume)
PMP.play('assets/video/episode2/ellegaard_gabriel/2/ellegaard_calm_down.pmp', buttons.r)

screen.clear()
Image.draw(img, 0, 0)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()

while choosing do
    buttons.read()

    if buttons.pressed(buttons.square) then
        Image.unload(img)
        choosing = false
        nextscene =  "assets/video/episode2/ellegaard_gabriel/3/he_wasnt_on_the_map.lua"
    elseif buttons.pressed(buttons.circle) then
        Image.unload(img)
        choosing = false
        nextscene =  "assets/video/episode2/ellegaard_gabriel/3/we_can_find_him.lua"
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