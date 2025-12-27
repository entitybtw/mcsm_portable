local choosing = true

PMP.setVolume(pmpvolume)
local result = PMP.playEasy('assets/video/episode3/gabriel/choices/16/button.pmp', buttons.r, true, 'assets/video/episode3/gabriel/choices/16/button.srt', font, subssize, "#FFFFFF", "#000000/150", subs)
if result == 1 then
    nextscene = "./mainmenu.lua"
    return 1
end
Image.draw(square, 321, 131)
intraFont.print(321 - intraFont.textW(font, "Chest", 0.4) / 2 + 8, 131 + 14, "Chest", Color.new(255,255,255), font, 0.4)
intraFont.print(340 - intraFont.textW(font, "Press R to save", 0.63), 230, "Press R to save", Color.new(255,255,255, 150), font, 0.63)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()

while choosing do
    buttons.read()
    if buttons.pressed(buttons.square) then
        Image.unload(chest)
        choosing = false
        nextscene =  "assets/video/episode3/gabriel/choices/16/chest.lua"
    elseif buttons.pressed(buttons.start) then
        Image.unload(chest)
choosing = false
local pause = dofile("assets/misc/pause.lua")
if pause == -1 then nextscene = "./mainmenu.lua" end
choosing = false
        SaveGame(3)
    end
end
