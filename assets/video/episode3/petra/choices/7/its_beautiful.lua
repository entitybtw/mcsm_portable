-- The Woolland Interactive Zone -- 
-- Starts Here! --
PMP.setVolume(pmpvolume)
local result = PMP.playEasy('assets/video/episode3/petra/choices/7/its_beautiful.pmp', buttons.r, true, 'assets/video/episode3/petra/choices/7/its_beautiful.srt', font, subssize, "#FFFFFF", "#000000/150", subs)
if result == 1 then
    -- Go To Menu
    return 1
end
nextscene = "assets/video/episode3/petra/choices/8/woolland_zone.lua"