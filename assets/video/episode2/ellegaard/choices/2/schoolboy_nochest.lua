local choosing = true
local cross = Image.load("assets/icons/cross.png")
local circle = Image.load("assets/icons/circle.png")
PMP.setVolume(pmpvolume)
local result = PMP.playEasy('assets/video/episode2/ellegaard/choices/2/schoolboy.pmp', buttons.r, true, 'assets/video/episode2/ellegaard/choices/2/schoolboy.srt', font, subssize, "#FFFFFF", "#000000/150", subs)
if result == 1 then
    nextscene = "./mainmenu.lua"
    return 1
end

Image.draw(cross, 125, 216)
intraFont.print(125 - intraFont.textW(font, "Autofarm", 0.4) / 2 + 8, 216 + 14, "Autofarm", Color.new(255,255,255), font, 0.4)
Image.draw(circle, 404, 161)
intraFont.print(404 - intraFont.textW(font, "Steal Repeater", 0.4) / 2 + 8, 161 + 14, "Steal Repeater", Color.new(255,255,255), font, 0.4)
intraFont.print(345 - 5 - intraFont.textW(font, "Press R to save", 0.63), 230, "Press R to save", Color.new(255,255,255, 150), font, 0.63)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()
while choosing do
    buttons.read()

    if buttons.pressed(buttons.cross) then
        Image.unload(cross)
        Image.unload(circle)
        choosing = false
        nextscene =   "assets/video/episode2/ellegaard/choices/2/autofarm_schoolboy_nochest.lua"
    elseif buttons.pressed(buttons.circle) then
        Image.unload(cross)
        Image.unload(circle)
        choosing = false
        nextscene =  "assets/video/episode2/ellegaard/choices/2/steal_repeater.lua"
    elseif buttons.pressed(buttons.start) then
        Image.unload(cross)
        Image.unload(circle)
choosing = false
local pause = dofile("assets/misc/pause.lua")
if pause == -1 then nextscene = "./mainmenu.lua" end
    elseif buttons.pressed(buttons.r) then
choosing = false
        SaveGame(2)
    end
end
