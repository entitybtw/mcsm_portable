-- The Temple Interactive Zone -- 
-- Starts Here! --
PMP.setVolume(pmpvolume)
local result = PMP.playEasy('assets/video/episode1/choices/5/redstone_rap.pmp', buttons.r, true, 'assets/video/episode1/choices/5/redstone_rap.srt', font, subssize, "#FFFFFF", "#000000/150", subs)
if result == 1 then
    -- Go To Menu
    return 1
end
nextscene = "assets/video/episode1/choices/6/the_woods_zone.lua"