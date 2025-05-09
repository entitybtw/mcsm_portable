local choosing = true
local img = Image.load('assets/video/episode2/ellegaard_petra/choices/1/how_did_you_escape.png')

PMP.setVolume(pmpvolume)
PMP.play('assets/video/episode2/ellegaard_petra/choices/1/how_did_you_escape.pmp', buttons.r)

screen.clear()
Image.draw(img, 0, 0)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()

while choosing do
    buttons.read()

    if buttons.pressed(buttons.square) then
        Image.unload(img)
        choosing = false
        nextscene =  "assets/video/episode2/ellegaard/choices/8/ellegaard_is_cool.lua"
    elseif buttons.pressed(buttons.circle) then
        Image.unload(img)
        choosing = false
        nextscene =  "assets/video/episode2/ellegaard/choices/8/you_need_to_get_along.lua"
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
