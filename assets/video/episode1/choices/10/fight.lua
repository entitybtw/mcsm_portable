local choosing = true
PMP.setVolume(pmpvolume)
local result = PMP.playEasy('assets/video/episode1/choices/10/fight_' .. building .. '_' .. reuben .. '.pmp', buttons.r)
if result == 1 then
    nextscene = "./mainmenu.lua"
    return 1
end

Image.draw(square, 25, 127)
Image.draw(circle, 455, 127)
intraFont.print(45, 127, "Party Time!", Color.new(255,255,255), font, 0.4)
intraFont.print(450 - intraFont.textW(font, "Proud of you", 0.4), 127, "Proud of you", Color.new(255,255,255), font, 0.4)
intraFont.print(340 - intraFont.textW(font, "Press R to save", 0.63), 230, "Press R to save", Color.new(255,255,255, 150), font, 0.63)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()

while choosing do
    buttons.read()
    if buttons.pressed(buttons.square) then
        choosing = false
        nextscene =  "assets/video/episode1/choices/11/party_time.lua"
    elseif buttons.pressed(buttons.circle) then
        choosing = false
        nextscene =  "assets/video/episode1/choices/11/proud_of_you.lua"
    elseif buttons.pressed(buttons.start) then
choosing = false
local pause = dofile("assets/misc/pause.lua")
if pause == -1 then nextscene = "./mainmenu.lua" end
    elseif buttons.pressed(buttons.r) then
choosing = false
        SaveGame(1)

end
end
