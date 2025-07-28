local choosing = true
local square = Image.load("assets/icons/square.png")
local circle = Image.load("assets/icons/circle.png")

PMP.setVolume(pmpvolume)
PMP.playEasy('assets/video/episode2/ellegaard/choices/2/autofarm.pmp', buttons.r, true, 'assets/video/episode2/ellegaard/choices/2/autofarm.srt', font, subssize, "#FFFFFF", "#000000/150", subs)

Image.draw(square, 241, 210)
intraFont.print(241 - intraFont.textW(font, "Crafting Table", 0.4) / 2 + 8, 210 + 14, "Crafting Table", Color.new(255,255,255), font, 0.4)
Image.draw(circle, 344, 167)
intraFont.print(344 - intraFont.textW(font, "Intellectual", 0.4) / 2 + 8, 167 + 14, "Intellectual", Color.new(255,255,255), font, 0.4)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()

while choosing do
    buttons.read()

    if buttons.pressed(buttons.square) then
        Image.unload(square)
        Image.unload(circle)
        choosing = false
        nextscene =  "assets/video/episode2/ellegaard/choices/2/crafting_table.lua"
    elseif buttons.pressed(buttons.circle) then
        Image.unload(square)
        Image.unload(circle)
        choosing = false
        nextscene =  "assets/video/episode2/ellegaard/choices/2/intellectual_nochestnoautofarm.lua"
    elseif buttons.pressed(buttons.l) then
        Image.unload(square)
        Image.unload(circle)
        choosing = false
        nextscene =  "./mainmenu.lua"
    elseif buttons.pressed(buttons.r) then
        Image.unload(square)
        Image.unload(circle)
        choosing = false
        SaveGame(2)
        nextscene =  "./mainmenu.lua"
    end

end
