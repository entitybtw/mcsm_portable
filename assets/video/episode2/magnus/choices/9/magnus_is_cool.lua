checkFile("assets/saves/gp.txt", "gp")
local choosing = true

PMP.setVolume(pmpvolume)
local result = PMP.playEasy('assets/video/episode2/magnus/choices/9/magnus_is_cool.pmp', buttons.r, true, 'assets/video/episode2/magnus/choices/9/magnus_is_cool.srt', font, subssize, "#FFFFFF", "#000000/150", subs)
if result == 1 then
    nextscene = "./mainmenu.lua"
    return 1
end
Image.draw(square, 25, 127)
Image.draw(circle, 455, 127)
intraFont.print(45, 127, "Magnus calm down", Color.new(255,255,255), font, 0.4)
intraFont.print(450 - intraFont.textW(font, "Stay out of it, Olivia", 0.4), 127, "Stay out of it, Olivia", Color.new(255,255,255), font, 0.4)
intraFont.print(340 - intraFont.textW(font, "Press R to save", 0.63), 230, "Press R to save", Color.new(255,255,255, 150), font, 0.63)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()

while choosing do
    buttons.read()
    if buttons.pressed(buttons.square) then
        choosing = false
        if gp == "petra" then
            nextscene = "assets/video/episode2/magnus_petra/choices/2/stay_out_of_it_olivia.lua"
        elseif gp == "gabriel" then
            nextscene = "assets/video/episode2/magnus_gabriel/2/stay_out_of_it_olivia.lua"
        end
    elseif buttons.pressed(buttons.circle) then
        choosing = false
        if gp == "petra" then
            nextscene = "assets/video/episode2/magnus_petra/choices/2/magnus_calm_down.lua"
        elseif gp == "gabriel" then
            nextscene = "assets/video/episode2/magnus_gabriel/2/magnus_calm_down.lua"
        end
    elseif buttons.pressed(buttons.start) then
choosing = false
local pause = dofile("assets/misc/pause.lua")
if pause == -1 then nextscene = "./mainmenu.lua" end
    elseif buttons.pressed(buttons.r) then
choosing = false
        SaveGame(2)
end
end
