-- The Temple Interactive Zone -- 
-- Starts Here! --
PMP.setVolume(pmpvolume)
local result = PMP.playEasy('assets/video/episode1/choices/5/warrior_whip.pmp', buttons.r, true, 'assets/video/episode1/choices/5/warrior_whip.srt', font, subssize, "#FFFFFF", "#000000/150", subs)
if result == 1 then
    nextscene = "./mainmenu.lua"
    return 1
end
nextscene = "assets/video/episode1/choices/6/the_woods_zone.lua"