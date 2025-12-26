local choosing = true
if crafting_table_used then petra_talk = true end
PMP.setVolume(pmpvolume)
local result = PMP.playEasy('assets/video/episode4/ellegaard_gabriel/choices/16/petra/youll_be_fine.pmp', buttons.r, true, 'assets/video/episode4/ellegaard_gabriel/choices/16/petra/you.srt', font, subssize, "#FFFFFF", "#000000/150", subs)
if result == 1 then
    -- Go To Menu
    return 1
else
    return 0
end

-- while choosing do
--     if not in_interactive_zone then
--         petra = false
--         in_interactive_zone = true
--         choosing = false
--         break
--     end
-- end
