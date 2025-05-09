checkFile("assets/saves/bf.txt", "bf")

local choosing = true
local img
if bf == "bow" then
    nextscene = "assets/video/episode2/magnus/start.pmp"
    img = Image.load("assets/video/episode2/magnus/start_withbow.png")
elseif bf == "fishing_pole" then
    nextscene = "assets/video/episode2/magnus/start.pmp"
    img = Image.load("assets/video/episode2/magnus/start_withfishingpole.png")
else
    LUA.quit()
end

PMP.setVolume(pmpvolume)
PMP.play(nextscene, buttons.r)

screen.clear()
Image.draw(img, 0, 0)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()

while choosing do
    buttons.read()

    if buttons.pressed(buttons.square) then
        Image.unload(img)
        choosing = false
        if bf == "bow" then
            nextscene = "assets/video/episode2/magnus/bow.lua"
        elseif bf == "fishing_pole" then
            nextscene = "assets/video/episode2/magnus/fishing_pole.lua"
        end
    elseif buttons.pressed(buttons.circle) then
        Image.unload(img)
        choosing = false
        nextscene = "assets/video/episode2/magnus/sword.lua"
    elseif buttons.pressed(buttons.l) then
        Image.unload(img)
        choosing = false
        nextscene = "./mainmenu.lua"
    elseif buttons.pressed(buttons.start) then
        Image.unload(img)
        choosing = false
        SaveGame(2)
        nextscene = "./mainmenu.lua"
    end
end
