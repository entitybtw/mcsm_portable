local choosing = true
local img = Image.load('assets/video/episode1/choices/14/your_friend_hurt_my_pig_' .. reuben .. '.png')

PMP.play('assets/video/episode1/choices/14/your_friend_hurt_my_pig_' .. reuben .. '.pmp', buttons.r)

screen.clear()
Image.draw(img, 0, 0)
screen.flip()


while choosing do
    buttons.read()

    if buttons.pressed(buttons.square) then
        Image.unload(img)
        choosing = false
        nextscene =  "assets/video/episode1/choices/15/offer_sword.lua"
    elseif buttons.pressed(buttons.circle) then
        Image.unload(img)
        choosing = false
        nextscene =  "assets/video/episode1/choices/15/threaten.lua"
    elseif buttons.pressed(buttons.l) then
        Image.unload(img)
        choosing = false
        nextscene =  "./mainmenu.lua"
    end


end
