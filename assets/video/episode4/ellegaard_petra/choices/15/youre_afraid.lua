-- Ivor's house Interactive Zone -- 
-- Starts Here! --
PMP.setVolume(pmpvolume)
local result = PMP.playEasy('assets/video/episode4/ellegaard_petra/choices/15/youre_afraid.pmp', buttons.r, true, 'assets/video/episode4/ellegaard_petra/choices/15/youre_afraid.srt', font, subssize, "#FFFFFF", "#000000/150", subs)
if result == 1 then
    -- Go To Menu
    return 1
end
nextscene = "assets/video/episode4/ellegaard_petra/choices/16/ivors_house.lua"
