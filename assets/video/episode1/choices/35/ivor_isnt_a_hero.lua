-- The Temple Interactive Zone -- 
-- Starts Here! --
PMP.setVolume(pmpvolume)
local result = PMP.playEasy('assets/video/episode1/choices/35/ivor_isnt_a_hero.pmp', buttons.r, true, 'assets/video/episode1/choices/35/ivor_isnt_a_hero.srt', font, subssize, "#FFFFFF", "#000000/150", subs)
if result == 1 then
    -- Go To Menu
    return 1
end
nextscene = "assets/video/episode1/choices/36/the_temple_zone.lua"