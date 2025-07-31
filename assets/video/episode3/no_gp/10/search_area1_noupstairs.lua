local choosing = true
local circle = Image.load("assets/icons/circle.png")

PMP.setVolume(pmpvolume)
local result = PMP.playEasy('assets/video/episode3/no_gp/10/search_area1.pmp', buttons.r, true, 'assets/video/episode3/no_gp/10/search_area1.srt', font, subssize, "#FFFFFF", "#000000/150", subs)
if result == 1 then
    nextscene = "./mainmenu.lua"
    return 1
end
Image.draw(circle, 310, 177)
intraFont.print(310 - intraFont.textW(font, "Search Area 2", 0.4) / 2 + 8, 177 + 14, "Search Area 2", Color.new(255,255,255), font, 0.4)
intraFont.print(345 - 5 - intraFont.textW(font, "Press R to save", 0.63), 230, "Press R to save", Color.new(255,255,255, 150), font, 0.63)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()

while choosing do
    buttons.read()
    if buttons.pressed(buttons.circle) then
        Image.unload(circle)
        choosing = false
        nextscene =  "assets/video/episode3/no_gp/10/search_area2_exit.lua"
    elseif buttons.pressed(buttons.start) then
        Image.unload(circle)
        choosing = false
dofile("assets/misc/pause.lua")
choosing = false
        SaveGame(3)
end
end