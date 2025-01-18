local choosing = true
local img = Image.load('assets/video/episode1/choices/16/chicken_machine.png')
local cm_button = buttons.circle
local cm_script = "assets/video/episode1/choices/16/slime.lua"
if slime == "off" then
    img = Image.load('assets/video/episode1/choices/16/chicken_machine.png')
    cm_button = buttons.circle
    cm_script = "assets/video/episode1/choices/16/slime.lua"
elseif slime == "on" then
    img = Image.load('assets/video/episode1/choices/16/chicken_machine_slime.png')
    cm_button = buttons.cross
    cm_script = "assets/video/episode1/choices/16/lukas.lua"
end

PMP.play('assets/video/episode1/choices/16/chicken_machine.pmp', buttons.r)

screen.clear()
Image.draw(img, 0, 0)
screen.flip()


while choosing do
    buttons.read()

    if buttons.pressed(buttons.square) then
        Image.unload(img)
        choosing = false
        dofile("assets/video/episode1/choices/16/chicken_machine.lua")
    elseif buttons.pressed(cm_button) then
        Image.unload(img)
        choosing = false
        dofile(cm_script)
    elseif slime == "on" and buttons.pressed(buttons.circle) then
        Image.unload(img)
        choosing = false
        dofile("assets/video/episode1/choices/16/crafting_table.lua")
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
