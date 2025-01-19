local choosing = true
local img = Image.load('assets/video/episode1/choices/36/olivia.png')
local temple_script = "assets/video/episode1/choices/36/olivia.lua"
if pedestal == "off" then
    img = Image.load('assets/video/episode1/choices/36/olivia.png')
    PMP.play('assets/video/episode1/choices/36/olivia.pmp', buttons.r)
    temple_script = "assets/video/episode1/choices/36/pedestal.lua"
elseif pedestal == "on" then
    img = Image.load('assets/video/episode1/choices/36/olivia_pedestal.png')
    PMP.play('assets/video/episode1/choices/36/olivia_pedestal.pmp', buttons.r)
    temple_script = "assets/video/episode1/choices/36/levers.lua"
end

screen.clear()
Image.draw(img, 0, 0)
screen.flip()


while choosing do
    buttons.read()

    if buttons.pressed(buttons.square) then
        Image.unload(img)
        choosing = false
        dofile("assets/video/episode1/choices/36/axel.lua")
    elseif buttons.pressed(buttons.circle) then
        Image.unload(img)
        choosing = false
        dofile("assets/video/episode1/choices/36/lukas.lua")
    elseif buttons.pressed(buttons.triangle) then
        Image.unload(img)
        choosing = false
        dofile("assets/video/episode1/choices/36/olivia.lua")
    elseif buttons.pressed(buttons.cross) then
        Image.unload(img)
        choosing = false
        dofile(temple_script)
    elseif buttons.pressed(buttons.l) then
        Image.unload(img)
        choosing = false
        dofile("./mainmenu.lua")
    elseif buttons.pressed(buttons.start) then
        Image.unload(img)
        choosing = false
        SaveGame(1)
        dofile("./mainmenu.lua")
    end


end
