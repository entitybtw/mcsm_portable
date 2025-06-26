local choosing = true
local img = Image.load('assets/video/episode3/petra/choices/4/help_reuben_and_axel/thanks_for_grabbing_it.png')

PMP.setVolume(pmpvolume)
PMP.play('assets/video/episode3/petra/choices/4/help_reuben_and_axel/thanks_for_grabbing_it.pmp', buttons.r)

screen.clear()
Image.draw(img, 0, 0)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()

while choosing do
    buttons.read()

    if buttons.pressed(buttons.square) then
        Image.unload(img)
        choosing = false
        nextscene =  "assets/video/episode3/petra/choices/5/a_haunting.lua"
    elseif buttons.pressed(buttons.circle) then
        Image.unload(img)
        choosing = false
        nextscene =  "assets/video/episode3/petra/choices/5/dont_look_at_them.lua"
    elseif buttons.pressed(buttons.l) then
        Image.unload(img)
        choosing = false
        nextscene =  "./mainmenu.lua"
    elseif buttons.pressed(buttons.start) then
        Image.unload(img)
        choosing = false
        SaveGame(3)
        nextscene =  "./mainmenu.lua"
    end

end

