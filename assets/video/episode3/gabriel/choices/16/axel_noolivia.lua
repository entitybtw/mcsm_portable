local choosing = true
local square = Image.load("assets/icons/square.png")
local cross = Image.load("assets/icons/cross.png")
PMP.setVolume(pmpvolume)
PMP.playEasy('assets/video/episode3/gabriel/choices/16/axel_button.pmp', buttons.r, true, 'assets/video/episode3/gabriel/choices/16/axel_button.srt', font, subssize, "#FFFFFF", "#000000/150", subs)

Image.draw(cross, 277, 80)
intraFont.print(277 - intraFont.textW(font, "Lukas", 0.4) / 2 + 8, 80 + 14, "Lukas", Color.new(255,255,255), font, 0.4)
Image.draw(square, 224, 64)
intraFont.print(224 - intraFont.textW(font, "Button", 0.4) / 2 + 8, 64 + 14, "Button", Color.new(255,255,255), font, 0.4)
intraFont.print(345 - 5 - intraFont.textW(font, "Press R to save", 0.63), 230, "Press R to save", Color.new(255,255,255, 150), font, 0.63)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()
while choosing do
    buttons.read()

    if buttons.pressed(buttons.cross) then
        Image.unload(cross)
        Image.unload(square)
        choosing = false
        nextscene =  "assets/video/episode3/gabriel/choices/16/lukas_noaxel_noolivia.lua"
    elseif buttons.pressed(buttons.square) then
        Image.unload(cross)
        Image.unload(square)
        choosing = false
        nextscene =  "assets/video/episode3/gabriel/choices/16/button_noaxel_noolivia.lua"
    elseif buttons.pressed(buttons.start) then
        Image.unload(cross)
        Image.unload(square)
        choosing = false
dofile("assets/misc/pause.lua")
    elseif buttons.pressed(buttons.r) then
choosing = false
        SaveGame(3)
    end

end

