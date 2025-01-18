local choosing = true
local img = Image.load('assets/video/episode1/choices/16/slime.png')

PMP.play('assets/video/episode1/choices/16/slime.pmp', buttons.r)

screen.clear()
Image.draw(img, 0, 0)
screen.flip()


while choosing do
    buttons.read()

    if buttons.pressed(buttons.square) then
        Image.unload(img)
        choosing = false
        slime = "on"
        dofile("assets/video/episode1/choices/16/chicken_machine.lua")
    elseif buttons.pressed(buttons.circle) then
        Image.unload(img)
        choosing = false
        dofile("assets/video/episode1/choices/16/crafting_table.lua")
    elseif buttons.pressed(buttons.cross) then
        Image.unload(img)
        choosing = false
        dofile("assets/video/episode1/choices/16/lukas.lua")
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







