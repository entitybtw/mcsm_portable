local choosing = true
local img = Image.load('assets/video/episode2/ellegaard_gabriel/3/he_wasnt_on_the_map.png')

PMP.setVolume(pmpvolume)
PMP.play('assets/video/episode2/ellegaard_gabriel/3/he_wasnt_on_the_map.pmp', buttons.r)

screen.clear()
Image.draw(img, 0, 0)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()

while choosing do
    buttons.read()

    if buttons.pressed(buttons.square) then
        Image.unload(img)
        choosing = false
        nextscene =  "assets/video/episode2/ellegaard_gabriel/4/he_can_be_a_jerk.lua"
    elseif buttons.pressed(buttons.circle) then
        Image.unload(img)
        choosing = false
        nextscene =  "assets/video/episode2/ellegaard_gabriel/4/hes_awesome.lua"
    elseif buttons.pressed(buttons.l) then
        Image.unload(img)
        choosing = false
        nextscene =  "./mainmenu.lua"
    elseif buttons.pressed(buttons.start) then
        Image.unload(img)
        choosing = false
        SaveGame(2)
        nextscene =  "./mainmenu.lua"
    end

end