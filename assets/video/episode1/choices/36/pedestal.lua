local choosing = true
pedestal = "on"
local img = Image.load('assets/video/episode1/choices/36/pedestal.png')

PMP.play('assets/video/episode1/choices/36/pedestal.pmp', buttons.r)

screen.clear()
Image.draw(img, 0, 0)
screen.flip()


while choosing do
    buttons.read()

    if buttons.pressed(buttons.square) then
        Image.unload(img)
        choosing = false
        nextscene =  "assets/video/episode1/choices/36/axel.lua"
    elseif buttons.pressed(buttons.circle) then
        Image.unload(img)
        choosing = false
        nextscene =  "assets/video/episode1/choices/36/lukas.lua"
    elseif buttons.pressed(buttons.triangle) then
        Image.unload(img)
        choosing = false
        nextscene =  "assets/video/episode1/choices/36/olivia.lua"
    elseif buttons.pressed(buttons.cross) then
        Image.unload(img)
        choosing = false
        nextscene =  "assets/video/episode1/choices/36/levers.lua"
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
