-- Endercon Interactive Zone -- 
-- Starts Here! --
sword = ""
PMP.setVolume(pmpvolume)
local result = PMP.playEasy('assets/video/episode1/choices/15/offer_sword_' .. reuben .. '.pmp', buttons.r)
if result == 1 then
    nextscene = "./mainmenu.lua"
    return 1
end
nextscene = "assets/video/episode1/choices/16/endercon_zone.lua"
