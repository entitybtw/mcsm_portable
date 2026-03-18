-- base made by dntrnk --

local in_interactive_zone = true
local choosing = true

local c_white = Color.new(255, 255, 255)

local bg = Image.load("assets/video/episode1/choices/36/the_temple_zone.png")
local bg_pedestal = Image.load("assets/video/episode1/choices/36/the_temple_zone_pedestal.png")

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

local lukas_talk = false
local axel_talk = false
local olivia_talk = false
local pedestal_used = false

while in_interactive_zone do
	screen.clear()

	if not pedestal_used then
		Image.draw(bg, 0, 0)
	elseif pedestal_used then
		Image.draw(bg_pedestal, 0, 0)
	end

	if not olivia_talk then
		Image.draw(spritesheet, 305, 157, 15, 15, nil, 430, 0, 15, 15)
		intraFont.print(
			305 - intraFont.textW(font, choices_one.olivia, 0.4) / 2 + 8,
			157 + 14,
			choices_one.olivia,
			Color.new(255, 255, 255),
			font,
			0.4
		)
	end
	if not axel_talk then
		Image.draw(spritesheet, 123, 161, 15, 15, nil, 414, 0, 15, 15)
		intraFont.print(
			123 - intraFont.textW(font, choices_one.axel, 0.4) / 2 + 8,
			161 + 14,
			choices_one.axel,
			Color.new(255, 255, 255),
			font,
			0.4
		)
	end
	if not lukas_talk then
		Image.draw(spritesheet, 174, 153, 15, 15, nil, 384, 0, 15, 15)
		intraFont.print(
			174 - intraFont.textW(font, choices_one.lukas, 0.4) / 2 + 8,
			153 + 14,
			choices_one.lukas,
			Color.new(255, 255, 255),
			font,
			0.4
		)
	end

	if not pedestal_used then
		Image.draw(spritesheet, 243, 139, 15, 15, nil, 399, 0, 15, 15)
		intraFont.print(
			243 - intraFont.textW(font, choices_one.pedestal, 0.4) / 2 + 8,
			139 + 14,
			choices_one.pedestal,
			Color.new(255, 255, 255),
			font,
			0.4
		)
	elseif pedestal_used then
		Image.draw(spritesheet, 392, 183, 15, 15, nil, 399, 0, 15, 15)
		intraFont.print(
			392 - intraFont.textW(font, choices_one.levers, 0.4) / 2 + 8,
			183 + 14,
			choices_one.levers,
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
			if not pedestal_used then
				playCutscene(
					"assets/video/episode1/choices/36/pedestal.pmp",
					"assets/subtitles/episode1/choices/36/pedestal.srt"
				)
				pedestal_used = true
				choosing = false
			elseif pedestal_used then
				nextscene = "assets/video/episode1/choices/36/levers.lua"
				in_interactive_zone = false
				choosing = false
			end
		elseif buttons.pressed(buttons.square) then
			if not axel_talk then
				if not pedestal_used then
					playCutscene(
						"assets/video/episode1/choices/36/axel.pmp",
						"assets/subtitles/episode1/choices/36/axel.srt"
					)
				elseif pedestal_used then
					playCutscene(
						"assets/video/episode1/choices/36/axel_pedestal.pmp",
						"assets/subtitles/episode1/choices/36/axel_pedestal.srt"
					)
				end
				axel_talk = true
				choosing = false
			end
		elseif buttons.pressed(buttons.circle) then
			if not lukas_talk then
				if not pedestal_used then
					playCutscene(
						"assets/video/episode1/choices/36/lukas.pmp",
						"assets/subtitles/episode1/choices/36/lukas.srt"
					)
				elseif pedestal_used then
					playCutscene(
						"assets/video/episode1/choices/36/lukas_pedestal.pmp",
						"assets/subtitles/episode1/choices/36/lukas_pedestal.srt"
					)
				end
				lukas_talk = true
				choosing = false
			end
		elseif buttons.pressed(buttons.triangle) then
			if not olivia_talk then
				if not pedestal_used then
					playCutscene(
						"assets/video/episode1/choices/36/olivia.pmp",
						"assets/subtitles/episode1/choices/36/olivia.srt"
					)
				elseif pedestal_used then
					playCutscene(
						"assets/video/episode1/choices/36/olivia_pedestal.pmp",
						"assets/subtitles/episode1/choices/36/olivia_pedestal.srt"
					)
				end
				olivia_talk = true
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
Image.unload(bg_pedestal)
