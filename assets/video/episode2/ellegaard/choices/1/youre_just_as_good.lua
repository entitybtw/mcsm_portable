-- Redstonia Interactive Zone -- 
-- Starts Here! --
PMP.setVolume(pmpvolume)
local result = PMP.playEasy('assets/video/episode2/ellegaard/choices/1/youre_just_as_good.pmp', buttons.r, true, 'assets/video/episode2/ellegaard/choices/1/youre_just_as_good.srt', font, subssize, "#FFFFFF", "#000000/150", subs)
if result == 1 then
    nextscene = "./mainmenu.lua"
    return 1
end
nextscene = "assets/video/episode2/ellegaard/choices/2/redstonia_zone.lua"