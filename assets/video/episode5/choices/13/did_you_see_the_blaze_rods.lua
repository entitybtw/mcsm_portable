-- The Temple Interactive Zone -- 
-- Starts Here! --
PMP.setVolume(pmpvolume)
local result = PMP.playEasy('assets/video/episode5/choices/13/did_you_see_the_blaze_rods.pmp', buttons.r, true, 'assets/video/episode5/choices/13/did_you_see_the_blaze_rods.srt', font, subssize, "#FFFFFF", "#000000/150", subs)
if result == 1 then
    -- Go To Menu
    return 1
end
nextscene = "assets/video/episode5/choices/14/sky_city_zone.lua"