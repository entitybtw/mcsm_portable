local choosing = true
local img = Image.load('assets/video/episode1/choices/14/your_machine_was_cool_' .. reuben .. '.png')

PMP.setVolume(pmpvolume)
PMP.play('assets/video/episode1/choices/14/your_machine_was_cool_' .. reuben .. '.pmp', buttons.r)

screen.clear()
Image.draw(img, 0, 0)
debugoverlay.draw(debugoverlay.loadSettings())
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
