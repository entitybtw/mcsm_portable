local choosing = true
local img = Image.load('assets/video/episode2/gabriel/3/go_get_help.png')

PMP.setVolume(pmpvolume)
PMP.play('assets/video/episode2/gabriel/3/go_get_help.pmp', buttons.r)

screen.clear()
Image.draw(img, 0, 0)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()

while choosing do
    buttons.read()

    if buttons.pressed(buttons.square) then
        Image.unload(img)
        choosing = false
        nextscene =  "assets/video/episode2/gabriel/4/hes_not_leaving.lua"
    elseif buttons.pressed(buttons.circle) then
        Image.unload(img)
        choosing = false
        nextscene =  "assets/video/episode2/gabriel/4/let_him_go_gabriel.lua"
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