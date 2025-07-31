local choosing = true
slime = "off"
sword = ""
local square = Image.load("assets/icons/square.png")
local circle = Image.load("assets/icons/circle.png")
PMP.setVolume(pmpvolume)
PMP.playEasy('assets/video/episode1/choices/15/offer_sword_' .. reuben .. '.pmp', buttons.r)

Image.draw(square, 221, 122)
intraFont.print(221 - intraFont.textW(font, "Chicken Machine", 0.4) / 2 + 8, 122 + 14, "Chicken Machine", Color.new(255,255,255), font, 0.4)
Image.draw(circle, 141, 139)
intraFont.print(141 - intraFont.textW(font, "Slime", 0.4) / 2 + 8, 139 + 14, "Slime", Color.new(255,255,255), font, 0.4)
intraFont.print(345 - 5 - intraFont.textW(font, "Press R to save", 0.63), 230, "Press R to save", Color.new(255,255,255, 150), font, 0.63)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()

while choosing do
    buttons.read()
    if buttons.pressed(buttons.square) then
        Image.unload(square)
        Image.unload(circle)
        choosing = false
        nextscene =  "assets/video/episode1/choices/16/chicken_machine.lua"
    elseif buttons.pressed(buttons.circle) then
        Image.unload(square)
        Image.unload(circle)
        choosing = false
        nextscene =  "assets/video/episode1/choices/16/slime.lua"
    elseif buttons.pressed(buttons.start) then
        Image.unload(square)
        Image.unload(circle)
        choosing = false
dofile("assets/misc/pause.lua")
    elseif buttons.pressed(buttons.r) then
choosing = false
        SaveGame(1)

end
end
