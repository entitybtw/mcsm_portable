local choosing = true
local img = Image.load('assets/video/episode3/petra/choices/15/that_was_cool.png')

PMP.setVolume(pmpvolume)
PMP.play('assets/video/episode3/petra/choices/15/that_was_cool.pmp', buttons.r)

screen.clear()
Image.draw(img, 0, 0)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()

while choosing do
    buttons.read()

    if buttons.pressed(buttons.square) then
        Image.unload(img)
        choosing = false
        nextscene =  "assets/video/episode3/petra/choices/16/button.lua"
    elseif buttons.pressed(buttons.circle) then
        Image.unload(img)
        choosing = false
        nextscene =  "assets/video/episode3/petra/choices/16/axel.lua"
    elseif buttons.pressed(buttons.cross) then
        Image.unload(img)
        choosing = false
        nextscene =  "assets/video/episode3/petra/choices/16/lukas.lua"
    elseif buttons.pressed(buttons.triangle) then
        Image.unload(img)
        choosing = false
        nextscene =  "assets/video/episode3/petra/choices/16/olivia.lua"
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

