-- Ivor's house Interactive Zone -- 
-- Starts Here! --
PMP.setVolume(pmpvolume)
local result = PMP.playEasy('assets/video/episode4/magnus_petra/choices/15/is_that_true.pmp', buttons.r, true, 'assets/video/episode4/magnus_petra/choices/15/is_that_true.srt', font, subssize, "#FFFFFF", "#000000/150", subs)
if result == 1 then
    nextscene = "./mainmenu.lua"
    return 1
end
nextscene = "assets/video/episode4/magnus_petra/choices/16/ivors_house.lua"