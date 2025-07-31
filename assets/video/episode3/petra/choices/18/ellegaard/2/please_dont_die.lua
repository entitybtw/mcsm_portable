wr("3_status", "restart")
PMP.setVolume(pmpvolume)
local result = PMP.playEasy('assets/video/episode3/petra/choices/18/ellegaard/2/please_dont_die.pmp', buttons.r, true, 'assets/video/episode3/petra/choices/18/ellegaard/2/please_dont_die.srt', font, subssize, "#FFFFFF", "#000000/150", subs)
if result == 1 then
    nextscene = "./mainmenu.lua"
    return 1
end
PMP.setVolume(pmpvolume)
local result = PMP.playEasy('assets/video/credits/ep3.pmp', buttons.start, true, 'assets/video/credits/ep3.srt', font, subssize, "#FFFFFF", "#000000/150", subs)
if result == 1 then
    nextscene = "./mainmenu.lua"
    return 1
end
