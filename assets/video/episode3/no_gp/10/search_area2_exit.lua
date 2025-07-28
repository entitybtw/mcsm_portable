local choosing = true
local cross = Image.load("assets/icons/cross.png")

PMP.setVolume(pmpvolume)
PMP.playEasy('assets/video/episode3/no_gp/10/search_area2.pmp', buttons.r, true, 'assets/video/episode3/no_gp/10/search_area2.srt', font, subssize, "#FFFFFF", "#000000/150", subs)

Image.draw(cross, 445, 179)
intraFont.print(445 - intraFont.textW(font, "Exit", 0.4) / 2 + 8, 179 + 14, "Exit", Color.new(255,255,255), font, 0.4)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()

while choosing do
    buttons.read()

    if buttons.pressed(buttons.cross) then
        Image.unload(cross)
        choosing = false
        nextscene =  "assets/video/episode3/no_gp/10/exit2.lua"
    elseif buttons.pressed(buttons.l) then
        Image.unload(cross)
        choosing = false
        nextscene =  "./mainmenu.lua"
    elseif buttons.pressed(buttons.r) then
        Image.unload(cross)
        choosing = false
        SaveGame(3)
        nextscene =  "./mainmenu.lua"
    end

end


