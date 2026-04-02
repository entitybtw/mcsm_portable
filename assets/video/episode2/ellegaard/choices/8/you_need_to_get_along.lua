checkFile("assets/saves/gp.txt", "gp")
local choosing = true

PMP.setVolume(pmpvolume)
local result = PMP.playExt(
	"assets/video/episode2/ellegaard/choices/8/you_need_to_get_along.pmp",
	buttons.r,
	true,
	"assets/subtitles/episode2/ellegaard/choices/8/you_need_to_get_along.srt",
	font,
	subssize,
	"#FFFFFF",
	"#000000/150",
	subs
)
if result == 1 then
	nextscene = "./mainmenu.lua"
	return 1
end
Image.draw(spritesheet, 25, 127, 15, 15, nil, 414, 0, 15, 15)
Image.draw(spritesheet, 455, 127, 15, 15, nil, 384, 0, 15, 15)
intraFont.print(45, 127, choices_second.stay_out_of_it_axel, Color.new(255, 255, 255), font, 0.4)
intraFont.print(
	450 - intraFont.textW(font, choices_second.ellegaard_calm_down, 0.4),
	127,
	choices_second.ellegaard_calm_down,
	Color.new(255, 255, 255),
	font,
	0.4
)
intraFont.print(240 - intraFont.textW(font, ui.save, 0.63) / 2, 230, ui.save, Color.new(255, 255, 255, 150), font, 0.63)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()

while choosing do
	buttons.read()
	if buttons.pressed(buttons.square) then
		choosing = false
		if gp == "petra" then
			nextscene = "assets/video/episode2/ellegaard_petra/choices/2/stay_out_of_it_axel.lua"
		elseif gp == "gabriel" then
			nextscene = "assets/video/episode2/ellegaard_gabriel/2/stay_out_of_it_axel.lua"
		end
	elseif buttons.pressed(buttons.circle) then
		choosing = false
		if gp == "petra" then
			nextscene = "assets/video/episode2/ellegaard_petra/choices/2/ellegaard_calm_down.lua"
		elseif gp == "gabriel" then
			nextscene = "assets/video/episode2/ellegaard_gabriel/2/ellegaard_calm_down.lua"
		end
	elseif buttons.pressed(buttons.start) then
		choosing = false
		local pause = dofile("assets/misc/pause.lua")
		if pause == -1 then
			nextscene = "./mainmenu.lua"
		end
	elseif buttons.pressed(buttons.r) then
		choosing = false
		SaveGame(2)
	end
end
