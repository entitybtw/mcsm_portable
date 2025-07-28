local choosing = true
local circle = Image.load("assets/icons/circle.png")

PMP.setVolume(pmpvolume)
PMP.playEasy('assets/video/episode3/petra/choices/8/fountain.pmp', buttons.r, true, 'assets/video/episode3/petra/choices/8/fountain.srt', font, subssize, "#FFFFFF", "#000000/150", subs)

Image.draw(circle, 305, 135)
intraFont.print(305 - intraFont.textW(font, "Reuben", 0.4) / 2 + 8, 135 + 14, "Reuben", Color.new(255,255,255), font, 0.4)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()

while choosing do
    buttons.read()

    if buttons.pressed(buttons.circle) then
        Image.unload(circle)
        choosing = false
        nextscene =  "assets/video/episode3/petra/choices/8/reuben_noleverpetra_nofountain.lua"
    elseif buttons.pressed(buttons.l) then
        Image.unload(circle)
        choosing = false
        nextscene =  "./mainmenu.lua"
    elseif buttons.pressed(buttons.r) then
        Image.unload(circle)
        choosing = false
        SaveGame(3)
        nextscene =  "./mainmenu.lua"
    end

end

