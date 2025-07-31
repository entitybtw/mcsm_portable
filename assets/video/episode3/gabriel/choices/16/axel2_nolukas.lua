local choosing = true
local square = Image.load("assets/icons/square.png")
local triangle = Image.load("assets/icons/triangle.png")
PMP.setVolume(pmpvolume)
local result = PMP.playEasy('assets/video/episode3/gabriel/choices/16/axel_button.pmp', buttons.r, true, 'assets/video/episode3/gabriel/choices/16/axel_button.srt', font, subssize, "#FFFFFF", "#000000/150", subs)
if result == 1 then
    nextscene = "./mainmenu.lua"
    return 1
end

Image.draw(triangle, 171, 132)
intraFont.print(171 - intraFont.textW(font, "Olivia", 0.4) / 2 + 8, 132 + 14, "Olivia", Color.new(255,255,255), font, 0.4)
Image.draw(square, 321, 131)
intraFont.print(321 - intraFont.textW(font, "Chest", 0.4) / 2 + 8, 131 + 14, "Chest", Color.new(255,255,255), font, 0.4)
intraFont.print(345 - 5 - intraFont.textW(font, "Press R to save", 0.63), 230, "Press R to save", Color.new(255,255,255, 150), font, 0.63)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()
while choosing do
    buttons.read()

    if buttons.pressed(buttons.square) then
        Image.unload(square)
        Image.unload(triangle)
        choosing = false
        nextscene =  "assets/video/episode3/gabriel/choices/16/chest.lua"
    elseif buttons.pressed(buttons.triangle) then
        Image.unload(square)
        Image.unload(triangle)
        choosing = false
        nextscene =  "assets/video/episode3/gabriel/choices/16/olivia2_noaxel_nolukas.lua"
    elseif buttons.pressed(buttons.start) then
        Image.unload(square)
        Image.unload(triangle)
        choosing = false
dofile("assets/misc/pause.lua")
    elseif buttons.pressed(buttons.r) then
choosing = false
        SaveGame(3)
    end

end

