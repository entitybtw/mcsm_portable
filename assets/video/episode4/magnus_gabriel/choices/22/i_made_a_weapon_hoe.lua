local choosing = true
local square = Image.load("assets/icons/square.png")
local circle = Image.load("assets/icons/circle.png")

PMP.setVolume(pmpvolume)
PMP.playEasy('assets/video/episode4/magnus_gabriel/choices/22/i_made_a_weapon_hoe.pmp', buttons.r, true, 'assets/video/episode4/magnus_gabriel/choices/22/i_made_a_weapon_hoe.srt', font, subssize, "#FFFFFF", "#000000/150", subs)

Image.draw(square, 25, 127)
Image.draw(circle, 455, 127)
intraFont.print(25 + 15 + 5, 127, "Come back!", Color.new(255,255,255), font, 0.4)
intraFont.print(455 - 5 - intraFont.textW(font, "You coward!", 0.4), 127, "You coward!", Color.new(255,255,255), font, 0.4)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()

while choosing do
    buttons.read()

    if buttons.pressed(buttons.square) then
        Image.unload(square)
        Image.unload(circle)
        choosing = false
        nextscene = "assets/video/episode4/magnus_gabriel/choices/23/come_back_hoe.lua"
    elseif buttons.pressed(buttons.circle) then
        Image.unload(square)
        Image.unload(circle)
        choosing = false
        nextscene = "assets/video/episode4/magnus_gabriel/choices/23/you_coward_hoe.lua"
    elseif buttons.pressed(buttons.l) then
        Image.unload(square)
        Image.unload(circle)
        choosing = false
        nextscene = "./mainmenu.lua"
    elseif buttons.pressed(buttons.r) then
        Image.unload(square)
        Image.unload(circle)
        choosing = false
        SaveGame(3)
        nextscene = "./mainmenu.lua"
    end
end
