-- Episode 2: "Assembly Required"
-- Single data-driven file: all nodes, choices, and interactive zones.

local V = "assets/video/episode2/"
local S = "assets/subtitles/episode2/"
local EP_FILE = "assets/video/episode2/episode2.lua"

-- Restore saved episode state
local _vf = io.open("assets/saves/2_variables.txt", "r")
if _vf then
	for line in _vf:lines() do
		local k, v = line:match('^(%w+)%s*=%s*"([^"]*)"')
		if k and v then _G[k] = v end
	end
	_vf:close()
end
_vf = nil

checkFile("assets/saves/em.txt", "em")
checkFile("assets/saves/gp.txt", "gp")
checkFile("assets/saves/bf.txt", "bf")

local function pv(rel)
	PMP.setVolume(pmpvolume)
	local r = PMP.playExt(
		V .. rel .. ".pmp", buttons.r, true,
		S .. rel .. ".srt", subs_font, subssize,
		"#FFFFFF", "#000000/110", subs
	)
	System.GC()
	if r == 1 then nextscene = "./mainmenu.lua"; return true end
	return false
end

local function ui2(lk, rk)
	Image.draw(spritesheet, 25,  127, 15, 15, nil, 414, 0, 15, 15)
	Image.draw(spritesheet, 455, 127, 15, 15, nil, 384, 0, 15, 15)
	intraFont.print(45, 127, choices_two[lk], Color.new(255, 255, 255), font, 2)
	intraFont.print(450 - intraFont.textW(font, choices_two[rk], 2), 127,
		choices_two[rk], Color.new(255, 255, 255), font, 2)
	intraFont.print(240 - intraFont.textW(font, ui.save, 2) / 2, 230,
		ui.save, Color.new(255, 255, 255, 150), font, 2)
	debugoverlay.draw(debugoverlay.loadSettings())
	screen.flip()
end

-- ===== INTERACTIVE ZONE: Redstonia =====

local function zone_redstonia()
	local ZV = V .. "ellegaard/choices/2/"
	local ZS = S .. "ellegaard/choices/2/"
	local bg       = Image.load(ZV .. "redstonia_bg.png")
	local bg_fight = Image.load(ZV .. "redstonia_bg_fight.png")
	local chest_used, autofarm_used, fight, intellectual_talk = false, false, false, false
	local in_zone, next_node = true, nil
	local bg_state = "redstonia"

	local function clip(name)
		PMP.setVolume(pmpvolume)
		local r = PMP.playExt(ZV .. name .. ".pmp", buttons.r, true,
			ZS .. name .. ".srt", font, subssize, "#FFFFFF", "#000000/110", subs)
		System.GC()
		if r == 1 then in_zone = false; nextscene = "./mainmenu.lua" end
	end

	while in_zone do
		screen.clear()
		Image.draw(bg_state == "redstonia" and bg or bg_fight, 0, 0)

		if not autofarm_used then
			Image.draw(spritesheet, 125, 216, 15, 15, nil, 399, 0, 15, 15)
			intraFont.print(125 - intraFont.textW(font, choices_two.autofarm, 1.5) / 2 + 8, 216 + 14,
				choices_two.autofarm, Color.new(255, 255, 255), font, 1.5)
		end

		if not intellectual_talk then
			Image.draw(spritesheet, 344, 167, 15, 15, nil, 384, 0, 15, 15)
			intraFont.print(344 - intraFont.textW(font, choices_two.intellectual, 1.5) / 2 + 8, 167 + 14,
				choices_two.intellectual, Color.new(255, 255, 255), font, 1.5)
		elseif not fight then
			Image.draw(spritesheet, 383, 197, 15, 15, nil, 384, 0, 15, 15)
			intraFont.print(383 - intraFont.textW(font, choices_two.schoolboy, 1.5) / 2 + 8, 197 + 14,
				choices_two.schoolboy, Color.new(255, 255, 255), font, 1.5)
		else
			Image.draw(spritesheet, 404, 161, 15, 15, nil, 384, 0, 15, 15)
			intraFont.print(404 - intraFont.textW(font, choices_two.steal_repeater, 1.5) / 2 + 8, 161 + 14,
				choices_two.steal_repeater, Color.new(255, 255, 255), font, 1.5)
		end

		if not chest_used then
			Image.draw(spritesheet, 160, 173, 15, 15, nil, 414, 0, 15, 15)
			intraFont.print(160 - intraFont.textW(font, choices_four.chest, 1.5) / 2 + 8, 173 + 14,
				choices_four.chest, Color.new(255, 255, 255), font, 1.5)
		elseif autofarm_used and chest_used then
			Image.draw(spritesheet, 241, 210, 15, 15, nil, 414, 0, 15, 15)
			intraFont.print(241 - intraFont.textW(font, choices_two.crafting_table, 1.5) / 2 + 8, 210 + 14,
				choices_two.crafting_table, Color.new(255, 255, 255), font, 1.5)
		end

		intraFont.print(240 - intraFont.textW(font, ui.save, 0.63) / 2, 230,
			ui.save, Color.new(255, 255, 255, 150), font, 0.63)
		debugoverlay.draw(debugoverlay.loadSettings())
		screen.flip()

		local picking = true
		while picking do
			buttons.read()
			if buttons.pressed(buttons.cross) then
				if not autofarm_used then
					clip("autofarm"); autofarm_used = true; picking = false
				end
			elseif buttons.pressed(buttons.square) then
				if not chest_used then
					clip("chest"); chest_used = true; picking = false
				elseif autofarm_used and chest_used then
					in_zone = false; picking = false; next_node = "e/c2/craft"
				end
			elseif buttons.pressed(buttons.circle) then
				if not intellectual_talk then
					clip("Intellectual"); intellectual_talk = true; picking = false
				elseif not fight then
					clip("schoolboy"); fight = true; bg_state = "redstonia_fight"; picking = false
				else
					in_zone = false; picking = false; next_node = "e/c2/steal"
				end
			elseif buttons.pressed(buttons.start) then
				local p = dofile("assets/misc/pause.lua"); picking = false
				if p == -1 then in_zone = false; nextscene = "./mainmenu.lua" end
			elseif buttons.pressed(buttons.r) then
				ep2_node = "e/redstonia"; nextscene = EP_FILE; SaveGame(2)
			end
		end
	end

	Image.unload(bg)
	Image.unload(bg_fight)
	return next_node
end

-- ===== NODE GRAPH =====

local nodes = {

	-- Entry: route by em variable
	["start"] = {
		dn = function()
			if em == "ellegaard" then return "e/start"
			elseif em == "magnus"    then return "m/start"
			end
		end,
	},

	-- ===== ELLEGAARD BRANCH =====

	["e/start"] = {
		v  = "ellegaard/start",
		sq = { dk = function() return bf == "bow" and "bow" or "fishing_pole" end,
		       nd = function() return bf == "bow" and "e/bow" or "e/fish" end },
		ci = { k = "sword", n = "e/sword" },
	},

	["e/bow"]  = { v = "ellegaard/bow",          sq = { k = "youre_just_as_good", n = "e/c1/jag" }, ci = { k = "they_could_teach_you", n = "e/c1/tcy" } },
	["e/fish"] = { v = "ellegaard/fishing_pole",  sq = { k = "youre_just_as_good", n = "e/c1/jag" }, ci = { k = "they_could_teach_you", n = "e/c1/tcy" } },
	["e/sword"]= { v = "ellegaard/sword",         sq = { k = "youre_just_as_good", n = "e/c1/jag" }, ci = { k = "they_could_teach_you", n = "e/c1/tcy" } },

	["e/c1/jag"] = { v = "ellegaard/choices/1/youre_just_as_good",  n = "e/redstonia" },
	["e/c1/tcy"] = { v = "ellegaard/choices/1/they_could_teach_you", n = "e/redstonia" },

	["e/redstonia"] = { zone = zone_redstonia },

	["e/c2/craft"] = { v = "ellegaard/choices/2/crafting_table", sq = { k = "dont_touch_anything", n = "e/c3/dont" }, ci = { k = "no_clue_what_this_is", n = "e/c3/noclue" } },
	["e/c2/steal"] = { v = "ellegaard/choices/2/steal_repeater",  sq = { k = "dont_touch_anything", n = "e/c3/dont" }, ci = { k = "no_clue_what_this_is", n = "e/c3/noclue" } },

	["e/c3/dont"]  = { v = "ellegaard/choices/3/dont_touch_anything",  sq = { k = "its_an_honor", n = "e/c4/honor" }, ci = { k = "we_need_your_help", n = "e/c4/help" } },
	["e/c3/noclue"]= { v = "ellegaard/choices/3/no_clue_what_this_is", sq = { k = "its_an_honor", n = "e/c4/honor" }, ci = { k = "we_need_your_help", n = "e/c4/help" } },

	["e/c4/honor"] = { v = "ellegaard/choices/4/its_an_honor",     sq = { k = "leave_her_alone", n = "e/c5/leave" }, ci = { k = "we_have_bigger_issues", n = "e/c5/bigger" } },
	["e/c4/help"]  = { v = "ellegaard/choices/4/we_need_your_help", sq = { k = "leave_her_alone", n = "e/c5/leave" }, ci = { k = "we_have_bigger_issues", n = "e/c5/bigger" } },

	["e/c5/leave"] = {
		v  = "ellegaard/choices/5/leave_her_alone",
		sq = { k = "lets_do_this",   nd = function() return gp == "gabriel" and "eg/c6/lets" or "ep/c6/lets" end },
		ci = { k = "theres_no_time", nd = function() return gp == "gabriel" and "eg/c6/time" or "ep/c6/time" end },
	},
	["e/c5/bigger"] = {
		v  = "ellegaard/choices/5/we_have_bigger_issues",
		sq = { k = "lets_do_this",   nd = function() return gp == "gabriel" and "eg/c6/lets" or "ep/c6/lets" end },
		ci = { k = "theres_no_time", nd = function() return gp == "gabriel" and "eg/c6/time" or "ep/c6/time" end },
	},

	-- Ellegaard + Gabriel companion
	["eg/c6/lets"] = { v = "ellegaard/choices/6/lets_do_this",  sq = { k = "glad_youre_okay", n = "eg/c1/glad" }, ci = { k = "how_did_you_escape", n = "eg/c1/escape" } },
	["eg/c6/time"] = { v = "ellegaard/choices/6/theres_no_time", sq = { k = "glad_youre_okay", n = "eg/c1/glad" }, ci = { k = "how_did_you_escape", n = "eg/c1/escape" } },

	["eg/c1/glad"]  = { v = "ellegaard_gabriel/1/glad_youre_okay",   sq = { k = "ellegaard_is_cool", n = "e/c8/cool" }, ci = { k = "you_need_to_get_along", n = "e/c8/along" } },
	["eg/c1/escape"]= { v = "ellegaard_gabriel/1/how_did_you_escape", sq = { k = "ellegaard_is_cool", n = "e/c8/cool" }, ci = { k = "you_need_to_get_along", n = "e/c8/along" } },

	-- Ellegaard + Petra companion
	["ep/c6/lets"] = { v = "ellegaard_petra/lets_do_this",  sq = { k = "glad_youre_okay", n = "ep/c1/glad" }, ci = { k = "how_did_you_escape", n = "ep/c1/escape" } },
	["ep/c6/time"] = { v = "ellegaard_petra/theres_no_time", sq = { k = "glad_youre_okay", n = "ep/c1/glad" }, ci = { k = "how_did_you_escape", n = "ep/c1/escape" } },

	["ep/c1/glad"]  = { v = "ellegaard_petra/choices/1/glad_youre_okay",   sq = { k = "ellegaard_is_cool", n = "e/c8/cool" }, ci = { k = "you_need_to_get_along", n = "e/c8/along" } },
	["ep/c1/escape"]= { v = "ellegaard_petra/choices/1/how_did_you_escape", sq = { k = "ellegaard_is_cool", n = "e/c8/cool" }, ci = { k = "you_need_to_get_along", n = "e/c8/along" } },

	-- Ellegaard c8: gp-dependent routing
	["e/c8/cool"] = {
		v  = "ellegaard/choices/8/ellegaard_is_cool",
		sq = { k = "stay_out_of_it_axel", nd = function() return gp == "gabriel" and "eg/c2/stay" or "ep/c2/stay" end },
		ci = { k = "ellegaard_calm_down",  nd = function() return gp == "gabriel" and "eg/c2/calm" or "ep/c2/calm" end },
	},
	["e/c8/along"] = {
		v  = "ellegaard/choices/8/you_need_to_get_along",
		sq = { k = "stay_out_of_it_axel", nd = function() return gp == "gabriel" and "eg/c2/stay" or "ep/c2/stay" end },
		ci = { k = "ellegaard_calm_down",  nd = function() return gp == "gabriel" and "eg/c2/calm" or "ep/c2/calm" end },
	},

	["eg/c2/stay"] = { v = "ellegaard_gabriel/2/stay_out_of_it_axel", sq = { k = "he_wasnt_on_the_map", n = "eg/c3/map" }, ci = { k = "we_can_find_him", n = "eg/c3/find" } },
	["eg/c2/calm"] = { v = "ellegaard_gabriel/2/ellegaard_calm_down",  sq = { k = "he_wasnt_on_the_map", n = "eg/c3/map" }, ci = { k = "we_can_find_him", n = "eg/c3/find" } },

	["ep/c2/stay"] = { v = "ellegaard_petra/choices/2/stay_out_of_it_axel", sq = { k = "he_wasnt_on_the_map", n = "ep/c3/map" }, ci = { k = "we_can_find_him", n = "ep/c3/find" } },
	["ep/c2/calm"] = { v = "ellegaard_petra/choices/2/ellegaard_calm_down",  sq = { k = "he_wasnt_on_the_map", n = "ep/c3/map" }, ci = { k = "we_can_find_him", n = "ep/c3/find" } },

	["eg/c3/map"]  = { v = "ellegaard_gabriel/3/he_wasnt_on_the_map", sq = { k = "he_can_be_a_jerk", n = "eg/c4/jerk" }, ci = { k = "hes_awesome", n = "eg/c4/awesome" } },
	["eg/c3/find"] = { v = "ellegaard_gabriel/3/we_can_find_him",      sq = { k = "he_can_be_a_jerk", n = "eg/c4/jerk" }, ci = { k = "hes_awesome", n = "eg/c4/awesome" } },

	["ep/c3/map"]  = { v = "ellegaard_petra/choices/3/he_wasnt_on_the_map", sq = { k = "he_can_be_a_jerk", n = "ep/c4/jerk" }, ci = { k = "hes_awesome", n = "ep/c4/awesome" } },
	["ep/c3/find"] = { v = "ellegaard_petra/choices/3/we_can_find_him",      sq = { k = "he_can_be_a_jerk", n = "ep/c4/jerk" }, ci = { k = "hes_awesome", n = "ep/c4/awesome" } },

	["eg/c4/jerk"]   = { v = "ellegaard_gabriel/4/he_can_be_a_jerk", sq = { k = "thank_you", n = "g/c1/thank" }, ci = { k = "that_was_reckless", n = "g/c1/reckless" } },
	["eg/c4/awesome"]= { v = "ellegaard_gabriel/4/hes_awesome",       sq = { k = "thank_you", n = "g/c1/thank" }, ci = { k = "that_was_reckless", n = "g/c1/reckless" } },

	["ep/c4/jerk"]   = { v = "ellegaard_petra/choices/4/he_can_be_a_jerk", sq = { k = "thank_you", n = "p/c1/thank" }, ci = { k = "that_was_reckless", n = "p/c1/reckless" } },
	["ep/c4/awesome"]= { v = "ellegaard_petra/choices/4/hes_awesome",       sq = { k = "thank_you", n = "p/c1/thank" }, ci = { k = "that_was_reckless", n = "p/c1/reckless" } },

	-- ===== MAGNUS BRANCH =====

	["m/start"] = {
		v  = "magnus/start",
		sq = { dk = function() return bf == "bow" and "bow" or "fishing_pole" end,
		       nd = function() return bf == "bow" and "m/bow" or "m/fish" end },
		ci = { k = "sword", n = "m/sword" },
	},

	["m/bow"]  = { v = "magnus/bow",          sq = { k = "i_know_what_this_means", n = "m/c1/know" }, ci = { k = "only_the_green_part", n = "m/c1/green" } },
	["m/fish"] = { v = "magnus/fishing_pole", sq = { k = "i_know_what_this_means", n = "m/c1/know" }, ci = { k = "only_the_green_part", n = "m/c1/green" } },
	["m/sword"]= { v = "magnus/sword",        sq = { k = "i_know_what_this_means", n = "m/c1/know" }, ci = { k = "only_the_green_part", n = "m/c1/green" } },

	["m/c1/know"]  = { v = "magnus/choices/1/i_know_what_this_means", sq = { k = "chase_griefer", n = "m/c2/griefer" }, ci = { k = "chase_nohr", n = "m/c2/nohr" } },
	["m/c1/green"] = { v = "magnus/choices/1/only_the_green_part",     sq = { k = "chase_griefer", n = "m/c2/griefer" }, ci = { k = "chase_nohr", n = "m/c2/nohr" } },

	["m/c2/griefer"] = { v = "magnus/choices/2/chase_griefer", sq = { k = "give_amulet", n = "m/c3/give" }, ci = { k = "keep_amulet", n = "m/c3/keep" } },
	["m/c2/nohr"]    = { v = "magnus/choices/2/chase_nohr",    sq = { k = "give_amulet", n = "m/c3/give" }, ci = { k = "keep_amulet", n = "m/c3/keep" } },

	["m/c3/give"] = { v = "magnus/choices/3/give_amulet", sq = { k = "we_need_your_help", n = "m/c4/help" }, ci = { k = "were_not_griefers", n = "m/c4/griefers" } },
	["m/c3/keep"] = { v = "magnus/choices/3/keep_amulet", sq = { k = "we_need_your_help", n = "m/c4/help" }, ci = { k = "were_not_griefers", n = "m/c4/griefers" } },

	["m/c4/help"]    = { v = "magnus/choices/4/we_need_your_help",  sq = { k = "its_the_truth", n = "m/c5/truth" }, ci = { k = "you_dont_trust_me", n = "m/c5/trust" } },
	["m/c4/griefers"]= { v = "magnus/choices/4/were_not_griefers",  sq = { k = "its_the_truth", n = "m/c5/truth" }, ci = { k = "you_dont_trust_me", n = "m/c5/trust" } },

	["m/c5/truth"] = { v = "magnus/choices/5/its_the_truth",     sq = { k = "how_could_i_beat_you", n = "m/c6/beat" }, ci = { k = "then_id_be_stuck_here", n = "m/c6/stuck" } },
	["m/c5/trust"] = { v = "magnus/choices/5/you_dont_trust_me", sq = { k = "how_could_i_beat_you", n = "m/c6/beat" }, ci = { k = "then_id_be_stuck_here", n = "m/c6/stuck" } },

	["m/c6/beat"]  = { v = "magnus/choices/6/how_could_i_beat_you",  sq = { k = "stone", n = "m/c7/stone" }, ci = { k = "pink_wool", n = "m/c7/pw" } },
	["m/c6/stuck"] = { v = "magnus/choices/6/then_id_be_stuck_here", sq = { k = "stone", n = "m/c7/stone" }, ci = { k = "pink_wool", n = "m/c7/pw" } },

	["m/c7/stone"] = { v = "magnus/choices/7/stone",     sq = { k = "what_about_the_plan", n = "m/c7s1/plan" }, ci = { k = "youre_going_down", n = "m/c7s1/down" } },
	["m/c7/pw"]    = { v = "magnus/choices/7/pink_wool", sq = { k = "what_about_the_plan", n = "m/c7p1/plan" }, ci = { k = "youre_going_down", n = "m/c7p1/down" } },

	-- Stone sub-choices: gp-dependent routing
	["m/c7s1/plan"] = {
		v  = "magnus/choices/7/stone/1/what_about_the_plan",
		sq = { k = "hello_boom_town",     nd = function() return gp == "gabriel" and "m/c7s2/boom" or "mp/s/boom" end },
		ci = { k = "who_likes_explosions",nd = function() return gp == "gabriel" and "m/c7s2/exp"  or "mp/s/exp"  end },
	},
	["m/c7s1/down"] = {
		v  = "magnus/choices/7/stone/1/youre_going_down",
		sq = { k = "hello_boom_town",     nd = function() return gp == "gabriel" and "m/c7s2/boom" or "mp/s/boom" end },
		ci = { k = "who_likes_explosions",nd = function() return gp == "gabriel" and "m/c7s2/exp"  or "mp/s/exp"  end },
	},

	["m/c7s2/boom"] = { v = "magnus/choices/7/stone/2/hello_boom_town",     sq = { k = "glad_youre_okay", n = "mg/c1/glad" }, ci = { k = "how_did_you_escape", n = "mg/c1/escape" } },
	["m/c7s2/exp"]  = { v = "magnus/choices/7/stone/2/who_likes_explosions", sq = { k = "glad_youre_okay", n = "mg/c1/glad" }, ci = { k = "how_did_you_escape", n = "mg/c1/escape" } },

	["mp/s/boom"] = { v = "magnus_petra/stone/hello_boom_town",     sq = { k = "glad_youre_okay", n = "mp/c1/glad" }, ci = { k = "how_did_you_escape", n = "mp/c1/escape" } },
	["mp/s/exp"]  = { v = "magnus_petra/stone/who_likes_explosions", sq = { k = "glad_youre_okay", n = "mp/c1/glad" }, ci = { k = "how_did_you_escape", n = "mp/c1/escape" } },

	-- Pink wool sub-choices: gp-dependent routing
	["m/c7p1/plan"] = {
		v  = "magnus/choices/7/pink_wool/1/what_about_the_plan",
		sq = { k = "hello_boom_town",     nd = function() return gp == "gabriel" and "m/c7p2/boom" or "mp/p/boom" end },
		ci = { k = "who_likes_explosions",nd = function() return gp == "gabriel" and "m/c7p2/exp"  or "mp/p/exp"  end },
	},
	["m/c7p1/down"] = {
		v  = "magnus/choices/7/pink_wool/1/youre_going_down",
		sq = { k = "hello_boom_town",     nd = function() return gp == "gabriel" and "m/c7p2/boom" or "mp/p/boom" end },
		ci = { k = "who_likes_explosions",nd = function() return gp == "gabriel" and "m/c7p2/exp"  or "mp/p/exp"  end },
	},

	["m/c7p2/boom"] = { v = "magnus/choices/7/pink_wool/2/hello_boom_town",     sq = { k = "glad_youre_okay", n = "mg/c1/glad" }, ci = { k = "how_did_you_escape", n = "mg/c1/escape" } },
	["m/c7p2/exp"]  = { v = "magnus/choices/7/pink_wool/2/who_likes_explosions", sq = { k = "glad_youre_okay", n = "mg/c1/glad" }, ci = { k = "how_did_you_escape", n = "mg/c1/escape" } },

	["mp/p/boom"] = { v = "magnus_petra/pink_wool/hello_boom_town",     sq = { k = "glad_youre_okay", n = "mp/c1/glad" }, ci = { k = "how_did_you_escape", n = "mp/c1/escape" } },
	["mp/p/exp"]  = { v = "magnus_petra/pink_wool/who_likes_explosions", sq = { k = "glad_youre_okay", n = "mp/c1/glad" }, ci = { k = "how_did_you_escape", n = "mp/c1/escape" } },

	-- Magnus + Gabriel companion
	["mg/c1/glad"]  = { v = "magnus_gabriel/1/glad_youre_okay",   sq = { k = "magnus_is_cool", n = "m/c9/cool" }, ci = { k = "you_need_to_get_along", n = "m/c9/along" } },
	["mg/c1/escape"]= { v = "magnus_gabriel/1/how_did_you_escape", sq = { k = "magnus_is_cool", n = "m/c9/cool" }, ci = { k = "you_need_to_get_along", n = "m/c9/along" } },

	-- Magnus + Petra companion
	["mp/c1/glad"]  = { v = "magnus_petra/choices/1/glad_youre_okay",   sq = { k = "magnus_is_cool", n = "m/c9/cool" }, ci = { k = "you_need_to_get_along", n = "m/c9/along" } },
	["mp/c1/escape"]= { v = "magnus_petra/choices/1/how_did_you_escape", sq = { k = "magnus_is_cool", n = "m/c9/cool" }, ci = { k = "you_need_to_get_along", n = "m/c9/along" } },

	-- Magnus c9: gp-dependent routing (labels fixed to match destinations)
	["m/c9/cool"] = {
		v  = "magnus/choices/9/magnus_is_cool",
		sq = { k = "stay_out_of_it_olivia", nd = function() return gp == "gabriel" and "mg/c2/stay" or "mp/c2/stay" end },
		ci = { k = "magnus_calm_down",       nd = function() return gp == "gabriel" and "mg/c2/calm" or "mp/c2/calm" end },
	},
	["m/c9/along"] = {
		v  = "magnus/choices/9/you_need_to_get_along",
		sq = { k = "stay_out_of_it_olivia", nd = function() return gp == "gabriel" and "mg/c2/stay" or "mp/c2/stay" end },
		ci = { k = "magnus_calm_down",       nd = function() return gp == "gabriel" and "mg/c2/calm" or "mp/c2/calm" end },
	},

	["mg/c2/stay"] = { v = "magnus_gabriel/2/stay_out_of_it_olivia", sq = { k = "he_wasnt_on_the_map", n = "mg/c3/map" }, ci = { k = "we_can_find_him", n = "mg/c3/find" } },
	["mg/c2/calm"] = { v = "magnus_gabriel/2/magnus_calm_down",      sq = { k = "he_wasnt_on_the_map", n = "mg/c3/map" }, ci = { k = "we_can_find_him", n = "mg/c3/find" } },

	["mp/c2/stay"] = { v = "magnus_petra/choices/2/stay_out_of_it_olivia", sq = { k = "he_wasnt_on_the_map", n = "mp/c3/map" }, ci = { k = "we_can_find_him", n = "mp/c3/find" } },
	["mp/c2/calm"] = { v = "magnus_petra/choices/2/magnus_calm_down",      sq = { k = "he_wasnt_on_the_map", n = "mp/c3/map" }, ci = { k = "we_can_find_him", n = "mp/c3/find" } },

	["mg/c3/map"]  = { v = "magnus_gabriel/3/he_wasnt_on_the_map", sq = { k = "shes_awesome", n = "mg/c4/awesome" }, ci = { k = "you_make_her_nervous", n = "mg/c4/nervous" } },
	["mg/c3/find"] = { v = "magnus_gabriel/3/we_can_find_him",      sq = { k = "shes_awesome", n = "mg/c4/awesome" }, ci = { k = "you_make_her_nervous", n = "mg/c4/nervous" } },

	["mp/c3/map"]  = { v = "magnus_petra/choices/3/he_wasnt_on_the_map", sq = { k = "shes_awesome", n = "mp/c4/awesome" }, ci = { k = "you_make_her_nervous", n = "mp/c4/nervous" } },
	["mp/c3/find"] = { v = "magnus_petra/choices/3/we_can_find_him",      sq = { k = "shes_awesome", n = "mp/c4/awesome" }, ci = { k = "you_make_her_nervous", n = "mp/c4/nervous" } },

	["mg/c4/awesome"] = { v = "magnus_gabriel/4/shes_awesome",        sq = { k = "thank_you", n = "g/c1/thank" }, ci = { k = "that_was_reckless", n = "g/c1/reckless" } },
	["mg/c4/nervous"] = { v = "magnus_gabriel/4/you_make_her_nervous", sq = { k = "thank_you", n = "g/c1/thank" }, ci = { k = "that_was_reckless", n = "g/c1/reckless" } },

	["mp/c4/awesome"] = { v = "magnus_petra/choices/4/shes_awesome",        sq = { k = "thank_you", n = "p/c1/thank" }, ci = { k = "that_was_reckless", n = "p/c1/reckless" } },
	["mp/c4/nervous"] = { v = "magnus_petra/choices/4/you_make_her_nervous", sq = { k = "thank_you", n = "p/c1/thank" }, ci = { k = "that_was_reckless", n = "p/c1/reckless" } },

	-- ===== SHARED GABRIEL ENDING =====

	["g/c1/thank"]   = { v = "gabriel/1/thank_you",        sq = { k = "follow_ellegaard", n = "g/c2/ellegaard" }, ci = { k = "follow_magnus", n = "g/c2/magnus" } },
	["g/c1/reckless"]= { v = "gabriel/1/that_was_reckless", sq = { k = "follow_ellegaard", n = "g/c2/ellegaard" }, ci = { k = "follow_magnus", n = "g/c2/magnus" } },

	["g/c2/ellegaard"]= { v = "gabriel/2/follow_ellegaard", sq = { k = "go_get_help", n = "g/c3/help" }, ci = { k = "im_fine", n = "g/c3/fine" } },
	["g/c2/magnus"]   = { v = "gabriel/2/follow_magnus",     sq = { k = "go_get_help", n = "g/c3/help" }, ci = { k = "im_fine", n = "g/c3/fine" } },

	["g/c3/help"] = { v = "gabriel/3/go_get_help", sq = { k = "hes_not_leaving", n = "g/c4/not_leaving" }, ci = { k = "let_him_go_gabriel", n = "g/c4/let_go" } },
	["g/c3/fine"] = { v = "gabriel/3/im_fine",      sq = { k = "hes_not_leaving", n = "g/c4/not_leaving" }, ci = { k = "let_him_go_gabriel", n = "g/c4/let_go" } },

	["g/c4/not_leaving"]= { v = "gabriel/4/hes_not_leaving",    sq = { k = "be_careful", n = "g/c5/careful" }, ci = { k = "hes_done_this_before", n = "g/c5/done" } },
	["g/c4/let_go"]     = { v = "gabriel/4/let_him_go_gabriel", sq = { k = "be_careful", n = "g/c5/careful" }, ci = { k = "hes_done_this_before", n = "g/c5/done" } },

	["g/c5/careful"] = {
		pre  = function() wr("2_status", "restart") end,
		v    = "gabriel/5/be_careful",
		post = function()
			PMP.setVolume(pmpvolume)
			PMP.playExt("assets/video/credits/ep2.pmp", buttons.start)
			nextscene = "./mainmenu.lua"
		end,
	},
	["g/c5/done"] = {
		pre  = function() wr("2_status", "restart") end,
		v    = "gabriel/5/hes_done_this_before",
		post = function()
			PMP.setVolume(pmpvolume)
			PMP.playExt("assets/video/credits/ep2.pmp", buttons.start)
			nextscene = "./mainmenu.lua"
		end,
	},

	-- ===== SHARED PETRA ENDING =====

	["p/c1/thank"]   = { v = "petra/1/thank_you",        sq = { k = "follow_ellegaard", n = "p/c2/ellegaard" }, ci = { k = "follow_magnus", n = "p/c2/magnus" } },
	["p/c1/reckless"]= { v = "petra/1/that_was_reckless", sq = { k = "follow_ellegaard", n = "p/c2/ellegaard" }, ci = { k = "follow_magnus", n = "p/c2/magnus" } },

	["p/c2/ellegaard"]= { v = "petra/2/follow_ellegaard", sq = { k = "go_get_help", n = "p/c3/help" }, ci = { k = "im_fine", n = "p/c3/fine" } },
	["p/c2/magnus"]   = { v = "petra/2/follow_magnus",     sq = { k = "go_get_help", n = "p/c3/help" }, ci = { k = "im_fine", n = "p/c3/fine" } },

	["p/c3/help"] = { v = "petra/3/go_get_help", sq = { k = "hes_not_leaving", n = "p/c4/not_leaving" }, ci = { k = "let_him_go_petra", n = "p/c4/let_go" } },
	["p/c3/fine"] = { v = "petra/3/im_fine",      sq = { k = "hes_not_leaving", n = "p/c4/not_leaving" }, ci = { k = "let_him_go_petra", n = "p/c4/let_go" } },

	["p/c4/not_leaving"]= { v = "petra/4/hes_not_leaving",  sq = { k = "be_careful", n = "p/c5/careful" }, ci = { k = "hes_done_this_before", n = "p/c5/done" } },
	["p/c4/let_go"]     = { v = "petra/4/let_him_go_petra", sq = { k = "be_careful", n = "p/c5/careful" }, ci = { k = "hes_done_this_before", n = "p/c5/done" } },

	["p/c5/careful"] = {
		pre  = function() wr("2_status", "restart") end,
		v    = "petra/5/be_careful",
		post = function()
			PMP.setVolume(pmpvolume)
			PMP.playExt("assets/video/credits/ep2.pmp", buttons.start)
			nextscene = "./mainmenu.lua"
		end,
	},
	["p/c5/done"] = {
		pre  = function() wr("2_status", "restart") end,
		v    = "petra/5/hes_done_this_before",
		post = function()
			PMP.setVolume(pmpvolume)
			PMP.playExt("assets/video/credits/ep2.pmp", buttons.start)
			nextscene = "./mainmenu.lua"
		end,
	},
}

-- ===== MAIN EPISODE LOOP =====

local current = ep2_node or "start"
ep2_node = nil

while true do
	System.PowerTick()
	local node = nodes[current]
	if not node then break end

	if node.pre then node.pre() end

	if node.dn then
		current = node.dn()

	elseif node.zone then
		current = node.zone()
		if nextscene == "./mainmenu.lua" then return 1 end
		if not current then break end

	else
		local vpath = node.dv and node.dv() or node.v
		if vpath and pv(vpath) then return 1 end

		if node.post then
			node.post()
			break
		end

		if node.sq then
			local sq_k = node.sq.dk and node.sq.dk() or node.sq.k
			local ci_k = node.ci.dk and node.ci.dk() or node.ci.k
			ui2(sq_k, ci_k)

			ep2_node  = current
			nextscene = EP_FILE

			local chose = false
			while not chose do
				buttons.read()
				if buttons.pressed(buttons.square) then
					if node.sq.fn then node.sq.fn() end
					current = node.sq.nd and node.sq.nd() or node.sq.n
					chose = true
				elseif buttons.pressed(buttons.circle) then
					if node.ci.fn then node.ci.fn() end
					current = node.ci.nd and node.ci.nd() or node.ci.n
					chose = true
				elseif buttons.pressed(buttons.start) then
					local p = dofile("assets/misc/pause.lua")
					if p == -1 then nextscene = "./mainmenu.lua"; return 1 end
					ui2(sq_k, ci_k)
				elseif buttons.pressed(buttons.r) then
					SaveGame(2)
				end
			end

		elseif node.n then
			current = node.n
		else
			break
		end
	end
end
