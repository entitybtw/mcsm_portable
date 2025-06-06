checkFile("assets/saves/gp.txt", "gp")
local choosing = true
local img = Image.load('assets/video/episode2/ellegaard/choices/5/leave_her_alone.png')

PMP.setVolume(pmpvolume)
PMP.play('assets/video/episode2/ellegaard/choices/5/leave_her_alone.pmp', buttons.r)

screen.clear()
Image.draw(img, 0, 0)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()

while choosing do
    buttons.read()

    if buttons.pressed(buttons.square) then
        Image.unload(img)
        choosing = false
        if gp == "gabriel" then
            nextscene =  "assets/video/episode2/ellegaard/choices/6/lets_do_this.lua"
        elseif gp == "petra" then
            nextscene = "assets/video/episode2/ellegaard_petra/lets_do_this.lua"
        end
    elseif buttons.pressed(buttons.circle) then
        Image.unload(img)
        choosing = false
        if gp == "gabriel" then
            nextscene =  "assets/video/episode2/ellegaard/choices/6/theres_no_time.lua"
        elseif gp == "petra" then
            nextscene = "assets/video/episode2/ellegaard_petra/theres_no_time.lua"
        end
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