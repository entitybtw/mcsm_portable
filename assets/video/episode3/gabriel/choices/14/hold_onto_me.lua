local choosing = true
PMP.setVolume(pmpvolume)
local result = PMP.playEasy('assets/video/episode3/gabriel/choices/14/hold_onto_me.pmp', buttons.r, true, 'assets/video/episode3/gabriel/choices/14/hold_onto_me.srt', font, subssize, "#FFFFFF", "#000000/150", subs)
if result == 1 then
    nextscene = "./mainmenu.lua"
    return 1
end

Image.draw(square, 25, 127)
Image.draw(circle, 455, 127)
intraFont.print(45, 127, "That was cool", Color.new(255,255,255), font, 0.4)
intraFont.print(450 - intraFont.textW(font, "That was scary", 0.4), 127, "That was scary", Color.new(255,255,255), font, 0.4)
intraFont.print(340 - intraFont.textW(font, "Press R to save", 0.63), 230, "Press R to save", Color.new(255,255,255, 150), font, 0.63)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()
while choosing do
    buttons.read()

    if buttons.pressed(buttons.square) then
        choosing = false
        nextscene =  "assets/video/episode3/gabriel/choices/15/that_was_cool.lua"
    elseif buttons.pressed(buttons.circle) then
        choosing = false
        nextscene =  "assets/video/episode3/gabriel/choices/15/that_was_scary.lua"
    elseif buttons.pressed(buttons.start) then
choosing = false
local pause = dofile("assets/misc/pause.lua")
if pause == -1 then nextscene = "./mainmenu.lua" end
    elseif buttons.pressed(buttons.r) then
choosing = false
        SaveGame(3)
    end

end

