-- Endercon Interactive Zone -- 
-- Starts Here! --
sword = "_sword"
PMP.setVolume(pmpvolume)
local result = PMP.playEasy('assets/video/episode1/choices/15/threaten_' .. reuben .. '.pmp', buttons.r)
if result == 1 then
    nextscene = "./mainmenu.lua"
    return 1
end
nextscene = "assets/video/episode1/choices/16/endercon_zone.lua"