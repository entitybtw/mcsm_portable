local choosing = true
PMP.setVolume(pmpvolume)
local result = PMP.playExt(
	"assets/video/episode1/choices/28/yeah_its_awful.pmp",
	buttons.r,
	true,
	"assets/subtitles/episode1/choices/28/yeah_its_awful.srt",
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
intraFont.print(45, 127, "I'll go first", Color.new(255, 255, 255), font, 0.4)
intraFont.print(
	450 - intraFont.textW(font, choices_one.you_can_do_it, 0.4),
	127,
	choices_one.you_can_do_it,
	Color.new(255, 255, 255),
	font,
	0.4
)
intraFont.print(340 - intraFont.textW(font, ui.save, 0.63), 230, ui.save, Color.new(255, 255, 255, 150), font, 0.63)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()

while choosing do
	buttons.read()
	if buttons.pressed(buttons.square) then
		choosing = false
		nextscene = "assets/video/episode1/choices/29/i_go_first.lua"
	elseif buttons.pressed(buttons.circle) then
		choosing = false
		nextscene = "assets/video/episode1/choices/29/you_can_do_it.lua"
	elseif buttons.pressed(buttons.start) then
		choosing = false
		local pause = dofile("assets/misc/pause.lua")
		if pause == -1 then
			nextscene = "./mainmenu.lua"
		end
	elseif buttons.pressed(buttons.r) then
		choosing = false
		SaveGame(1)
	end
end
