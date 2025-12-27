local choosing = true
reuben = "reuben"

PMP.setVolume(pmpvolume)
local result = PMP.playEasy('assets/video/episode1/choices/6/tall_grass.pmp', buttons.r, true, 'assets/video/episode1/choices/6/tall_grass.srt', font, subssize, "#FFFFFF", "#000000/150", subs)
if result == 1 then
    nextscene = "./mainmenu.lua"
    return 1
end
Image.draw(square, 25, 127)
Image.draw(circle, 455, 127)
intraFont.print(45, 127, "Run, I'll distract them!", Color.new(255,255,255), font, 0.4)
intraFont.print(450 - intraFont.textW(font, "Stay close, I'll protect you", 0.4), 127, "Stay close, I'll protect you", Color.new(255,255,255), font, 0.4)
intraFont.print(340 - intraFont.textW(font, "Press R to save", 0.63), 230, "Press R to save", Color.new(255,255,255, 150), font, 0.63)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()

while choosing do
    buttons.read()

    if buttons.pressed(buttons.square) then
	choosing = false
    tall_grass = nil
	reuben = "noreuben"
        nextscene =  "assets/video/episode1/choices/7/run_i_distract_them.lua"
    elseif buttons.pressed(buttons.circle) then
	choosing = false
	reuben = "reuben"
    tall_grass = nil
        nextscene =  "assets/video/episode1/choices/7/stay_close_i_protect_you.lua"
    elseif buttons.pressed(buttons.start) then
choosing = false
local pause = dofile("assets/misc/pause.lua")
if pause == -1 then nextscene = "./mainmenu.lua" end
    elseif buttons.pressed(buttons.r) then
choosing = false
        SaveGame(1)
    end

end
