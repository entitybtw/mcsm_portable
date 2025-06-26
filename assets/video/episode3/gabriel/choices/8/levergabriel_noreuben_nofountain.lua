local choosing = true
local img = Image.load('assets/video/episode3/gabriel/choices/8/levergabriel_noreuben_nofountain.png')

PMP.setVolume(pmpvolume)
PMP.play('assets/video/episode3/gabriel/choices/8/levergabriel.pmp', buttons.r)

screen.clear()
Image.draw(img, 0, 0)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()

while choosing do
    buttons.read()

    if buttons.pressed(buttons.circle) then
        Image.unload(img)
        choosing = false
        nextscene =  "assets/video/episode3/gabriel/choices/8/leverreuben_nolevergabriel_nofountain.lua"
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

