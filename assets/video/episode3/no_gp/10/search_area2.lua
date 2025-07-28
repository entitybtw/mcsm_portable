local choosing = true
local square = Image.load("assets/icons/square.png")
local cross = Image.load("assets/icons/cross.png")

PMP.setVolume(pmpvolume)
PMP.playEasy('assets/video/episode3/no_gp/10/search_area2.pmp', buttons.r, true, 'assets/video/episode3/no_gp/10/search_area2.srt', font, subssize, "#FFFFFF", "#000000/150", subs)

Image.draw(cross, 344, 31)
intraFont.print(344 - intraFont.textW(font, "Search upstairs", 0.4) / 2 + 8, 31 + 14, "Search upstairs", Color.new(255,255,255), font, 0.4)
Image.draw(square, 144, 170)
intraFont.print(144 - intraFont.textW(font, "Search Area 1", 0.4) / 2 + 8, 170 + 14, "Search Area 1", Color.new(255,255,255), font, 0.4)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()

while choosing do
    buttons.read()

    if buttons.pressed(buttons.square) then
        Image.unload(cross)
        Image.unload(square)
        choosing = false
        nextscene =  "assets/video/episode3/no_gp/10/search_area1.lua"
    elseif buttons.pressed(buttons.cross) then
        Image.unload(cross)
        Image.unload(square)
        choosing = false
        nextscene =  "assets/video/episode3/no_gp/10/search_upstairs.lua"
    elseif buttons.pressed(buttons.l) then
        Image.unload(cross)
        Image.unload(square)
        choosing = false
        nextscene =  "./mainmenu.lua"
    elseif buttons.pressed(buttons.r) then
        Image.unload(cross)
        Image.unload(square)
        choosing = false
        SaveGame(3)
        nextscene =  "./mainmenu.lua"
    end

end


