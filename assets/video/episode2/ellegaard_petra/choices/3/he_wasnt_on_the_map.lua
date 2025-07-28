local choosing = true
local square = Image.load("assets/icons/square.png")
local circle = Image.load("assets/icons/circle.png")

PMP.setVolume(pmpvolume)
PMP.playEasy('assets/video/episode2/ellegaard_petra/choices/3/he_wasnt_on_the_map.pmp', buttons.r, true, 'assets/video/episode2/ellegaard_petra/choices/3/he_wasnt_on_the_map.srt', font, subssize, "#FFFFFF", "#000000/150", subs)

Image.draw(square, 25, 127)
Image.draw(circle, 455, 127)
intraFont.print(25 + 15 + 5, 127, "He can be a jerk", Color.new(255,255,255), font, 0.4)
intraFont.print(455 - 5 - intraFont.textW(font, "He's awesome", 0.4), 127, "He's awesome", Color.new(255,255,255), font, 0.4)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()

while choosing do
    buttons.read()

    if buttons.pressed(buttons.square) then
Image.unload(square)
Image.unload(circle)
        choosing = false
        nextscene =  "assets/video/episode2/ellegaard_petra/choices/4/he_can_be_a_jerk.lua"
    elseif buttons.pressed(buttons.circle) then
Image.unload(square)
Image.unload(circle)
        choosing = false
        nextscene =  "assets/video/episode2/ellegaard_petra/choices/4/hes_awesome.lua"
    elseif buttons.pressed(buttons.l) then
Image.unload(square)
Image.unload(circle)
        choosing = false
        nextscene =  "./mainmenu.lua"
    elseif buttons.pressed(buttons.r) then
Image.unload(square)
Image.unload(circle)
        choosing = false
        SaveGame(2)
        nextscene =  "./mainmenu.lua"
    end

end
