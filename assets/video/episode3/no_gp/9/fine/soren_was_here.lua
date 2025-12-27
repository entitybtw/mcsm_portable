-- The Woolland Interactive Zone -- 
-- Starts Here! --
PMP.setVolume(pmpvolume)
local result = PMP.playEasy('assets/video/episode3/no_gp/9/fine/soren_was_here.pmp', buttons.r, true, 'assets/video/episode3/no_gp/9/fine/soren_was_here.srt', font, subssize, "#FFFFFF", "#000000/150", subs)
if result == 1 then
    -- Go To Menu
    return 1
end
nextscene = "assets/video/episode3/no_gp/10/the_lab_zone.lua"