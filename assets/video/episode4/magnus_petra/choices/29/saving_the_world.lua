wr("4_status", "restart")
PMP.setVolume(pmpvolume)
local result = PMP.playEasy('assets/video/episode4/magnus_petra/choices/29/saving_the_world.pmp', buttons.r, true, 'assets/video/episode4/magnus_petra/choices/29/saving_the_world.srt', font, subssize, "#FFFFFF", "#000000/150", subs)
if result == 1 then
    nextscene = "./mainmenu.lua"
    return 1
end
PMP.setVolume(pmpvolume)
local result = PMP.playEasy('assets/video/credits/ep4.pmp', buttons.start)
if result == 1 then
    nextscene = "./mainmenu.lua"
    return 1
end
PMP.setVolume(pmpvolume)
