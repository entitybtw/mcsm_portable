checkFile("assets/saves/gp.txt", "gp")
local choosing = true

PMP.setVolume(pmpvolume)
local result = PMP.playEasy('assets/video/episode2/ellegaard/choices/5/we_have_bigger_issues.pmp', buttons.r, true, 'assets/video/episode2/ellegaard/choices/5/we_have_bigger_issues.srt', font, subssize, "#FFFFFF", "#000000/150", subs)
if result == 1 then
    nextscene = "./mainmenu.lua"
    return 1
end
Image.draw(square, 25, 127)
Image.draw(circle, 455, 127)
intraFont.print(45, 127, "Let's do this", Color.new(255,255,255), font, 0.4)
intraFont.print(450 - intraFont.textW(font, "There's no time", 0.4), 127, "There's no time", Color.new(255,255,255), font, 0.4)
intraFont.print(340 - intraFont.textW(font, "Press R to save", 0.63), 230, "Press R to save", Color.new(255,255,255, 150), font, 0.63)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()

while choosing do
    buttons.read()
    if buttons.pressed(buttons.square) then
        choosing = false
        if gp == "gabriel" then
            nextscene =  "assets/video/episode2/ellegaard/choices/6/lets_do_this.lua"
        elseif gp == "petra" then
            nextscene = "assets/video/episode2/ellegaard_petra/lets_do_this.lua"
        end
    elseif buttons.pressed(buttons.circle) then
        choosing = false
        if gp == "gabriel" then
            nextscene =  "assets/video/episode2/ellegaard/choices/6/theres_no_time.lua"
        elseif gp == "petra" then
            nextscene = "assets/video/episode2/ellegaard_petra/theres_no_time.lua"
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
