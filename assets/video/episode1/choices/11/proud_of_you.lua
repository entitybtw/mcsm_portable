local choosing = true
local img = Image.load('assets/video/episode1/choices/11/proud_of_you_' .. reuben .. '.png')

PMP.setVolume(pmpvolume)
PMP.play('assets/video/episode1/choices/11/proud_of_you_' .. reuben .. '.pmp', buttons.r)

screen.clear()
Image.draw(img, 0, 0)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()


while choosing do
    buttons.read()

    if buttons.pressed(buttons.square) then
        Image.unload(img)
        choosing = false
        nextscene = "assets/video/episode1/choices/12/im_jesse.lua"
    elseif buttons.pressed(buttons.circle) then
        Image.unload(img)
        choosing = false
        nextscene = "assets/video/episode1/choices/12/who_are_you.lua"
    elseif buttons.pressed(buttons.l) then
        Image.unload(img)
        choosing = false
        nextscene = "./mainmenu.lua"
    elseif buttons.pressed(buttons.start) then
        Image.unload(img)
        choosing = false
        SaveGame(1)
        nextscene = "./mainmenu.lua"
    end


end
