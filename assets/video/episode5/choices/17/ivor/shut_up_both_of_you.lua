local choosing = true

PMP.setVolume(pmpvolume)
local result = PMP.playExt('assets/video/episode5/choices/17/ivor/shut_up_both_of_you.pmp', buttons.r, true, 'assets/subtitles/episode5/choices/17/ivor/shut_up_both_of_you.srt', font, subssize, "#FFFFFF", "#000000/150", subs)
if result == 1 then
    nextscene = "./mainmenu.lua"
    return 1
end

Image.draw(spritesheet, 25, 127, 15, 15, nil, 414, 0, 15, 15)
Image.draw(spritesheet, 455, 127, 15, 15, nil, 384, 0, 15, 15)
intraFont.print(45, 127, choices_fifth.aiden_is_using_you, Color.new(255,255,255), font, 0.4)
intraFont.print(450 - intraFont.textW(font, choices_fifth.he_stole_from_us, 0.4), 127, choices_fifth.he_stole_from_us, Color.new(255,255,255), font, 0.4)
intraFont.print(340 - intraFont.textW(font, ui.save, 0.63), 230, ui.save, Color.new(255,255,255, 150), font, 0.63)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()

while choosing do
    buttons.read()

    if buttons.pressed(buttons.square) then
        choosing = false
        nextscene = "assets/video/episode5/choices/18/ivor/aiden_is_using_you.lua"
    elseif buttons.pressed(buttons.circle) then
        choosing = false
        nextscene = "assets/video/episode5/choices/18/ivor/he_stole_from_us.lua"
    elseif buttons.pressed(buttons.start) then
choosing = false
local pause = dofile("assets/misc/pause.lua")
if pause == -1 then nextscene = "./mainmenu.lua" end
    elseif buttons.pressed(buttons.r) then
choosing = false
        SaveGame(5)
    end
end
