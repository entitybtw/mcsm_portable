wr("2_status", "restart")
PMP.setVolume(pmpvolume)
local result = PMP.playEasy('assets/video/episode2/gabriel/5/hes_done_this_before.pmp', buttons.r, true, 'assets/video/episode2/gabriel/5/hes_done_this_before.srt', font, subssize, "#FFFFFF", "#000000/150", subs)
if result == 1 then
    nextscene = "./mainmenu.lua"
    return 1
end
PMP.setVolume(pmpvolume)
PMP.playEasy('assets/video/credits/ep2.pmp', buttons.start)
nextscene = "./mainmenu.lua"
