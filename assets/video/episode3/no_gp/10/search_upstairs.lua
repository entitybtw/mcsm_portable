local choosing = true
local square = Image.load("assets/icons/square.png")
local cross = Image.load("assets/icons/cross.png")
PMP.setVolume(pmpvolume)
local result = PMP.playEasy('assets/video/episode3/no_gp/10/search_upstairs.pmp', buttons.r, true, 'assets/video/episode3/no_gp/10/search_upstairs.srt', font, subssize, "#FFFFFF", "#000000/150", subs)
if result == 1 then
    nextscene = "./mainmenu.lua"
    return 1
end

Image.draw(square, 144, 170)
intraFont.print(144 - intraFont.textW(font, "Search Area 1", 0.4) / 2 + 8, 170 + 14, "Search Area 1", Color.new(255,255,255), font, 0.4)
Image.draw(cross, 310, 177)
intraFont.print(310 - intraFont.textW(font, "Search Area 2", 0.4) / 2 + 8, 177 + 14, "Search Area 2", Color.new(255,255,255), font, 0.4)
intraFont.print(345 - 5 - intraFont.textW(font, "Press R to save", 0.63), 230, "Press R to save", Color.new(255,255,255, 150), font, 0.63)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()
while choosing do
    buttons.read()

    if buttons.pressed(buttons.square) then
        Image.unload(cross)
        Image.unload(square)
        choosing = false
        nextscene =  "assets/video/episode3/no_gp/10/search_area1_noupstairs.lua"
    elseif buttons.pressed(buttons.cross) then
        Image.unload(cross)
        Image.unload(square)
        choosing = false
        nextscene =  "assets/video/episode3/no_gp/10/search_area2_noupstairs.lua"
    elseif buttons.pressed(buttons.start) then
        Image.unload(cross)
        Image.unload(square)
        choosing = false
dofile("assets/misc/pause.lua")
    elseif buttons.pressed(buttons.r) then
choosing = false
        SaveGame(3)
    end

end
