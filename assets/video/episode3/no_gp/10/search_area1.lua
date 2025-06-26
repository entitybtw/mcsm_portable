local choosing = true
local img = Image.load('assets/video/episode3/no_gp/10/search_area1.png')

PMP.setVolume(pmpvolume)
PMP.play('assets/video/episode3/no_gp/10/search_area1.pmp', buttons.r)

screen.clear()
Image.draw(img, 0, 0)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()

while choosing do
    buttons.read()

    if buttons.pressed(buttons.circle) then
        Image.unload(img)
        choosing = false
        nextscene =  "assets/video/episode3/no_gp/10/search_area2.lua"
    elseif buttons.pressed(buttons.cross) then
        Image.unload(img)
        choosing = false
        nextscene =  "assets/video/episode3/no_gp/10/search_upstairs.lua"
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


