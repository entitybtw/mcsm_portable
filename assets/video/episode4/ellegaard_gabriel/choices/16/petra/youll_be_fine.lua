local choosing = true
PMP.setVolume(pmpvolume)
local result = PMP.playEasy('assets/video/episode4/ellegaard_gabriel/choices/16/petra/youll_be_fine.pmp', buttons.r, true, 'assets/video/episode4/ellegaard_gabriel/choices/16/petra/youll_be_fine.srt', font, subssize, "#FFFFFF", "#000000/150", subs)
if result == 1 then
    -- Go To Menu
    return 1
end