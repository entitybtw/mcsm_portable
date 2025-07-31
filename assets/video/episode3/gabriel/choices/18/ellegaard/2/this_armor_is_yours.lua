wr("3_status", "restart")
PMP.setVolume(pmpvolume)
local result = PMP.playEasy('assets/video/episode3/gabriel/choices/18/ellegaard/2/this_armor_is_yours.pmp', buttons.r, true, 'assets/video/episode3/gabriel/choices/18/ellegaard/2/this_armor_is_yours.srt', font, subssize, "#FFFFFF", "#000000/150", subs)
if result == 1 then
    nextscene = "./mainmenu.lua"
    return 1
end
PMP.setVolume(pmpvolume)
PMP.playEasy('assets/video/credits/ep3.pmp', buttons.start)
nextscene = "./mainmenu.lua"