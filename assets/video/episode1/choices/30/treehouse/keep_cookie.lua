local choosing = true
local img = Image.load('assets/video/episode1/choices/30/treehouse/keep_cookie.png')

PMP.play('assets/video/episode1/choices/30/treehouse/keep_cookie.pmp', buttons.r)

screen.clear()
Image.draw(img, 0, 0)
screen.flip()


while choosing do
    buttons.read()

    if buttons.pressed(buttons.square) then
        Image.unload(img)
        choosing = false
        dofile("assets/video/episode1/choices/30/treehouse/31/stay_here.lua")
    elseif buttons.pressed(buttons.circle) then
        Image.unload(img)
        choosing = false
        dofile("assets/video/episode1/choices/30/treehouse/31/you_should_go.lua")
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
