local choosing = true
local square = Image.load("assets/icons/square.png")
local circle = Image.load("assets/icons/circle.png")
local triangle = Image.load("assets/icons/triangle.png")
local cross = Image.load("assets/icons/cross.png")
local temple_script = nil
if pedestal == "off" then
    PMP.setVolume(pmpvolume)
local result =     PMP.playEasy('assets/video/episode1/choices/36/lukas.pmp', buttons.r, true, 'assets/video/episode1/choices/36/lukas.srt', font, subssize, "#FFFFFF", "#000000/150", subs)
if result == 1 then
    nextscene = "./mainmenu.lua"
    return 1
end
    Image.draw(cross, 243, 139)
    intraFont.print(243 - intraFont.textW(font, "Pedestal", 0.4) / 2 + 8, 139 + 14, "Pedestal", Color.new(255,255,255), font, 0.4)
    temple_script = "assets/video/episode1/choices/36/pedestal.lua"
elseif pedestal == "on" then
    PMP.setVolume(pmpvolume)
local result =     PMP.playEasy('assets/video/episode1/choices/36/lukas_pedestal.pmp', buttons.r, true, 'assets/video/episode1/choices/36/lukas_pedestal.srt', font, subssize, "#FFFFFF", "#000000/150", subs)
if result == 1 then
    nextscene = "./mainmenu.lua"
    return 1
end
    Image.draw(cross, 392, 183)
    intraFont.print(392 - intraFont.textW(font, "Levers", 0.4) / 2 + 8, 183 + 14, "Levers", Color.new(255,255,255), font, 0.4)
    temple_script = "assets/video/episode1/choices/36/levers.lua"
end

Image.draw(triangle, 305, 157)
intraFont.print(305 - intraFont.textW(font, "Olivia", 0.4) / 2 + 8, 157 + 14, "Olivia", Color.new(255,255,255), font, 0.4)
Image.draw(square, 123, 161)
intraFont.print(123 - intraFont.textW(font, "Axel", 0.4) / 2 + 8, 161 + 14, "Axel", Color.new(255,255,255), font, 0.4)
Image.draw(circle, 174, 153)
intraFont.print(174 - intraFont.textW(font, "Lukas", 0.4) / 2 + 8, 153 + 14, "Lukas", Color.new(255,255,255), font, 0.4)
intraFont.print(345 - 5 - intraFont.textW(font, "Press R to save", 0.63), 230, "Press R to save", Color.new(255,255,255, 150), font, 0.63)
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
        nextscene =  "assets/video/episode1/choices/36/lukas.lua"
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
        nextscene = temple_script
    elseif buttons.pressed(buttons.start) then
        Image.unload(square)
        Image.unload(circle)
        Image.unload(triangle)
        Image.unload(cross)
        choosing = false
dofile("assets/misc/pause.lua")
    elseif buttons.pressed(buttons.r) then
        Image.unload(square)
        Image.unload(circle)
choosing = false
        SaveGame(1)
    end

end