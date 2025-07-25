local choosing = true
local square = Image.load("assets/icons/square.png")
local circle = Image.load("assets/icons/circle.png")

PMP.setVolume(pmpvolume)
PMP.playEasy('assets/video/episode2/ellegaard/choices/2/autofarm.pmp', buttons.r, true, 'assets/video/episode2/ellegaard/choices/2/autofarm.srt', font, subssize, "#FFFFFF", "#000000/150", subs)

Image.draw(circle, 383, 197)
intraFont.print(383 - intraFont.textW(font, "School Boy", 0.4) / 2 + 8, 197 + 14, "School Boy", Color.new(255,255,255), font, 0.4)
Image.draw(square, 160, 173)
intraFont.print(160 - intraFont.textW(font, "Chest", 0.4) / 2 + 8, 173 + 14, "Chest", Color.new(255,255,255), font, 0.4)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()

while choosing do
    buttons.read()

    if buttons.pressed(buttons.square) then
        Image.unload(square)
        Image.unload(circle)
        choosing = false
        nextscene =  "assets/video/episode2/ellegaard/choices/2/chest_intellectual_noautofarm.lua"
    elseif buttons.pressed(buttons.circle) then
        Image.unload(square)
        Image.unload(circle)
        choosing = false
        nextscene =  "assets/video/episode2/ellegaard/choices/2/schoolboy_noautofarm.lua"
    elseif buttons.pressed(buttons.l) then
        Image.unload(square)
        Image.unload(circle)
        choosing = false
        nextscene =  "./mainmenu.lua"
    elseif buttons.pressed(buttons.start) then
        Image.unload(square)
        Image.unload(circle)
        choosing = false
        SaveGame(2)
        nextscene =  "./mainmenu.lua"
    end

end
