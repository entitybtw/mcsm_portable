PMP.setVolume(pmpvolume)
local result = PMP.playEasy('assets/video/episode4/ellegaard_petra/choices/16/petra/i_wont_lie_to_you.pmp', buttons.r, true, 'assets/video/episode4/ellegaard_petra/choices/16/petra/i_wont_lie_to_you.srt', font, subssize, "#FFFFFF", "#000000/150", subs)
if result == 1 then
    -- Go To Menu
    return 1
end