local choosing = true
PMP.setVolume(pmpvolume)
local result = PMP.playExt('assets/video/episode4/ellegaard_petra/choices/2/go_talk_to_petra.pmp', buttons.r, true, 'assets/subtitles/episode4/ellegaard_petra/choices/2/go_talk_to_petra.srt', font, subssize, "#FFFFFF", "#000000/150", subs)
if result == 1 then
    nextscene = "./mainmenu.lua"
    return 1
end

Image.draw(spritesheet, 25, 127, 15, 15, nil, 414, 0, 15, 15)
Image.draw(spritesheet, 455, 127, 15, 15, nil, 384, 0, 15, 15)
intraFont.print(45, 127, choices_fourth.its_ivors_fault, Color.new(255,255,255), font, 0.4)
intraFont.print(450 - intraFont.textW(font, choices_fourth.you_didnt_know, 0.4), 127, choices_fourth.you_didnt_know, Color.new(255,255,255), font, 0.4)
intraFont.print(340 - intraFont.textW(font, ui.save, 0.63), 230, ui.save, Color.new(255,255,255, 150), font, 0.63)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()
while choosing do
    buttons.read()

    if buttons.pressed(buttons.square) then
        choosing = false
        nextscene = "assets/video/episode4/ellegaard_petra/choices/3/petra/its_ivors_fault.lua"
    elseif buttons.pressed(buttons.circle) then
        choosing = false
        nextscene = "assets/video/episode4/ellegaard_petra/choices/3/petra/you_didnt_know.lua"
    elseif buttons.pressed(buttons.start) then
choosing = false
local pause = dofile("assets/misc/pause.lua")
if pause == -1 then nextscene = "./mainmenu.lua" end
    elseif buttons.pressed(buttons.r) then
choosing = false
        SaveGame(4)
    end
end
