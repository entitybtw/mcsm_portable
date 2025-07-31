local choosing = true
local square = Image.load("assets/icons/square.png")
local circle = Image.load("assets/icons/circle.png")
PMP.setVolume(pmpvolume)
PMP.playEasy('assets/video/episode4/magnus_petra/choices/16/gabriel/youll_be_fine.pmp', buttons.r, true, 'assets/video/episode4/magnus_petra/choices/16/gabriel/youll_be_fine.srt', font, subssize, "#FFFFFF", "#000000/150", subs)

Image.draw(square, 393, 146)
intraFont.print(393 - intraFont.textW(font, "Lever", 0.4) / 2 + 8, 146 + 14, "Lever", Color.new(255,255,255), font, 0.4)
Image.draw(circle, 126, 169)
intraFont.print(126 - intraFont.textW(font, "Bookcase", 0.4) / 2 + 8, 169 + 14, "Bookcase", Color.new(255,255,255), font, 0.4)
intraFont.print(345 - 5 - intraFont.textW(font, "Press R to save", 0.63), 230, "Press R to save", Color.new(255,255,255, 150), font, 0.63)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()
while choosing do
    buttons.read()

    if buttons.pressed(buttons.square) then
        Image.unload(square)
        Image.unload(circle)
        
        choosing = false
        nextscene =  "assets/video/episode4/magnus_petra/choices/16/lever.lua"
    elseif buttons.pressed(buttons.circle) then
        Image.unload(square)
        Image.unload(circle)
        
        choosing = false
        nextscene =  "assets/video/episode4/magnus_petra/choices/16/bookcase.lua"
    elseif buttons.pressed(buttons.start) then
        Image.unload(square)
        Image.unload(circle)
        
        choosing = false
dofile("assets/misc/pause.lua")
    elseif buttons.pressed(buttons.r) then
        Image.unload(square)
choosing = false
        SaveGame(2)
    end

end
