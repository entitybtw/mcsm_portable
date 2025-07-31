local choosing = true
local square = Image.load("assets/icons/square.png")
local circle = Image.load("assets/icons/circle.png")
local cross = Image.load("assets/icons/cross.png")

PMP.setVolume(pmpvolume)
local result = PMP.playEasy('assets/video/episode3/no_gp/9/fine/dont_give_up.pmp', buttons.r, true, 'assets/video/episode3/no_gp/9/fine/dont_give_up.srt', font, subssize, "#FFFFFF", "#000000/150", subs)
if result == 1 then
    nextscene = "./mainmenu.lua"
    return 1
end
Image.draw(cross, 445, 179)
intraFont.print(445 - intraFont.textW(font, "Exit", 0.4) / 2 + 8, 179 + 14, "Exit", Color.new(255,255,255), font, 0.4)
Image.draw(square, 62, 203)
intraFont.print(62 - intraFont.textW(font, "Olivia", 0.4) / 2 + 8, 203 + 14, "Olivia", Color.new(255,255,255), font, 0.4)
Image.draw(circle, 155, 171)
intraFont.print(155 - intraFont.textW(font, "Chest", 0.4) / 2 + 8, 171 + 14, "Chest", Color.new(255,255,255), font, 0.4)
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
        nextscene =  "assets/video/episode3/no_gp/10/olivia.lua"
    elseif buttons.pressed(buttons.circle) then
        Image.unload(square)
        Image.unload(circle)
        Image.unload(cross)
        choosing = false
        nextscene =  "assets/video/episode3/no_gp/10/chest.lua"
    elseif buttons.pressed(buttons.cross) then
        Image.unload(square)
        Image.unload(circle)
        Image.unload(cross)
        choosing = false
        nextscene =  "assets/video/episode3/no_gp/10/exit1.lua"
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
        SaveGame(3)
    end
end
