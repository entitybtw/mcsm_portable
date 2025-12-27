local choosing = true

PMP.setVolume(pmpvolume)
local result = PMP.playEasy('assets/video/episode5/choices/15/you_can_trust_me.pmp', buttons.r, true, 'assets/video/episode5/choices/15/you_can_trust_me.srt', font, subssize, "#FFFFFF", "#000000/150", subs)
if result == 1 then
    nextscene = "./mainmenu.lua"
    return 1
end

Image.draw(square, 25, 127)
Image.draw(circle, 455, 127)
intraFont.print(45, 127, "Help Ivor", Color.new(255,255,255), font, 0.4)
intraFont.print(450 - intraFont.textW(font, "Go with Milo", 0.4), 127, "Go with Milo", Color.new(255,255,255), font, 0.4)
intraFont.print(340 - intraFont.textW(font, "Press R to save", 0.63), 230, "Press R to save", Color.new(255,255,255, 150), font, 0.63)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()

while choosing do
    buttons.read()

    if buttons.pressed(buttons.square) then
        choosing = false
        nextscene = "assets/video/episode5/choices/16/help_ivor.lua"
    elseif buttons.pressed(buttons.circle) then
        choosing = false
        nextscene = "assets/video/episode5/choices/16/go_with_milo.lua"
    elseif buttons.pressed(buttons.start) then
choosing = false
local pause = dofile("assets/misc/pause.lua")
if pause == -1 then nextscene = "./mainmenu.lua" end
    elseif buttons.pressed(buttons.r) then
choosing = false
        SaveGame(5)
    end
end
