local choosing = true
local square = Image.load("assets/icons/square.png")
local circle = Image.load("assets/icons/circle.png")

PMP.setVolume(pmpvolume)
PMP.playEasy('assets/video/episode4/ellegaard_petra/choices/8/we_must_be_close.pmp', buttons.r, true, 'assets/video/episode4/ellegaard_petra/choices/8/we_must_be_close.srt', font, subssize, "#FFFFFF", "#000000/150", subs)

Image.draw(square, 25, 127)
Image.draw(circle, 455, 127)
intraFont.print(25 + 15 + 5, 127, "Let's head back", Color.new(255,255,255), font, 0.4)
intraFont.print(455 - 5 - intraFont.textW(font, "We need that cake", 0.4), 127, "We need that cake", Color.new(255,255,255), font, 0.4)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()

while choosing do
    buttons.read()

    if buttons.pressed(buttons.square) then
        Image.unload(square)
        Image.unload(circle)
        choosing = false
        nextscene = "assets/video/episode4/ellegaard_petra/choices/9/lets_head_back.lua"
    elseif buttons.pressed(buttons.circle) then
        Image.unload(square)
        Image.unload(circle)
        choosing = false
        nextscene = "assets/video/episode4/ellegaard_petra/choices/9/we_need_that_cake.lua"
    elseif buttons.pressed(buttons.l) then
        Image.unload(square)
        Image.unload(circle)
        choosing = false
        nextscene = "./mainmenu.lua"
    elseif buttons.pressed(buttons.start) then
        Image.unload(square)
        Image.unload(circle)
        choosing = false
        SaveGame(3)
        nextscene = "./mainmenu.lua"
    end
end
