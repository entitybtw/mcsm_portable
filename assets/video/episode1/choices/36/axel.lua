local choosing = true
local img = Image.load('assets/video/episode1/choices/36/axel.png')
local temple_script = "assets/video/episode1/choices/36/pedestal.lua"
if pedestal == "off" then
    img = Image.load('assets/video/episode1/choices/36/axel.png')
PMP.setVolume(pmpvolume)
    PMP.play('assets/video/episode1/choices/36/axel.pmp', buttons.r)
    temple_script = "assets/video/episode1/choices/36/pedestal.lua"
elseif pedestal == "on" then
    img = Image.load('assets/video/episode1/choices/36/axel_pedestal.png')
PMP.setVolume(pmpvolume)
    PMP.play('assets/video/episode1/choices/36/axel_pedestal.pmp', buttons.r)
    temple_script = "assets/video/episode1/choices/36/levers.lua"
end


screen.clear()
Image.draw(img, 0, 0)
debugoverlay.draw(debugoverlay.loadSettings())
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
        nextscene = temple_script
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
