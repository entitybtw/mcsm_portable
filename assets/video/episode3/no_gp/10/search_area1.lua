local choosing = true
local circle = Image.load("assets/icons/circle.png")
local cross = Image.load("assets/icons/cross.png")
PMP.setVolume(pmpvolume)
local result = PMP.playEasy('assets/video/episode3/no_gp/10/search_area1.pmp', buttons.r, true, 'assets/video/episode3/no_gp/10/search_area1.srt', font, subssize, "#FFFFFF", "#000000/150", subs)
if result == 1 then
    nextscene = "./mainmenu.lua"
    return 1
end

Image.draw(cross, 344, 31)
intraFont.print(344 - intraFont.textW(font, "Search upstairs", 0.4) / 2 + 8, 31 + 14, "Search upstairs", Color.new(255,255,255), font, 0.4)
Image.draw(circle, 310, 177)
intraFont.print(310 - intraFont.textW(font, "Search Area 2", 0.4) / 2 + 8, 177 + 14, "Search Area 2", Color.new(255,255,255), font, 0.4)
intraFont.print(345 - 5 - intraFont.textW(font, "Press R to save", 0.63), 230, "Press R to save", Color.new(255,255,255, 150), font, 0.63)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()
while choosing do
    buttons.read()

    if buttons.pressed(buttons.circle) then
        Image.unload(cross)
        Image.unload(circle)
        choosing = false
        nextscene =  "assets/video/episode3/no_gp/10/search_area2.lua"
    elseif buttons.pressed(buttons.cross) then
        Image.unload(cross)
        Image.unload(circle)
        choosing = false
        nextscene =  "assets/video/episode3/no_gp/10/search_upstairs.lua"
    elseif buttons.pressed(buttons.start) then
        Image.unload(cross)
        Image.unload(circle)
choosing = false
local pause = dofile("assets/misc/pause.lua")
if pause == -1 then nextscene = "./mainmenu.lua" end
    elseif buttons.pressed(buttons.r) then
choosing = false
        SaveGame(3)
    end

end
