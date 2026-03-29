-- made by dntrnk --
-- p.s dntrnk реально молодец (от entitybtw) --

local in_interactive_zone = true
local choosing = true

local c_white = Color.new(255, 255, 255)

local bg = Image.load("assets/video/episode5/choices/no_mi/1/throne_room_bg.png")

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

local bookcase_used = false
local cobblestone_collected = false
local dry_bush_collected = false
local strange_wall_used = false
local crafting_table_used = false

while in_interactive_zone do
	screen.clear()

	Image.draw(bg, 0, 0)

	if not bookcase_used then
		Image.draw(spritesheet, 59, 160, 15, 15, nil, 414, 0, 15, 15)
		intraFont.print(
			59 - intraFont.textW(font, choices_fifth.bookcase, 0.4) / 2 + 8,
			160 + 14,
			choices_fifth.bookcase,
			c_white,
			font,
			0.4
		)
	end

	Image.draw(spritesheet, 397, 166, 15, 15, nil, 384, 0, 15, 15)
	if not strange_wall_used then
		if mi == "milo" then
			intraFont.print(
				397 - intraFont.textW(font, choices_fifth.strange_wall, 0.4) / 2 + 8,
				166 + 14,
				choices_fifth.strange_wall,
				c_white,
				font,
				0.4
			)
		elseif mi == "ivor" then
			intraFont.print(
				397 - intraFont.textW(font, choices_fifth.supply_door, 0.4) / 2 + 8,
				166 + 14,
				choices_fifth.supply_door,
				c_white,
				font,
				0.4
			)
		end
	else
		intraFont.print(
			397 - intraFont.textW(font, choices_fifth.lever_slot, 0.4) / 2 + 8,
			166 + 14,
			choices_fifth.lever_slot,
			c_white,
			font,
			0.4
		)
	end

	if not cobblestone_collected then
		Image.draw(spritesheet, 144, 203, 15, 15, nil, 430, 0, 15, 15)
		intraFont.print(
			144 - intraFont.textW(font, choices_fifth.cobblestone, 0.4) / 2 + 8,
			203 + 14,
			choices_fifth.cobblestone,
			c_white,
			font,
			0.4
		)
	end

	if not dry_bush_collected then
		Image.draw(spritesheet, 282, 207, 15, 15, nil, 399, 0, 15, 15)
		intraFont.print(
			282 - intraFont.textW(font, choices_fifth.dry_bush, 0.4) / 2 + 8,
			207 + 14,
			choices_fifth.dry_bush,
			c_white,
			font,
			0.4
		)
	elseif cobblestone_collected and not crafting_table_used then
		Image.draw(spritesheet, 282, 207, 15, 15, nil, 399, 0, 15, 15)
		intraFont.print(
			282 - intraFont.textW(font, choices_fourth.crafting_table, 0.4) / 2 + 8,
			207 + 14,
			choices_fourth.crafting_table,
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

		if buttons.pressed(buttons.square) then
			if not bookcase_used then
				playCutscene(
					"assets/video/episode5/choices/no_mi/1/bookcase.pmp",
					"assets/subtitles/episode5/choices/no_mi/1/bookcase.srt"
				)
				bookcase_used = true
				choosing = false
			end
		elseif buttons.pressed(buttons.circle) then
			if not strange_wall_used then
				if mi == "milo" then
					playCutscene(
						"assets/video/episode5/choices/no_mi/1/strange_wall.pmp",
						"assets/subtitles/episode5/choices/no_mi/1/strange_wall.srt"
					)
				elseif mi == "ivor" then
					playCutscene(
						"assets/video/episode5/choices/no_mi/1/supply_door.pmp",
						"assets/subtitles/episode5/choices/no_mi/1/supply_door.srt"
					)
				end
				strange_wall_used = true
				choosing = false
			elseif crafting_table_used then
				nextscene = "assets/video/episode5/choices/no_mi/1/lever_slot_2.lua"
				in_interactive_zone = false
				choosing = false
			else
				playCutscene(
					"assets/video/episode5/choices/no_mi/1/lever_slot_1.pmp",
					"assets/subtitles/episode5/choices/no_mi/1/lever_slot_1.srt"
				)
				choosing = false
			end
		elseif buttons.pressed(buttons.triangle) then
			if not cobblestone_collected then
				playCutscene(
					"assets/video/episode5/choices/no_mi/1/cobblestone.pmp",
					"assets/subtitles/episode5/choices/no_mi/1/cobblestone.srt"
				)
				cobblestone_collected = true
				choosing = false
			end
		elseif buttons.pressed(buttons.cross) then
			if not dry_bush_collected then
				playCutscene(
					"assets/video/episode5/choices/no_mi/1/dry_bush.pmp",
					"assets/subtitles/episode5/choices/no_mi/1/dry_bush.srt"
				)
				dry_bush_collected = true
				choosing = false
			elseif cobblestone_collected and dry_bush_collected and not crafting_table_used then
				playCutscene(
					"assets/video/episode5/choices/no_mi/1/crafting_table.pmp",
					"assets/subtitles/episode5/choices/no_mi/1/crafting_table.srt"
				)
				crafting_table_used = true
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
