wr("2_status", "restart")
PMP.setVolume(pmpvolume)
local result = PMP.playEasy('assets/video/episode2/gabriel/5/be_careful.pmp', buttons.r, true, 'assets/video/episode2/gabriel/5/be_careful.srt', font, subssize, "#FFFFFF", "#000000/150", subs)
if result == 1 then
    nextscene = "./mainmenu.lua"
    return 1
end
PMP.setVolume(pmpvolume)
local result = PMP.playEasy('assets/video/credits/ep2.pmp', buttons.start, true, 'assets/video/credits/ep2.srt', font, subssize, "#FFFFFF", "#000000/150", subs)
if result == 1 then
    nextscene = "./mainmenu.lua"
    return 1
end
PMP.setVolume(pmpvolume)
