local choosing = true
local square = Image.load("assets/icons/square.png")
local circle = Image.load("assets/icons/circle.png")
PMP.setVolume(pmpvolume)
PMP.playEasy('assets/video/episode1/choices/11/party_time_' .. reuben .. '.pmp', buttons.r)

Image.draw(square, 25, 127)
Image.draw(circle, 455, 127)
intraFont.print(25 + 15 + 5, 127, "I'm jesse", Color.new(255,255,255), font, 0.4)
intraFont.print(455 - 5 - intraFont.textW(font, "Who are you?", 0.4), 127, "Who are you?", Color.new(255,255,255), font, 0.4)
intraFont.print(345 - 5 - intraFont.textW(font, "Press R to save", 0.63), 230, "Press R to save", Color.new(255,255,255, 150), font, 0.63)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()

while choosing do
    buttons.read()
    if buttons.pressed(buttons.square) then
Image.unload(square)
Image.unload(circle)
        choosing = false
        nextscene = "assets/video/episode1/choices/12/im_jesse.lua"
    elseif buttons.pressed(buttons.circle) then
Image.unload(square)
Image.unload(circle)
        choosing = false
        nextscene = "assets/video/episode1/choices/12/who_are_you.lua"
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
