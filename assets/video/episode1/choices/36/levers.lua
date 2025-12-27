local choosing = true
local square = Image.load("assets/icons/square.png")
local circle = Image.load("assets/icons/circle.png")
PMP.setVolume(pmpvolume)
local result = PMP.playEasy('assets/video/episode1/choices/36/levers.pmp', buttons.r, true, 'assets/video/episode1/choices/36/levers.srt', font, subssize, "#FFFFFF", "#000000/150", subs)
if result == 1 then
    nextscene = "./mainmenu.lua"
    return 1
end

Image.draw(square, 25, 127)
Image.draw(circle, 455, 127)
intraFont.print(45, 127, "Go for Magnus!", Color.new(255,255,255), font, 0.4)
intraFont.print(450 - intraFont.textW(font, "Go for Ellegaard!", 0.4), 127, "Go for Ellegaard!", Color.new(255,255,255), font, 0.4)
intraFont.print(340 - intraFont.textW(font, "Press R to save", 0.63), 230, "Press R to save", Color.new(255,255,255, 150), font, 0.63)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()

while choosing do
    buttons.read()
    if buttons.pressed(buttons.square) then
        Image.unload(square)
        Image.unload(circle)
	wr("em", "magnus")
    pedestal = nil
    temple_script = nil
        choosing = false
        nextscene =  "assets/video/episode1/choices/37/go_for_magnus.lua"
    elseif buttons.pressed(buttons.circle) then
        Image.unload(square)
        Image.unload(circle)
	wr("em", "ellegaard")
    pedestal = nil
    temple_script = nil
        choosing = false
        nextscene =  "assets/video/episode1/choices/37/go_for_ellegaard.lua"
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
