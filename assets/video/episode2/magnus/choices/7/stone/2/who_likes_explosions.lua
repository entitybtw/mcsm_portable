local choosing = true
local img = Image.load('assets/video/episode2/magnus/choices/7/stone/2/who_likes_explosions.png')

PMP.setVolume(pmpvolume)
PMP.play('assets/video/episode2/magnus/choices/7/stone/2/who_likes_explosions.pmp', buttons.r)

screen.clear()
Image.draw(img, 0, 0)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()

while choosing do
    buttons.read()

    if buttons.pressed(buttons.square) then
        Image.unload(img)
        choosing = false
        nextscene =  "assets/video/episode2/magnus_gabriel/1/glad_youre_okay.lua"
    elseif buttons.pressed(buttons.circle) then
        Image.unload(img)
        choosing = false
        nextscene =  "assets/video/episode2/magnus_gabriel/1/how_did_you_escape.lua"
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
