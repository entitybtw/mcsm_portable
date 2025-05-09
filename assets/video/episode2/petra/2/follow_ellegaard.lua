local choosing = true
local img = Image.load('assets/video/episode2/petra/2/follow_ellegaard.png')

PMP.setVolume(pmpvolume)
PMP.play('assets/video/episode2/petra/2/follow_ellegaard.pmp', buttons.r)

screen.clear()
Image.draw(img, 0, 0)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()

while choosing do
    buttons.read()

    if buttons.pressed(buttons.square) then
        Image.unload(img)
        choosing = false
        nextscene =  "assets/video/episode2/petra/3/go_get_help.lua"
    elseif buttons.pressed(buttons.circle) then
        Image.unload(img)
        choosing = false
        nextscene =  "assets/video/episode2/petra/3/im_fine.lua"
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