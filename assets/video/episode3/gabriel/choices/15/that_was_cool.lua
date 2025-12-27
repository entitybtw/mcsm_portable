-- The Loot Room Interactive Zone -- 
-- Starts Here! --
PMP.setVolume(pmpvolume)
local result = PMP.playEasy('assets/video/episode3/gabriel/choices/15/that_was_cool.pmp', buttons.r, true, 'assets/video/episode3/gabriel/choices/15/that_was_cool.srt', font, subssize, "#FFFFFF", "#000000/150", subs)
if result == 1 then
    nextscene = "./mainmenu.lua"
    return 1
end
nextscene = "assets/video/episode3/gabriel/choices/16/loot_room_zone.lua"