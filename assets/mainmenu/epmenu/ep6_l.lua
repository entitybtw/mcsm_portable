local choosing = true
local stat = sound.state(sound.MP3)
if stat.state == "stopped" then
    sound.play("assets/sounds/bg.mp3", sound.MP3, false, true)
end
PMP.play('assets/mainmenu/epmenu/ep6_l.pmp')

while choosing do
    buttons.read()
    if buttons.pressed(buttons.l) then
        choosing = false
        dofile("assets/mainmenu/epmenu/ep5_l.lua")
    end
    if buttons.pressed(buttons.r) then
        choosing = false
        dofile("assets/mainmenu/epmenu/ep5_r.lua")
    end
    if buttons.pressed(buttons.square) then
        choosing = false
        dofile("./mainmenu.lua")
    end
    if buttons.pressed(buttons.triangle) then
        choosing = false
        screen.clear()
        screen.flip()
        dofile("assets/misc/not_yet.lua")
    end
    if buttons.pressed(buttons.circle) then
        choosing = false
        screen.clear()
        screen.flip()
        dofile("assets/misc/not_yet.lua")
    end

end
