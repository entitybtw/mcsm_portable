local choosing = true
local cross = Image.load("assets/icons/cross.png")
local circle = Image.load("assets/icons/circle.png")

PMP.setVolume(pmpvolume)
PMP.playEasy('assets/video/episode2/ellegaard/choices/2/intellectual.pmp', buttons.r, true, 'assets/video/episode2/ellegaard/choices/2/intellectual.srt', font, subssize, "#FFFFFF", "#000000/150", subs)

Image.draw(cross, 125, 216)
intraFont.print(125 - intraFont.textW(font, "Autofarm", 0.4) / 2 + 8, 216 + 14, "Autofarm", Color.new(255,255,255), font, 0.4)
Image.draw(circle, 383, 197)
intraFont.print(383 - intraFont.textW(font, "School Boy", 0.4) / 2 + 8, 197 + 14, "School Boy", Color.new(255,255,255), font, 0.4)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()

while choosing do
    buttons.read()

    if buttons.pressed(buttons.cross) then
        Image.unload(cross)
        Image.unload(circle)
        choosing = false
        nextscene =  "assets/video/episode2/ellegaard/choices/2/autofarm_intellectual_nochest.lua"
    elseif buttons.pressed(buttons.circle) then
        Image.unload(cross)
        Image.unload(circle)
        choosing = false
        nextscene =  "assets/video/episode2/ellegaard/choices/2/schoolboy_nochest.lua"
    elseif buttons.pressed(buttons.l) then
        Image.unload(cross)
        Image.unload(circle)
        choosing = false
        nextscene =  "./mainmenu.lua"
    elseif buttons.pressed(buttons.start) then
        Image.unload(cross)
        Image.unload(circle)
        choosing = false
        SaveGame(2)
        nextscene =  "./mainmenu.lua"
    end

end
