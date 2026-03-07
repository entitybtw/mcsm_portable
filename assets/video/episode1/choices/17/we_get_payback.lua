local choosing = true
PMP.setVolume(pmpvolume)
local result = PMP.playExt('assets/video/episode1/choices/17/we_get_payback' .. sword .. '.pmp', buttons.r, true, 'assets/subtitles/episode1/choices/17/we_get_payback' .. sword .. '.srt', font, subssize, "#FFFFFF", "#000000/150", subs)
if result == 1 then
    nextscene = "./mainmenu.lua"
    return 1
end

Image.draw(spritesheet, 25, 127, 15, 15, nil, 414, 0, 15, 15)
Image.draw(spritesheet, 455, 127, 15, 15, nil, 384, 0, 15, 15)
intraFont.print(45, 127, choices_one.its_all_yours, Color.new(255,255,255), font, 0.4)
intraFont.print(450 - intraFont.textW(font, choices_one.leave_it_alone, 0.4), 127, choices_one.leave_it_alone, Color.new(255,255,255), font, 0.4)
intraFont.print(340 - intraFont.textW(font, "Press R to save", 0.63), 230, "Press R to save", Color.new(255,255,255, 150), font, 0.63)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()

while choosing do
    buttons.read()
    if buttons.pressed(buttons.square) then
        choosing = false
        nextscene = "assets/video/episode1/choices/18/its_all_yours.lua"
    elseif buttons.pressed(buttons.circle) then
        choosing = false
        nextscene = "assets/video/episode1/choices/18/leave_it_alone.lua"
    elseif buttons.pressed(buttons.start) then
choosing = false
local pause = dofile("assets/misc/pause.lua")
if pause == -1 then nextscene = "./mainmenu.lua" end
    elseif buttons.pressed(buttons.r) then
choosing = false
        SaveGame(1)

end
end
