-- base made by dntrnk --

local in_interactive_zone = true
local choosing = true

local c_white = Color.new(255, 255, 255)

local bg_1 = Image.load("assets/video/episode5/choices/14/sky_city_exploration_1.png")
local bg_2 = Image.load("assets/video/episode5/choices/14/sky_city_exploration_2.png")
local bg_3 = Image.load("assets/video/episode5/choices/14/sky_city_exploration_3.png")

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

local sky_city_1_explored = false
local castle_guard_talk = false
local sky_city_2_explored = false
local townspeople_talk = false

while in_interactive_zone do
	screen.clear()

	if not sky_city_1_explored then
		Image.draw(bg_1, 0, 0)
	elseif sky_city_1_explored and not sky_city_2_explored then
		Image.draw(bg_2, 0, 0)
	elseif sky_city_2_explored and sky_city_1_explored then
		Image.draw(bg_3, 0, 0)
	end

	if not sky_city_1_explored then
		Image.draw(spritesheet, 140, 134, 15, 15, nil, 399, 0, 15, 15)
		intraFont.print(
			140 - intraFont.textW(font, choices_fourth.crafting_table, 0.4) / 2 + 8,
			134 + 14,
			choices_fourth.crafting_table,
			Color.new(255, 255, 255),
			font,
			0.4
		)
		Image.draw(spritesheet, 417, 145, 15, 15, nil, 430, 0, 15, 15)
		intraFont.print(
			417 - intraFont.textW(font, choices_fifth.garden, 0.4) / 2 + 8,
			145 + 14,
			choices_fifth.garden,
			Color.new(255, 255, 255),
			font,
			0.4
		)
	end

	if sky_city_1_explored and not sky_city_2_explored and not castle_guard_talk then
		Image.draw(spritesheet, 100, 70, 15, 15, nil, 399, 0, 15, 15)
		intraFont.print(
			100 - intraFont.textW(font, choices_fifth.castle_guard, 0.4) / 2 + 8,
			70 + 14,
			choices_fifth.castle_guard,
			Color.new(255, 255, 255),
			font,
			0.4
		)
	end
	if not sky_city_2_explored and sky_city_1_explored then
		Image.draw(spritesheet, 417, 60, 15, 15, nil, 430, 0, 15, 15)
		intraFont.print(
			417 - intraFont.textW(font, "Build site", 0.4) / 2 + 8,
			60 + 14,
			choices_fifth.build_site,
			Color.new(255, 255, 255),
			font,
			0.4
		)
	end

	if sky_city_2_explored and not townspeople_talk then
		Image.draw(spritesheet, 330, 140, 15, 15, nil, 430, 0, 15, 15)
		intraFont.print(
			330 - intraFont.textW(font, choices_fifth.townspeople, 0.4) / 2 + 8,
			140 + 14,
			choices_fifth.townspeople,
			Color.new(255, 255, 255),
			font,
			0.4
		)
	end

	if sky_city_2_explored then
		Image.draw(spritesheet, 115, 145, 15, 15, nil, 399, 0, 15, 15)
		intraFont.print(
			115 - intraFont.textW(font, choices_fifth.innkeeper, 0.4) / 2 + 8,
			145 + 14,
			choices_fifth.innkeeper,
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
			if not sky_city_1_explored then
				playCutscene(
					"assets/video/episode5/choices/14/crafting_table.pmp",
					"assets/subtitles/episode5/choices/14/crafting_table.srt"
				)
				sky_city_1_explored = true
				choosing = false
			elseif sky_city_1_explored and not sky_city_2_explored and not castle_guard_talk then
				playCutscene(
					"assets/video/episode5/choices/14/castle_guard.pmp",
					"assets/subtitles/episode5/choices/14/castle_guard.srt"
				)
				castle_guard_talk = true
				choosing = false
			elseif sky_city_2_explored then
				nextscene = "assets/video/episode5/choices/14/innkeeper.lua"
				in_interactive_zone = false
				choosing = false
			end
		elseif buttons.pressed(buttons.triangle) then
			if not sky_city_1_explored then
				playCutscene(
					"assets/video/episode5/choices/14/garden.pmp",
					"assets/subtitles/episode5/choices/14/garden.srt"
				)
				sky_city_1_explored = true
				choosing = false
			elseif sky_city_2_explored and not townspeople_talk then
				playCutscene(
					"assets/video/episode5/choices/14/townspeople.pmp",
					"assets/subtitles/episode5/choices/14/townspeople.srt"
				)
				townspeople_talk = true
				choosing = false
			elseif not sky_city_2_explored and sky_city_1_explored then
				playCutscene(
					"assets/video/episode5/choices/14/build_site.pmp",
					"assets/subtitles/episode5/choices/14/build_site.srt"
				)
				sky_city_2_explored = true
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

Image.unload(bg_1)
Image.unload(bg_2)
Image.unload(bg_3)
