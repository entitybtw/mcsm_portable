local choosing = true
local square = Image.load("assets/icons/square.png")

PMP.setVolume(pmpvolume)
PMP.playEasy('assets/video/episode3/petra/choices/16/axel.pmp', buttons.r, true, 'assets/video/episode3/petra/choices/16/axel.srt', font, subssize, "#FFFFFF", "#000000/150", subs)
Image.draw(square, 321, 131)
intraFont.print(321 - intraFont.textW(font, "Chest", 0.4) / 2 + 8, 131 + 14, "Chest", Color.new(255,255,255), font, 0.4)
intraFont.print(345 - 5 - intraFont.textW(font, "Press R to save", 0.63), 230, "Press R to save", Color.new(255,255,255, 150), font, 0.63)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()

while choosing do
    buttons.read()
    if buttons.pressed(buttons.square) then
        Image.unload(square)
        choosing = false
        nextscene =  "assets/video/episode3/petra/choices/16/chest.lua"
    elseif buttons.pressed(buttons.start) then
        Image.unload(square)
        choosing = false
dofile("assets/misc/pause.lua")
choosing = false
        SaveGame(3)
    end
end