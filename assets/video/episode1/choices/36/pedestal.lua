local choosing = true
pedestal = "on"
local square = Image.load("assets/icons/square.png")
local circle = Image.load("assets/icons/circle.png")
local triangle = Image.load("assets/icons/triangle.png")
local cross = Image.load("assets/icons/cross.png")

PMP.setVolume(pmpvolume)
PMP.playEasy('assets/video/episode1/choices/36/axel_pedestal.pmp', buttons.r, true, 'assets/video/episode1/choices/36/axel_pedestal.srt', font, subssize, "#FFFFFF", "#000000/150", subs)
    
Image.draw(cross, 392, 183)
intraFont.print(392 - intraFont.textW(font, "Levers", 0.4) / 2 + 8, 183 + 14, "Levers", Color.new(255,255,255), font, 0.4)

Image.draw(triangle, 305, 157)
intraFont.print(305 - intraFont.textW(font, "Olivia", 0.4) / 2 + 8, 157 + 14, "Olivia", Color.new(255,255,255), font, 0.4)
Image.draw(square, 123, 161)
intraFont.print(123 - intraFont.textW(font, "Axel", 0.4) / 2 + 8, 161 + 14, "Axel", Color.new(255,255,255), font, 0.4)
Image.draw(circle, 174, 153)
intraFont.print(174 - intraFont.textW(font, "Lukas", 0.4) / 2 + 8, 153 + 14, "Lukas", Color.new(255,255,255), font, 0.4)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()


while choosing do
    buttons.read()

    if buttons.pressed(buttons.square) then
        Image.unload(square)
        Image.unload(circle)
        Image.unload(triangle)
        Image.unload(cross)
        choosing = false
        nextscene =  "assets/video/episode1/choices/36/axel.lua"
    elseif buttons.pressed(buttons.circle) then
        Image.unload(square)
        Image.unload(circle)
        Image.unload(triangle)
        Image.unload(cross)
        choosing = false
        nextscene =  "assets/video/episode1/choices/36/lukas.lua"
    elseif buttons.pressed(buttons.triangle) then
        Image.unload(square)
        Image.unload(circle)
        Image.unload(triangle)
        Image.unload(cross)
        choosing = false
        nextscene =  "assets/video/episode1/choices/36/olivia.lua"
    elseif buttons.pressed(buttons.cross) then
        Image.unload(square)
        Image.unload(circle)
        Image.unload(triangle)
        Image.unload(cross)
        choosing = false
        nextscene = "assets/video/episode1/choices/36/levers.lua"
    elseif buttons.pressed(buttons.l) then
        Image.unload(square)
        Image.unload(circle)
        Image.unload(triangle)
        Image.unload(cross)
        choosing = false
        nextscene =  "./mainmenu.lua"
    elseif buttons.pressed(buttons.start) then
        Image.unload(square)
        Image.unload(circle)
        Image.unload(triangle)
        Image.unload(cross)
        choosing = false
        SaveGame(1)
        nextscene =  "./mainmenu.lua"
    end


end
