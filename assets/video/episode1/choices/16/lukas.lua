local choosing = true
local img = Image.load('assets/video/episode1/choices/16/lukas.png')

PMP.play('assets/video/episode1/choices/16/lukas.pmp', buttons.r)

screen.clear()
Image.draw(img, 0, 0)
screen.flip()


while choosing do
    buttons.read()

    if buttons.pressed(buttons.square) then
        Image.unload(img)
        choosing = false
        slime = nil
        cm_button = nil
        cm_script = nil
        dofile("assets/video/episode1/choices/17/we_ask_politely.lua")
    elseif buttons.pressed(buttons.circle) then
        Image.unload(img)
        choosing = false
        cm_button = nil
        cm_script = nil
        slime = nil
        dofile("assets/video/episode1/choices/17/we_get_payback.lua")
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
