local choosing = true
local img = Image.load('assets/video/episode2/magnus/choices/5/you_dont_trust_me.png')

PMP.setVolume(pmpvolume)
PMP.play('assets/video/episode2/magnus/choices/5/you_dont_trust_me.pmp', buttons.r)

screen.clear()
Image.draw(img, 0, 0)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()

while choosing do
    buttons.read()

    if buttons.pressed(buttons.square) then
        Image.unload(img)
        choosing = false
        nextscene =  "assets/video/episode2/magnus/choices/6/how_could_i_beat_you.lua"
    elseif buttons.pressed(buttons.circle) then
        Image.unload(img)
        choosing = false
        nextscene =  "assets/video/episode2/magnus/choices/6/then_id_be_stuck_here.lua"
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
