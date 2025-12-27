-- Ivor's house Interactive Zone -- 
-- Starts Here! --
PMP.setVolume(pmpvolume)
local result = PMP.playEasy('assets/video/episode4/ellegaard_gabriel/choices/15/the_chicken_machine.pmp', buttons.r, true, 'assets/video/episode4/ellegaard_gabriel/choices/15/the_chicken_machine.srt', font, subssize, "#FFFFFF", "#000000/150", subs)
if result == 1 then
    nextscene = "./mainmenu.lua"
    return 1
end
nextscene = "assets/video/episode4/ellegaard_gabriel/choices/16/ivors_house.lua"