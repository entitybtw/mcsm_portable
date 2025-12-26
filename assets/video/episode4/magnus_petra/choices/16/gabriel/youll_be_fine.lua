PMP.setVolume(pmpvolume)
local result = PMP.playEasy('assets/video/episode4/magnus_petra/choices/16/gabriel/youll_be_fine.pmp', buttons.r, true, 'assets/video/episode4/magnus_petra/choices/16/gabriel/youll_be_fine.srt', font, subssize, "#FFFFFF", "#000000/150", subs)
if result == 1 then
    -- Go To Menu
    return 1
end