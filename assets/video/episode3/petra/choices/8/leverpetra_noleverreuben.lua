local choosing = true
local circle = Image.load("assets/icons/circle.png")
local cross = Image.load("assets/icons/cross.png")

PMP.setVolume(pmpvolume)
PMP.playEasy('assets/video/episode3/petra/choices/8/leverpetra.pmp', buttons.r, true, 'assets/video/episode3/petra/choices/8/leverpetra.srt', font, subssize, "#FFFFFF", "#000000/150", subs)

Image.draw(cross, 166, 131)
intraFont.print(166 - intraFont.textW(font, "Fountain", 0.4) / 2 + 8, 131 + 14, "Fountain", Color.new(255,255,255), font, 0.4)
Image.draw(circle, 126, 169)
intraFont.print(126 - intraFont.textW(font, "Lukas", 0.4) / 2 + 8, 169 + 14, "Lukas", Color.new(255,255,255), font, 0.4)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()

while choosing do
    buttons.read()

    if buttons.pressed(buttons.circle) then
        Image.unload(circle)
        Image.unload(cross)
        choosing = false
        nextscene =  "assets/video/episode3/petra/choices/8/lukas.lua"
    elseif buttons.pressed(buttons.cross) then
        Image.unload(circle)
        Image.unload(cross)
        choosing = false
        nextscene =  "assets/video/episode3/petra/choices/8/fountain_noleverpetra_noleverreuben.lua"
    elseif buttons.pressed(buttons.l) then
        Image.unload(circle)
        Image.unload(cross)
        choosing = false
        nextscene =  "./mainmenu.lua"
    elseif buttons.pressed(buttons.r) then
        Image.unload(circle)
        Image.unload(cross)
        choosing = false
        SaveGame(3)
        nextscene =  "./mainmenu.lua"
    end

end

