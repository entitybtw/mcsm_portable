-- base made by dntrnk --

local in_interactive_zone = true
local choosing = true

local c_white = Color.new(255, 255, 255)

local bg = Image.load("assets/video/episode3/no_gp/10/the_lab.png")

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

local exit1_used = false
local olivia_talk = false
local chest_used = false
local area_1_search = false
local upstairs_search = false
local area_2_search = false

while in_interactive_zone do
	screen.clear()

	Image.draw(bg, 0, 0)

	if not exit1_used and not chest_used or area_1_search and area_2_search and upstairs_search then
		Image.draw(spritesheet, 445, 179, 15, 15, nil, 399, 0, 15, 15)
		intraFont.print(
			445 - intraFont.textW(font, choices_three.exit, 0.4) / 2 + 8,
			179 + 14,
			choices_three.exit,
			Color.new(255, 255, 255),
			font,
			0.4
		)
	elseif chest_used and not upstairs_search then
		Image.draw(spritesheet, 344, 31, 15, 15, nil, 399, 0, 15, 15)
		intraFont.print(
			344 - intraFont.textW(font, choices_third.search_upstairs, 0.4) / 2 + 8,
			31 + 14,
			choices_third.search_upstairs,
			Color.new(255, 255, 255),
			font,
			0.4
		)
	end

	if not area_1_search and chest_used then
		Image.draw(spritesheet, 144, 170, 15, 15, nil, 414, 0, 15, 15)
		intraFont.print(
			144 - intraFont.textW(font, choices_three.search_area1, 0.4) / 2 + 8,
			170 + 14,
			choices_three.search_area1,
			Color.new(255, 255, 255),
			font,
			0.4
		)
	elseif not olivia_talk then
		Image.draw(spritesheet, 62, 203, 15, 15, nil, 414, 0, 15, 15)
		intraFont.print(
			62 - intraFont.textW(font, choices_three.olivia, 0.4) / 2 + 8,
			203 + 14,
			choices_three.olivia,
			Color.new(255, 255, 255),
			font,
			0.4
		)
	end

	if not area_2_search and chest_used then
		Image.draw(spritesheet, 310, 177, 15, 15, nil, 384, 0, 15, 15)
		intraFont.print(
			310 - intraFont.textW(font, choices_three.search_area2, 0.4) / 2 + 8,
			177 + 14,
			choices_three.search_area2,
			Color.new(255, 255, 255),
			font,
			0.4
		)
	elseif not chest_used then
		Image.draw(spritesheet, 155, 171, 15, 15, nil, 384, 0, 15, 15)
		intraFont.print(
			155 - intraFont.textW(font, choices_three.chest, 0.4) / 2 + 8,
			171 + 14,
			choices_three.chest,
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
			if not exit1_used and not chest_used then
				playCutscene("assets/video/episode3/no_gp/10/exit.pmp", "assets/subtitles/episode3/no_gp/10/exit.srt")
				exit1_used = true
				choosing = false
			elseif area_1_search and area_2_search and upstairs_search then
				nextscene = "assets/video/episode3/no_gp/10/exit2.lua"
				in_interactive_zone = false
				choosing = false
			elseif not upstairs_search and chest_used then
				playCutscene(
					"assets/video/episode3/no_gp/10/search_upstairs.pmp",
					"assets/subtitles/episode3/no_gp/10/search_upstairs.srt"
				)
				upstairs_search = true
				choosing = false
			end
		elseif buttons.pressed(buttons.square) then
			if not area_1_search and chest_used then
				playCutscene(
					"assets/video/episode3/no_gp/10/search_area1.pmp",
					"assets/subtitles/episode3/no_gp/10/search_area1.srt"
				)
				area_1_search = true
				choosing = false
			elseif not olivia_talk then
				playCutscene(
					"assets/video/episode3/no_gp/10/olivia.pmp",
					"assets/subtitles/episode3/no_gp/10/olivia.srt"
				)
				olivia_talk = true
				choosing = false
			end
		elseif buttons.pressed(buttons.circle) then
			if not area_2_search and chest_used then
				playCutscene(
					"assets/video/episode3/no_gp/10/search_area2.pmp",
					"assets/subtitles/episode3/no_gp/10/search_area2.srt"
				)
				area_2_search = true
				choosing = false
			elseif not chest_used then
				playCutscene("assets/video/episode3/no_gp/10/chest.pmp", "assets/subtitles/episode3/no_gp/10/chest.srt")
				chest_used = true
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
