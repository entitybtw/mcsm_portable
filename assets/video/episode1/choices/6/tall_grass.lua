local choosing = true
reuben = "reuben"
local square = Image.load("assets/icons/square.png")
local circle = Image.load("assets/icons/circle.png")

PMP.setVolume(pmpvolume)
PMP.playEasy('assets/video/episode1/choices/6/tall_grass.pmp', buttons.r, true, 'assets/video/episode1/choices/6/tall_grass.srt', font, subssize, "#FFFFFF", "#000000/150", subs)

Image.draw(square, 25, 127)
Image.draw(circle, 455, 127)
intraFont.print(25 + 15 + 5, 127, "Run, I'll distract them!", Color.new(255,255,255), font, 0.4)
intraFont.print(455 - 5 - intraFont.textW(font, "Stay close, I'll protect you", 0.4), 127, "Stay close, I'll protect you", Color.new(255,255,255), font, 0.4)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()


while choosing do
    buttons.read()

    if buttons.pressed(buttons.square) then
Image.unload(square)
Image.unload(circle)
	choosing = false
    tall_grass = nil
	reuben = "noreuben"
        nextscene =  "assets/video/episode1/choices/7/run_i_distract_them.lua"
    elseif buttons.pressed(buttons.circle) then
Image.unload(square)
Image.unload(circle)
	choosing = false
	reuben = "reuben"
    tall_grass = nil
        nextscene =  "assets/video/episode1/choices/7/stay_close_i_protect_you.lua"
    elseif buttons.pressed(buttons.l) then
Image.unload(square)
Image.unload(circle)
        choosing = false
        nextscene =  "./mainmenu.lua"
    elseif buttons.pressed(buttons.r) then
Image.unload(square)
Image.unload(circle)
        choosing = false
        SaveGame(1)
        nextscene =  "./mainmenu.lua"
    end


end
