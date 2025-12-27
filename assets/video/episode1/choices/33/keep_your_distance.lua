local choosing = true
PMP.setVolume(pmpvolume)
local result = PMP.playEasy('assets/video/episode1/choices/33/keep_your_distance.pmp', buttons.r, true, 'assets/video/episode1/choices/33/keep_your_distance.srt', font, subssize, "#FFFFFF", "#000000/150", subs)
if result == 1 then
    nextscene = "./mainmenu.lua"
    return 1
end

Image.draw(square, 25, 127)
Image.draw(circle, 455, 127)
intraFont.print(45, 127, "Craft a bow!", Color.new(255,255,255), font, 0.4)
intraFont.print(450 - intraFont.textW(font, "Craft a fishing pole!", 0.4), 127, "Craft a fishing pole!", Color.new(255,255,255), font, 0.4)
intraFont.print(340 - intraFont.textW(font, "Press R to save", 0.63), 230, "Press R to save", Color.new(255,255,255, 150), font, 0.63)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()

while choosing do
    buttons.read()
    if buttons.pressed(buttons.square) then
	wr("bf", "bow")
        choosing = false
        nextscene =  "assets/video/episode1/choices/34/craft_a_bow.lua"
    elseif buttons.pressed(buttons.circle) then
	wr("bf", "fishing_pole")
        choosing = false
        nextscene =  "assets/video/episode1/choices/34/craft_a_fishing_pole.lua"
    elseif buttons.pressed(buttons.start) then
choosing = false
local pause = dofile("assets/misc/pause.lua")
if pause == -1 then nextscene = "./mainmenu.lua" end
    elseif buttons.pressed(buttons.r) then
choosing = false
        SaveGame(1)

end
end
