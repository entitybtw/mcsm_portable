local choosing = true
local square = Image.load("assets/icons/square.png")
local cross = Image.load("assets/icons/cross.png")
local triangle = Image.load("assets/icons/triangle.png")

PMP.setVolume(pmpvolume)
PMP.playEasy('assets/video/episode3/petra/choices/16/axel.pmp', buttons.r, true, 'assets/video/episode3/petra/choices/16/axel.srt', font, subssize, "#FFFFFF", "#000000/150", subs)

Image.draw(square, 224, 64)
intraFont.print(224 - intraFont.textW(font, "Button", 0.4) / 2 + 8, 64 + 14, "Button", Color.new(255,255,255), font, 0.4)
Image.draw(cross, 277, 80)
intraFont.print(277 - intraFont.textW(font, "Lukas", 0.4) / 2 + 8, 80 + 14, "Lukas", Color.new(255,255,255), font, 0.4)
Image.draw(triangle, 171, 132)
intraFont.print(171 - intraFont.textW(font, "Olivia", 0.4) / 2 + 8, 132 + 14, "Olivia", Color.new(255,255,255), font, 0.4)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()

while choosing do
    buttons.read()

    if buttons.pressed(buttons.square) then
        Image.unload(square)
        Image.unload(cross)
        Image.unload(triangle)
        choosing = false
        nextscene =  "assets/video/episode3/petra/choices/16/button_noaxel.lua"
    elseif buttons.pressed(buttons.cross) then
        Image.unload(square)
        Image.unload(cross)
        Image.unload(triangle)
        choosing = false
        nextscene =  "assets/video/episode3/petra/choices/16/lukas_noaxel.lua"
    elseif buttons.pressed(buttons.triangle) then
        Image.unload(square)
        Image.unload(cross)
        Image.unload(triangle)
        choosing = false
        nextscene =  "assets/video/episode3/petra/choices/16/olivia_noaxel.lua"
    elseif buttons.pressed(buttons.l) then
        Image.unload(square)
        Image.unload(cross)
        Image.unload(triangle)
        choosing = false
        nextscene =  "./mainmenu.lua"
    elseif buttons.pressed(buttons.r) then
        Image.unload(square)
        Image.unload(cross)
        Image.unload(triangle)
        choosing = false
        SaveGame(3)
        nextscene =  "./mainmenu.lua"
    end

end

