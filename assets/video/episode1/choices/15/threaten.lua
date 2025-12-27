-- Endercon Interactive Zone -- 
-- Starts Here! --
PMP.setVolume(pmpvolume)
local result = PMP.playEasy('assets/video/episode1/choices/15/threaten_' .. reuben .. '.pmp', buttons.r)
if result == 1 then
    -- Go To Menu
    return 1
end
nextscene = "assets/video/episode1/choices/16/endercon_zone.lua"