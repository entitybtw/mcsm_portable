wr("1_status", "restart")
PMP.setVolume(pmpvolume)
local result = PMP.playEasy('assets/video/episode1/choices/37/go_for_magnus.pmp', buttons.r, true, 'assets/video/episode1/choices/37/go_for_magnus.srt', font, subssize, "#FFFFFF", "#000000/150", subs)
if result == 1 then
    nextscene = "./mainmenu.lua"
    return 1
end
PMP.setVolume(pmpvolume)
PMP.playEasy('assets/video/credits/ep1.pmp', buttons.start)
nextscene = "./mainmenu.lua"