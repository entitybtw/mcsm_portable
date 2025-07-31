local choosing = true
local square = Image.load("assets/icons/square.png")
local circle = Image.load("assets/icons/circle.png")
local cross = Image.load("assets/icons/cross.png")

PMP.setVolume(pmpvolume)
local result = PMP.playEasy('assets/video/episode2/ellegaard/choices/2/schoolboy.pmp', buttons.r, true, 'assets/video/episode2/ellegaard/choices/2/schoolboy.srt', font, subssize, "#FFFFFF", "#000000/150", subs)
if result == 1 then
    nextscene = "./mainmenu.lua"
    return 1
end
Image.draw(cross, 125, 216)
intraFont.print(125 - intraFont.textW(font, "Autofarm", 0.4) / 2 + 8, 216 + 14, "Autofarm", Color.new(255,255,255), font, 0.4)
Image.draw(square, 160, 173)
intraFont.print(160 - intraFont.textW(font, "Chest", 0.4) / 2 + 8, 173 + 14, "Chest", Color.new(255,255,255), font, 0.4)
Image.draw(circle, 404, 161)
intraFont.print(404 - intraFont.textW(font, "Steal Repeater", 0.4) / 2 + 8, 161 + 14, "Steal Repeater", Color.new(255,255,255), font, 0.4)
intraFont.print(345 - 5 - intraFont.textW(font, "Press R to save", 0.63), 230, "Press R to save", Color.new(255,255,255, 150), font, 0.63)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()

while choosing do
    buttons.read()
    if buttons.pressed(buttons.square) then
        Image.unload(square)
        Image.unload(circle)
        Image.unload(cross)
        choosing = false
        nextscene =  "assets/video/episode2/ellegaard/choices/2/chest_schoolboy.lua"
    elseif buttons.pressed(buttons.cross) then
        Image.unload(square)
        Image.unload(circle)
        Image.unload(cross)
        choosing = false
        nextscene =   "assets/video/episode2/ellegaard/choices/2/autofarm_schoolboy.lua"
    elseif buttons.pressed(buttons.circle) then
        Image.unload(square)
        Image.unload(circle)
        Image.unload(cross)
        choosing = false
        nextscene =  "assets/video/episode2/ellegaard/choices/2/steal_repeater.lua"
    elseif buttons.pressed(buttons.start) then
        Image.unload(square)
        Image.unload(circle)
        Image.unload(cross)
choosing = false
local pause = dofile("assets/misc/pause.lua")
if pause == -1 then nextscene = "./mainmenu.lua" end
    elseif buttons.pressed(buttons.r) then
        Image.unload(square)
choosing = false
        SaveGame(2)
end
end
