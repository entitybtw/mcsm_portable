local choosing = true
local stat = sound.state(sound.MP3)
if stat.state == "stopped" then
    sound.play("assets/sounds/bg.mp3", sound.MP3, false, true)
end
PMP.play('assets/mainmenu/epmenu/ep1.pmp')


while choosing do
    buttons.read()
    if buttons.pressed(buttons.r) then
        choosing = false
	dofile("assets/mainmenu/epmenu/ep1_r.lua")
    end
    if buttons.pressed(buttons.square) then
        choosing = false
        dofile("./mainmenu.lua")
    end
    if buttons.pressed(buttons.triangle) then
        choosing = false
	screen.clear()
	screen.flip()
	stop_sound(sound.MP3)
        dofile("assets/video/episode1/start.lua")
    end
    if buttons.pressed(buttons.circle) then
        choosing = false
        screen.clear()
        screen.flip()
        dofile("assets/misc/saves_ep1.lua")
    end

end
