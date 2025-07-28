local choosing = true
local square = Image.load("assets/icons/square.png")
local circle = Image.load("assets/icons/circle.png")

PMP.setVolume(pmpvolume)
PMP.playEasy('assets/video/episode1/choices/30/treehouse/keep_cookie.pmp', buttons.r, true, 'assets/video/episode1/choices/30/treehouse/keep_cookie.srt', font, subssize, "#FFFFFF", "#000000/150", subs)

Image.draw(square, 25, 127)
Image.draw(circle, 455, 127)
intraFont.print(25 + 15 + 5, 127, "Stay here", Color.new(255,255,255), font, 0.4)
intraFont.print(455 - 5 - intraFont.textW(font, "You should go", 0.4), 127, "You should go", Color.new(255,255,255), font, 0.4)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()


while choosing do
    buttons.read()

    if buttons.pressed(buttons.square) then
Image.unload(square)
Image.unload(circle)
        choosing = false
        nextscene =  "assets/video/episode1/choices/30/treehouse/31/stay_here.lua"
    elseif buttons.pressed(buttons.circle) then
Image.unload(square)
Image.unload(circle)
        choosing = false
        nextscene =  "assets/video/episode1/choices/30/treehouse/31/you_should_go.lua"
    elseif buttons.pressed(buttons.l) then
Image.unload(square)
Image.unload(circle)
        choosing = false
        nextscene =  "./mainmenu.lua"
    elseif buttons.pressed(buttons.r) then
Image.unload(square)
Image.unload(circle)
        choosing = false
        SaveGame(1)
        nextscene =  "./mainmenu.lua"
    end


end
