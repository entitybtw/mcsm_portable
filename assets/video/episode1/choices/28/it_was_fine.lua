local choosing = true
local square = Image.load("assets/icons/square.png")
local circle = Image.load("assets/icons/circle.png")
PMP.setVolume(pmpvolume)
local result = PMP.playEasy('assets/video/episode1/choices/28/it_was_fine.pmp', buttons.r, true, 'assets/video/episode1/choices/28/it_was_fine.srt', font, subssize, "#FFFFFF", "#000000/150", subs)
if result == 1 then
    nextscene = "./mainmenu.lua"
    return 1
end

Image.draw(square, 25, 127)
Image.draw(circle, 455, 127)
intraFont.print(45, 127, "I'll go first", Color.new(255,255,255), font, 0.4)
intraFont.print(450 - intraFont.textW(font, "You can do it", 0.4), 127, "You can do it", Color.new(255,255,255), font, 0.4)
intraFont.print(340 - intraFont.textW(font, "Press R to save", 0.63), 230, "Press R to save", Color.new(255,255,255, 150), font, 0.63)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()

while choosing do
    buttons.read()
    if buttons.pressed(buttons.square) then
Image.unload(square)
Image.unload(circle)
        choosing = false
        nextscene =  "assets/video/episode1/choices/29/i_go_first.lua"
    elseif buttons.pressed(buttons.circle) then
Image.unload(square)
Image.unload(circle)
        choosing = false
        nextscene =  "assets/video/episode1/choices/29/you_can_do_it.lua"
    elseif buttons.pressed(buttons.start) then
Image.unload(square)
Image.unload(circle)
choosing = false
local pause = dofile("assets/misc/pause.lua")
if pause == -1 then nextscene = "./mainmenu.lua" end
    elseif buttons.pressed(buttons.r) then
choosing = false
        SaveGame(1)

end
end
