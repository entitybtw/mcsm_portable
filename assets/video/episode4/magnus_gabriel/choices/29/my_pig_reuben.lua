wr("4_status", "restart")
PMP.setVolume(pmpvolume)
local result = PMP.playEasy('assets/video/episode4/magnus_gabriel/choices/29/my_pig_reuben.pmp', buttons.r, true, 'assets/video/episode4/magnus_gabriel/choices/29/my_pig_reuben.srt', font, subssize, "#FFFFFF", "#000000/150", subs)
if result == 1 then
    nextscene = "./mainmenu.lua"
    return 1
end
PMP.setVolume(pmpvolume)
PMP.playEasy('assets/video/credits/ep4.pmp', buttons.start)
nextscene = "./mainmenu.lua"