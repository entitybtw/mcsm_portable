local choosing = true
local img = Image.load('assets/video/episode1/choices/13/im_cool_if_he_is_' .. reuben .. '.png')

PMP.setVolume(pmpvolume)
PMP.play('assets/video/episode1/choices/13/im_cool_if_he_is_' .. reuben .. '.pmp', buttons.r)

screen.clear()
Image.draw(img, 0, 0)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()


while choosing do
    buttons.read()

    if buttons.pressed(buttons.square) then
        Image.unload(img)
        choosing = false
        nextscene =  "assets/video/episode1/choices/14/your_friend_hurt_my_pig.lua"
    elseif buttons.pressed(buttons.circle) then
        Image.unload(img)
        choosing = false
        nextscene =  "assets/video/episode1/choices/14/your_machine_was_cool.lua"
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
