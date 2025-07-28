local choosing = true
local square = Image.load("assets/icons/square.png")
local circle = Image.load("assets/icons/circle.png")

PMP.setVolume(pmpvolume)
PMP.playEasy('assets/video/episode1/choices/9/lever_' .. reuben .. '.pmp', buttons.r)

Image.draw(square, 25, 127)
Image.draw(circle, 455, 127)
intraFont.print(25 + 15 + 5, 127, "Fight!", Color.new(255,255,255), font, 0.4)
intraFont.print(455 - 5 - intraFont.textW(font, "Jump!", 0.4), 127, "Jump!", Color.new(255,255,255), font, 0.4)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()


while choosing do
    buttons.read()

    if buttons.pressed(buttons.square) then
Image.unload(square)
Image.unload(circle)
        choosing = false
        nextscene = "assets/video/episode1/choices/10/fight.lua"
    elseif buttons.pressed(buttons.circle) then
Image.unload(square)
Image.unload(circle)
        choosing = false
        nextscene = "assets/video/episode1/choices/10/jump.lua"
    elseif buttons.pressed(buttons.l) then
Image.unload(square)
Image.unload(circle)
        choosing = false
        nextscene = "./mainmenu.lua"
    elseif buttons.pressed(buttons.r) then
Image.unload(square)
Image.unload(circle)
        choosing = false
        SaveGame(1)
        nextscene = "./mainmenu.lua"
    end


end









