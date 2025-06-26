local choosing = true
local img = Image.load('assets/video/episode3/petra/choices/17/why_did_you_leave.png')

PMP.setVolume(pmpvolume)
PMP.play('assets/video/episode3/petra/choices/17/why_did_you_leave.pmp', buttons.r)

screen.clear()
Image.draw(img, 0, 0)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()

while choosing do
    buttons.read()

    if buttons.pressed(buttons.square) then
        Image.unload(img)
        wr("ema", "magnus")
        choosing = false
        nextscene =  "assets/video/episode3/petra/choices/18/take_magnus_armor.lua"
    elseif buttons.pressed(buttons.circle) then
        Image.unload(img)
        wr("ema", "ellegaard")
        choosing = false
        nextscene =  "assets/video/episode3/petra/choices/18/take_ellegaards_armor.lua"
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

