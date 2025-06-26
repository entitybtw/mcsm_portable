local choosing = true
local img = Image.load('assets/video/episode3/petra/choices/16/axel_button.png')

PMP.setVolume(pmpvolume)
PMP.play('assets/video/episode3/petra/choices/16/axel_button.pmp', buttons.r)

screen.clear()
Image.draw(img, 0, 0)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()

while choosing do
    buttons.read()

    if buttons.pressed(buttons.square) then
        Image.unload(img)
        choosing = false
        nextscene =  "assets/video/episode3/petra/choices/16/chest.lua"
    elseif buttons.pressed(buttons.cross) then
        Image.unload(img)
        choosing = false
        nextscene =  "assets/video/episode3/petra/choices/16/lukas2_noaxel.lua"
    elseif buttons.pressed(buttons.triangle) then
        Image.unload(img)
        choosing = false
        nextscene =  "assets/video/episode3/petra/choices/16/olivia2_noaxel.lua"
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

