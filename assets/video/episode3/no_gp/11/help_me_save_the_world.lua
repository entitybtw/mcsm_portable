checkFile("assets/saves/gp.txt", "gp")
local choosing = true
local square = Image.load("assets/icons/square.png")
local circle = Image.load("assets/icons/circle.png")

PMP.setVolume(pmpvolume)
PMP.playEasy('assets/video/episode3/no_gp/11/help_me_save_the_world.pmp', buttons.r, true, 'assets/video/episode3/no_gp/11/help_me_save_the_world.srt', font, subssize, "#FFFFFF", "#000000/150", subs)
Image.draw(square, 25, 127)
Image.draw(circle, 455, 127)
intraFont.print(25 + 15 + 5, 127, "I guess so", Color.new(255,255,255), font, 0.4)
intraFont.print(455 - 5 - intraFont.textW(font, "Not really", 0.4), 127, "Not really", Color.new(255,255,255), font, 0.4)
intraFont.print(345 - 5 - intraFont.textW(font, "Press R to save", 0.63), 230, "Press R to save", Color.new(255,255,255, 150), font, 0.63)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()

while choosing do
    buttons.read()
    if buttons.pressed(buttons.square) then
Image.unload(square)
Image.unload(circle)
        choosing = false
        if gp == "petra" then
            nextscene = "assets/video/episode3/petra/choices/12/i_guess_so.lua"
        elseif gp == "gabriel" then
            nextscene = "assets/video/episode3/gabriel/choices/12/i_guess_so.lua"
        end
    elseif buttons.pressed(buttons.circle) then
Image.unload(square)
Image.unload(circle)
        choosing = false
        if gp == "petra" then
            nextscene = "assets/video/episode3/petra/choices/12/not_really.lua"
        elseif gp == "gabriel" then
            nextscene = "assets/video/episode3/gabriel/choices/12/not_really.lua"
        end
    elseif buttons.pressed(buttons.start) then
Image.unload(square)
Image.unload(circle)
        choosing = false
dofile("assets/misc/pause.lua")
    elseif buttons.pressed(buttons.r) then
choosing = false
        SaveGame(3)
end
end