-- base made by dntrnk --

local in_interactive_zone = true
local choosing = true

local c_white = Color.new(255, 255, 255)

local bg = Image.load("assets/video/episode3/petra/choices/8/woolland.png")
local bg_leverpetra = Image.load("assets/video/episode3/petra/choices/8/woolland_leverpetra.png")

local function playCutscene(videoPath, subtitlesPath)
	PMP.setVolume(pmpvolume)
	local result =
		PMP.playExt(videoPath, buttons.r, true, subtitlesPath, font, subssize, "#FFFFFF", "#000000/150", subs)
	if result == 1 then
		choosing = false
		in_interactive_zone = false
		nextscene = "./mainmenu.lua"
	end
end

local fountain_used = false
local petra_talk = false
local reuben_talk = false
local leverreuben_used = false
local leverpetra_used = false

while in_interactive_zone do
	screen.clear()

	if not leverpetra_used then
		Image.draw(bg, 0, 0)
	elseif leverpetra_used then
		Image.draw(bg_leverpetra, 0, 0)
	end

	if not fountain_used then
		Image.draw(spritesheet, 166, 131, 15, 15, nil, 399, 0, 15, 15)
		intraFont.print(
			166 - intraFont.textW(font, choices_three.fountain, 0.4) / 2 + 8,
			131 + 14,
			choices_three.fountain,
			Color.new(255, 255, 255),
			font,
			0.4
		)
	end
	if not petra_talk then
		Image.draw(spritesheet, 394, 224, 15, 15, nil, 414, 0, 15, 15)
		intraFont.print(
			394 - intraFont.textW(font, choices_three.petra, 0.4) / 2 + 8,
			224 + 14,
			choices_three.petra,
			Color.new(255, 255, 255),
			font,
			0.4
		)
	elseif petra_talk and not leverpetra_used then
		Image.draw(spritesheet, 394, 224, 15, 15, nil, 414, 0, 15, 15)
		intraFont.print(
			394 - intraFont.textW(font, "Lever (Petra)", 0.4) / 2 + 8,
			224 + 14,
			"Lever (Petra)",
			Color.new(255, 255, 255),
			font,
			0.4
		)
	end
	if not reuben_talk then
		Image.draw(spritesheet, 305, 135, 15, 15, nil, 384, 0, 15, 15)
		intraFont.print(
			305 - intraFont.textW(font, choices_three.reuben, 0.4) / 2 + 8,
			135 + 14,
			choices_three.reuben,
			Color.new(255, 255, 255),
			font,
			0.4
		)
	elseif reuben_talk and not leverreuben_used then
		Image.draw(spritesheet, 305, 135, 15, 15, nil, 384, 0, 15, 15)
		intraFont.print(
			305 - intraFont.textW(font, "Lever (Reuben)", 0.4) / 2 + 8,
			135 + 14,
			"Lever (Reuben)",
			Color.new(255, 255, 255),
			font,
			0.4
		)
	end

	if leverpetra_used and leverreuben_used then
		Image.draw(spritesheet, 126, 169, 15, 15, nil, 384, 0, 15, 15)
		intraFont.print(
			126 - intraFont.textW(font, choices_three.lukas, 0.4) / 2 + 8,
			169 + 14,
			choices_three.lukas,
			Color.new(255, 255, 255),
			font,
			0.4
		)
	end

	intraFont.print(340 - intraFont.textW(font, ui.save, 0.63), 230, ui.save, Color.new(255, 255, 255, 150), font, 0.63)
	debugoverlay.draw(debugoverlay.loadSettings())

	screen.flip()

	choosing = true

	while choosing do
		buttons.read()

		if buttons.pressed(buttons.cross) then
			if not fountain_used then
				playCutscene(
					"assets/video/episode3/petra/choices/8/fountain.pmp",
					"assets/subtitles/episode3/petra/choices/8/fountain.srt"
				)
				fountain_used = true
				choosing = false
			end
		elseif buttons.pressed(buttons.square) then
			if not petra_talk then
				playCutscene(
					"assets/video/episode3/petra/choices/8/petra.pmp",
					"assets/subtitles/episode3/petra/choices/8/petra.srt"
				)
				petra_talk = true
				choosing = false
			elseif petra_talk and not leverpetra_used then
				playCutscene(
					"assets/video/episode3/petra/choices/8/leverpetra.pmp",
					"assets/subtitles/episode3/petra/choices/8/leverpetra.srt"
				)
				leverpetra_used = true
				choosing = false
			end
		elseif buttons.pressed(buttons.circle) then
			if not reuben_talk then
				playCutscene(
					"assets/video/episode3/petra/choices/8/reuben.pmp",
					"assets/subtitles/episode3/petra/choices/8/reuben.srt"
				)
				reuben_talk = true
				choosing = false
			elseif reuben_talk and not leverreuben_used then
				playCutscene(
					"assets/video/episode3/petra/choices/8/leverreuben.pmp",
					"assets/subtitles/episode3/petra/choices/8/leverreuben.srt"
				)
				leverreuben_used = true
				choosing = false
			elseif leverreuben_used and leverpetra_used then
				nextscene = "assets/video/episode3/petra/choices/8/lukas.lua"
				in_interactive_zone = false
				choosing = false
			end
		elseif buttons.pressed(buttons.start) then
			local pause = dofile("assets/misc/pause.lua")
			choosing = false
			if pause == -1 then
				nextscene = "./mainmenu.lua"
				in_interactive_zone = false
			end
		elseif buttons.pressed(buttons.r) then
			choosing = false
			SaveGame(5)
		end
	end
end

Image.unload(bg)
Image.unload(bg_leverpetra)
