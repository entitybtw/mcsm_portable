local choosing = true
local square = Image.load("assets/icons/square.png")

PMP.setVolume(pmpvolume)
PMP.playEasy('assets/video/episode3/petra/choices/16/button.pmp', buttons.r, true, 'assets/video/episode3/petra/choices/16/button.srt', font, subssize, "#FFFFFF", "#000000/150", subs)

Image.draw(square, 321, 131)
intraFont.print(321 - intraFont.textW(font, "Chest", 0.4) / 2 + 8, 131 + 14, "Chest", Color.new(255,255,255), font, 0.4)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()

while choosing do
    buttons.read()

    if buttons.pressed(buttons.square) then
        Image.unload(chest)
        choosing = false
        nextscene =  "assets/video/episode3/petra/choices/16/chest.lua"
    elseif buttons.pressed(buttons.l) then
        Image.unload(chest)
        choosing = false
        nextscene =  "./mainmenu.lua"
    elseif buttons.pressed(buttons.start) then
        Image.unload(chest)
        choosing = false
        SaveGame(3)
        nextscene =  "./mainmenu.lua"
    end

end

