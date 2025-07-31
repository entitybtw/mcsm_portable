local choosing = true
local square = Image.load("assets/icons/square.png")
local triangle = Image.load("assets/icons/triangle.png")
local circle = Image.load("assets/icons/circle.png")

PMP.setVolume(pmpvolume)
local result = PMP.playEasy('assets/video/episode3/gabriel/choices/16/lukas.pmp', buttons.r, true, 'assets/video/episode3/gabriel/choices/16/lukas.srt', font, subssize, "#FFFFFF", "#000000/150", subs)
if result == 1 then
    nextscene = "./mainmenu.lua"
    return 1
end
Image.draw(square, 224, 64)
intraFont.print(224 - intraFont.textW(font, "Button", 0.4) / 2 + 8, 64 + 14, "Button", Color.new(255,255,255), font, 0.4)
Image.draw(circle, 341, 195)
intraFont.print(341 - intraFont.textW(font, "Axel", 0.4) / 2 + 8, 195 + 14, "Axel", Color.new(255,255,255), font, 0.4)
Image.draw(triangle, 171, 132)
intraFont.print(171 - intraFont.textW(font, "Olivia", 0.4) / 2 + 8, 132 + 14, "Olivia", Color.new(255,255,255), font, 0.4)
intraFont.print(345 - 5 - intraFont.textW(font, "Press R to save", 0.63), 230, "Press R to save", Color.new(255,255,255, 150), font, 0.63)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()

while choosing do
    buttons.read()
    if buttons.pressed(buttons.square) then
        Image.unload(square)
        Image.unload(circle)
        Image.unload(triangle)
        choosing = false
        nextscene =  "assets/video/episode3/gabriel/choices/16/button_nolukas.lua"
    elseif buttons.pressed(buttons.circle) then
        Image.unload(square)
        Image.unload(circle)
        Image.unload(triangle)
        choosing = false
        nextscene =  "assets/video/episode3/gabriel/choices/16/axel_nolukas.lua"
    elseif buttons.pressed(buttons.triangle) then
        Image.unload(square)
        Image.unload(circle)
        Image.unload(triangle)
        choosing = false
        nextscene =  "assets/video/episode3/gabriel/choices/16/olivia_nolukas.lua"
    elseif buttons.pressed(buttons.start) then
        Image.unload(square)
        Image.unload(circle)
        Image.unload(triangle)
choosing = false
local pause = dofile("assets/misc/pause.lua")
if pause == -1 then nextscene = "./mainmenu.lua" end
    elseif buttons.pressed(buttons.r) then
        Image.unload(square)
choosing = false
        SaveGame(3)
    end
end
