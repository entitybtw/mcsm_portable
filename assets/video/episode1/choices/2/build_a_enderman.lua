building = "enderman"
local choosing = true
PMP.setVolume(pmpvolume)
local result = PMP.playExt(
	"assets/video/episode1/choices/2/build_a_enderman.pmp",
	buttons.r,
	true,
	"assets/subtitles/episode1/choices/2/build_a_enderman.srt",
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
Image.draw(spritesheet, 140, 182, 15, 15, nil, 430, 0, 15, 15)
intraFont.print(45, 127, choices_one.dead_enders, Color.new(255, 255, 255), font, 0.4)
intraFont.print(
	450 - intraFont.textW(font, choices_one.nether_maniacs, 0.4),
	127,
	choices_one.nether_maniacs,
	Color.new(255, 255, 255),
	font,
	0.4
)
intraFont.print(140 + 15 + 5, 182, choices_one.order_of_the_pig, Color.new(255, 255, 255), font, 0.4)
intraFont.print(340 - intraFont.textW(font, ui.save, 0.63), 230, ui.save, Color.new(255, 255, 255, 150), font, 0.63)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()

while choosing do
	buttons.read()
	if buttons.pressed(buttons.square) then
		choosing = false
		nextscene = "assets/video/episode1/choices/3/dead_enders.lua"
	elseif buttons.pressed(buttons.circle) then
		choosing = false
		nextscene = "assets/video/episode1/choices/3/nether_maniacs.lua"
	elseif buttons.pressed(buttons.triangle) then
		choosing = false
		nextscene = "assets/video/episode1/choices/3/order_of_the_pig.lua"
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
