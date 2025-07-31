local choosing = true
local circle = Image.load("assets/icons/circle.png")
local cross = Image.load("assets/icons/cross.png")
PMP.setVolume(pmpvolume)
PMP.playEasy('assets/video/episode3/gabriel/choices/8/leverreuben.pmp', buttons.r, true, 'assets/video/episode3/gabriel/choices/8/leverreuben.srt', font, subssize, "#FFFFFF", "#000000/150", subs)

Image.draw(circle, 126, 169)
intraFont.print(126 - intraFont.textW(font, "Lukas", 0.4) / 2 + 8, 169 + 14, "Lukas", Color.new(255,255,255), font, 0.4)
Image.draw(cross, 166, 131)
intraFont.print(166 - intraFont.textW(font, "Fountain", 0.4) / 2 + 8, 131 + 14, "Fountain", Color.new(255,255,255), font, 0.4)
intraFont.print(345 - 5 - intraFont.textW(font, "Press R to save", 0.63), 230, "Press R to save", Color.new(255,255,255, 150), font, 0.63)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()
while choosing do
    buttons.read()

    if buttons.pressed(buttons.circle) then
        Image.unload(circle)
        Image.unload(cross)
        choosing = false
        nextscene =  "assets/video/episode3/gabriel/choices/8/lukas.lua"
    elseif buttons.pressed(buttons.cross) then
        Image.unload(circle)
        Image.unload(cross)
        choosing = false
        nextscene =  "assets/video/episode3/gabriel/choices/8/fountain_nolevergabriel_noleverreuben.lua"
    elseif buttons.pressed(buttons.start) then
        Image.unload(circle)
        Image.unload(cross)
        choosing = false
dofile("assets/misc/pause.lua")
    elseif buttons.pressed(buttons.r) then
choosing = false
        SaveGame(3)
    end

end

