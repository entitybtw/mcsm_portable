local choosing = true
local square = Image.load("assets/icons/square.png")
local circle = Image.load("assets/icons/circle.png")

PMP.setVolume(pmpvolume)
PMP.playEasy('assets/video/episode3/no_gp/10/exit.pmp', buttons.r, true, 'assets/video/episode3/no_gp/10/exit.srt', font, subssize, "#FFFFFF", "#000000/150", subs)

Image.draw(square, 62, 203)
intraFont.print(62 - intraFont.textW(font, "Olivia", 0.4) / 2 + 8, 203 + 14, "Olivia", Color.new(255,255,255), font, 0.4)
Image.draw(circle, 155, 171)
intraFont.print(155 - intraFont.textW(font, "Chest", 0.4) / 2 + 8, 171 + 14, "Chest", Color.new(255,255,255), font, 0.4)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()

while choosing do
    buttons.read()

    if buttons.pressed(buttons.square) then
        Image.unload(square)
        Image.unload(circle)
        choosing = false
        nextscene =  "assets/video/episode3/no_gp/10/olivia_noexit1.lua"
    elseif buttons.pressed(buttons.circle) then
        Image.unload(square)
        Image.unload(circle)
        choosing = false
        nextscene =  "assets/video/episode3/no_gp/10/chest.lua"
    elseif buttons.pressed(buttons.l) then
        Image.unload(square)
        Image.unload(circle)
        choosing = false
        nextscene =  "./mainmenu.lua"
    elseif buttons.pressed(buttons.r) then
        Image.unload(square)
        Image.unload(circle)
        choosing = false
        SaveGame(3)
        nextscene =  "./mainmenu.lua"
    end

end


