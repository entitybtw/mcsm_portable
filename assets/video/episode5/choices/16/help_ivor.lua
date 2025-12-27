local choosing = true
mi = "ivor"

PMP.setVolume(pmpvolume)
local result = PMP.playEasy('assets/video/episode5/choices/16/help_ivor.pmp', buttons.r, true, 'assets/video/episode5/choices/16/help_ivor.srt', font, subssize, "#FFFFFF", "#000000/150", subs)
if result == 1 then
    nextscene = "./mainmenu.lua"
    return 1
end

Image.draw(square, 25, 127)
Image.draw(circle, 455, 127)
intraFont.print(45, 127, "Shut up both of you", Color.new(255,255,255), font, 0.4)
intraFont.print(450 - intraFont.textW(font, "Yeah, Aidens our focus", 0.4), 127, "Yeah, Aidens our focus", Color.new(255,255,255), font, 0.4)
intraFont.print(340 - intraFont.textW(font, "Press R to save", 0.63), 230, "Press R to save", Color.new(255,255,255, 150), font, 0.63)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()

while choosing do
    buttons.read()

    if buttons.pressed(buttons.square) then
        choosing = false
        nextscene = "assets/video/episode5/choices/17/ivor/shut_up_both_of_you.lua"
    elseif buttons.pressed(buttons.circle) then
        choosing = false
        nextscene = "assets/video/episode5/choices/17/ivor/yeah_aidens_our_focus.lua"
    elseif buttons.pressed(buttons.start) then
choosing = false
local pause = dofile("assets/misc/pause.lua")
if pause == -1 then nextscene = "./mainmenu.lua" end
    elseif buttons.pressed(buttons.r) then
choosing = false
        SaveGame(5)
    end
end
