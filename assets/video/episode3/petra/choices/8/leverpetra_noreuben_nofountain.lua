local choosing = true
local circle = Image.load("assets/icons/circle.png")

PMP.setVolume(pmpvolume)
PMP.playEasy('assets/video/episode3/petra/choices/8/leverpetra.pmp', buttons.r, true, 'assets/video/episode3/petra/choices/8/leverpetra.srt', font, subssize, "#FFFFFF", "#000000/150", subs)
Image.draw(circle, 305, 135)
intraFont.print(305 - intraFont.textW(font, "Lever (Reuben)", 0.4) / 2 + 8, 135 + 14, "Lever (Reuben)", Color.new(255,255,255), font, 0.4)
intraFont.print(345 - 5 - intraFont.textW(font, "Press R to save", 0.63), 230, "Press R to save", Color.new(255,255,255, 150), font, 0.63)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()

while choosing do
    buttons.read()
    if buttons.pressed(buttons.circle) then
        Image.unload(circle)
        choosing = false
        nextscene =  "assets/video/episode3/petra/choices/8/leverreuben_noleverpetra_nofountain.lua"
    elseif buttons.pressed(buttons.start) then
        Image.unload(circle)
        choosing = false
dofile("assets/misc/pause.lua")
choosing = false
        SaveGame(3)
    end
end