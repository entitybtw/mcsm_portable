local choosing = true
local square = Image.load("assets/icons/square.png")
local circle = Image.load("assets/icons/circle.png")

PMP.setVolume(pmpvolume)
PMP.playEasy('assets/video/episode2/magnus/choices/6/then_id_be_stuck_here.pmp', buttons.r, true, 'assets/video/episode2/magnus/choices/6/then_id_be_stuck_here.srt', font, subssize, "#FFFFFF", "#000000/150", subs)

Image.draw(square, 25, 127)
Image.draw(circle, 455, 127)
intraFont.print(25 + 15 + 5, 127, "Stone", Color.new(255,255,255), font, 0.4)
intraFont.print(455 - 5 - intraFont.textW(font, "Pink wool", 0.4), 127, "Pink wool", Color.new(255,255,255), font, 0.4)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()

while choosing do
    buttons.read()

    if buttons.pressed(buttons.square) then
Image.unload(square)
Image.unload(circle)
        choosing = false
        nextscene =  "assets/video/episode2/magnus/choices/7/stone.lua"
    elseif buttons.pressed(buttons.circle) then
Image.unload(square)
Image.unload(circle)
        choosing = false
        nextscene =  "assets/video/episode2/magnus/choices/7/pink_wool.lua"
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
