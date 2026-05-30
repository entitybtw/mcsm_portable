local V = "assets/video/episode5/"
local S = "assets/subtitles/episode5/"
local EP_FILE = "assets/video/episode5/episode5.lua"

local _vf = io.open("assets/saves/5_variables.txt", "r")
if _vf then
	for line in _vf:lines() do
		local k, v = line:match('^(%w+)%s*=%s*"([^"]*)"')
		if k and v then _G[k] = v end
	end
	_vf:close()
end
_vf = nil

local function pv(rel)
	PMP.setVolume(pmpvolume)
	local r = PMP.playExt(V .. rel .. ".pmp", buttons.r, true,
		S .. rel .. ".srt", subs_font, subssize, "#FFFFFF", "#000000/110", subs)
	System.GC()
	if r == 1 then nextscene = "./mainmenu.lua"; return true end
	return false
end

local function resolve_label(entry)
	if entry.rl then return entry.rl end
	local t = entry.tab or choices_five
	if entry.dk then return t[entry.dk()] end
	return t[entry.k]
end

local function ui2(ltxt, rtxt)
	Image.draw(spritesheet, 25, 127, 15, 15, nil, 414, 0, 15, 15)
	Image.draw(spritesheet, 455, 127, 15, 15, nil, 384, 0, 15, 15)
	intraFont.print(45, 127, ltxt, Color.new(255, 255, 255), font, 2)
	intraFont.print(450 - intraFont.textW(font, rtxt, 2), 127, rtxt, Color.new(255, 255, 255), font, 2)
	intraFont.print(240 - intraFont.textW(font, ui.save, 2) / 2, 230, ui.save, Color.new(255, 255, 255, 150), font, 2)
	debugoverlay.draw()
	screen.flip()
end

local function ep5_end()
	wr("5_status", "restart")
	PMP.setVolume(pmpvolume)
	PMP.play("assets/video/credits/ep5.pmp", buttons.start, false)
	System.GC()
	nextscene = "./mainmenu.lua"
end

local function zone_sky_city()
	local Vz = V .. "choices/14/"
	local Sz = S .. "choices/14/"
	local bg1 = Image.load(Vz .. "sky_city_exploration_1.png")
	local bg2 = Image.load(Vz .. "sky_city_exploration_2.png")
	local bg3 = Image.load(Vz .. "sky_city_exploration_3.png")

	local sky_city_1_explored = false
	local castle_guard_talk = false
	local sky_city_2_explored = false
	local townspeople_talk = false
	local in_zone = true
	local ret = nil

	local function pc(rel)
		PMP.setVolume(pmpvolume)
		local r = PMP.playExt(Vz .. rel .. ".pmp", buttons.r, true,
			Sz .. rel .. ".srt", font, subssize, "#FFFFFF", "#000000/110", subs)
		System.GC()
		if r == 1 then nextscene = "./mainmenu.lua"; in_zone = false end
		return r == 1
	end

	while in_zone do
		screen.clear()

		if not sky_city_1_explored then
			Image.draw(bg1, 0, 0)
		elseif not sky_city_2_explored then
			Image.draw(bg2, 0, 0)
		else
			Image.draw(bg3, 0, 0)
		end

		if not sky_city_1_explored then
			Image.draw(spritesheet, 140, 134, 15, 15, nil, 399, 0, 15, 15)
			intraFont.print(140 - intraFont.textW(font, choices_four.crafting_table, 1.5) / 2 + 8, 134 + 14,
				choices_four.crafting_table, Color.new(255, 255, 255), font, 1.5)
			Image.draw(spritesheet, 417, 145, 15, 15, nil, 430, 0, 15, 15)
			intraFont.print(417 - intraFont.textW(font, choices_five.garden, 1.5) / 2 + 8, 145 + 14,
				choices_five.garden, Color.new(255, 255, 255), font, 1.5)
		end

		if sky_city_1_explored and not sky_city_2_explored and not castle_guard_talk then
			Image.draw(spritesheet, 100, 70, 15, 15, nil, 399, 0, 15, 15)
			intraFont.print(100 - intraFont.textW(font, choices_five.castle_guard, 1.5) / 2 + 8, 70 + 14,
				choices_five.castle_guard, Color.new(255, 255, 255), font, 1.5)
		end

		if not sky_city_2_explored and sky_city_1_explored then
			Image.draw(spritesheet, 417, 60, 15, 15, nil, 430, 0, 15, 15)
			intraFont.print(417 - intraFont.textW(font, choices_five.build_site, 1.5) / 2 + 8, 60 + 14,
				choices_five.build_site, Color.new(255, 255, 255), font, 1.5)
		end

		if sky_city_2_explored and not townspeople_talk then
			Image.draw(spritesheet, 330, 140, 15, 15, nil, 430, 0, 15, 15)
			intraFont.print(330 - intraFont.textW(font, choices_five.townspeople, 1.5) / 2 + 8, 140 + 14,
				choices_five.townspeople, Color.new(255, 255, 255), font, 1.5)
		end

		if sky_city_2_explored then
			Image.draw(spritesheet, 115, 145, 15, 15, nil, 399, 0, 15, 15)
			intraFont.print(115 - intraFont.textW(font, choices_five.innkeeper, 1.5) / 2 + 8, 145 + 14,
				choices_five.innkeeper, Color.new(255, 255, 255), font, 1.5)
		end

		intraFont.print(240 - intraFont.textW(font, ui.save, 0.63) / 2, 230,
			ui.save, Color.new(255, 255, 255, 150), font, 0.63)
		debugoverlay.draw()
		screen.flip()

		local choosing = true
		while choosing do
			buttons.read()

			if buttons.pressed(buttons.cross) then
				if not sky_city_1_explored then
					pc("crafting_table")
					sky_city_1_explored = true
					choosing = false
				elseif sky_city_1_explored and not sky_city_2_explored and not castle_guard_talk then
					pc("castle_guard")
					castle_guard_talk = true
					choosing = false
				elseif sky_city_2_explored then
					ret = "c14/innkeeper"
					in_zone = false
					choosing = false
				end
			elseif buttons.pressed(buttons.triangle) then
				if not sky_city_1_explored then
					pc("garden")
					sky_city_1_explored = true
					choosing = false
				elseif sky_city_2_explored and not townspeople_talk then
					pc("townspeople")
					townspeople_talk = true
					choosing = false
				elseif not sky_city_2_explored and sky_city_1_explored then
					pc("build_site")
					sky_city_2_explored = true
					choosing = false
				end
			elseif buttons.pressed(buttons.start) then
				local p = dofile("assets/misc/pause.lua")
				if p == -1 then
					nextscene = "./mainmenu.lua"
					in_zone = false
				end
				choosing = false
			elseif buttons.pressed(buttons.r) then
				SaveGame(5)
				choosing = false
			end
		end
	end

	Image.unload(bg1)
	Image.unload(bg2)
	Image.unload(bg3)
	return ret
end

local function zone_throne_room()
	local Vz = V .. "choices/no_mi/1/"
	local Sz = S .. "choices/no_mi/1/"
	local bg = Image.load(Vz .. "throne_room_bg.png")

	local bookcase_used = false
	local cobblestone_collected = false
	local dry_bush_collected = false
	local strange_wall_used = false
	local crafting_table_used = false
	local in_zone = true
	local ret = nil

	local function pc(rel)
		PMP.setVolume(pmpvolume)
		local r = PMP.playExt(Vz .. rel .. ".pmp", buttons.r, true,
			Sz .. rel .. ".srt", font, subssize, "#FFFFFF", "#000000/110", subs)
		System.GC()
		if r == 1 then nextscene = "./mainmenu.lua"; in_zone = false end
		return r == 1
	end

	while in_zone do
		screen.clear()
		Image.draw(bg, 0, 0)

		if not bookcase_used then
			Image.draw(spritesheet, 59, 160, 15, 15, nil, 414, 0, 15, 15)
			intraFont.print(59 - intraFont.textW(font, choices_five.bookcase, 1.5) / 2 + 8, 160 + 14,
				choices_five.bookcase, Color.new(255, 255, 255), font, 0.4)
		end

		Image.draw(spritesheet, 397, 166, 15, 15, nil, 384, 0, 15, 15)
		if not strange_wall_used then
			local lbl = (mi == "milo") and choices_five.strange_wall or choices_five.supply_door
			intraFont.print(397 - intraFont.textW(font, lbl, 1.5) / 2 + 8, 166 + 14,
				lbl, Color.new(255, 255, 255), font, 0.4)
		else
			intraFont.print(397 - intraFont.textW(font, choices_five.lever_slot, 1.5) / 2 + 8, 166 + 14,
				choices_five.lever_slot, Color.new(255, 255, 255), font, 0.4)
		end

		if not cobblestone_collected then
			Image.draw(spritesheet, 144, 203, 15, 15, nil, 430, 0, 15, 15)
			intraFont.print(144 - intraFont.textW(font, choices_five.cobblestone, 1.5) / 2 + 8, 203 + 14,
				choices_five.cobblestone, Color.new(255, 255, 255), font, 0.4)
		end

		if not dry_bush_collected then
			Image.draw(spritesheet, 282, 207, 15, 15, nil, 399, 0, 15, 15)
			intraFont.print(282 - intraFont.textW(font, choices_five.dry_bush, 1.5) / 2 + 8, 207 + 14,
				choices_five.dry_bush, Color.new(255, 255, 255), font, 0.4)
		elseif cobblestone_collected and not crafting_table_used then
			Image.draw(spritesheet, 282, 207, 15, 15, nil, 399, 0, 15, 15)
			intraFont.print(282 - intraFont.textW(font, choices_four.crafting_table, 1.5) / 2 + 8, 207 + 14,
				choices_four.crafting_table, Color.new(255, 255, 255), font, 1.5)
		end

		intraFont.print(240 - intraFont.textW(font, ui.save, 0.63) / 2, 230,
			ui.save, Color.new(255, 255, 255, 150), font, 0.63)
		debugoverlay.draw()
		screen.flip()

		local choosing = true
		while choosing do
			buttons.read()

			if buttons.pressed(buttons.square) then
				if not bookcase_used then
					pc("bookcase")
					bookcase_used = true
					choosing = false
				end
			elseif buttons.pressed(buttons.circle) then
				if not strange_wall_used then
					pc((mi == "milo") and "strange_wall" or "supply_door")
					strange_wall_used = true
					choosing = false
				elseif crafting_table_used then
					ret = "nm1/lever2"
					in_zone = false
					choosing = false
				else
					pc("lever_slot_1")
					choosing = false
				end
			elseif buttons.pressed(buttons.triangle) then
				if not cobblestone_collected then
					pc("cobblestone")
					cobblestone_collected = true
					choosing = false
				end
			elseif buttons.pressed(buttons.cross) then
				if not dry_bush_collected then
					pc("dry_bush")
					dry_bush_collected = true
					choosing = false
				elseif cobblestone_collected and dry_bush_collected and not crafting_table_used then
					pc("crafting_table")
					crafting_table_used = true
					choosing = false
				end
			elseif buttons.pressed(buttons.start) then
				local p = dofile("assets/misc/pause.lua")
				if p == -1 then
					nextscene = "./mainmenu.lua"
					in_zone = false
				end
				choosing = false
			elseif buttons.pressed(buttons.r) then
				SaveGame(5)
				choosing = false
			end
		end
	end

	Image.unload(bg)
	return ret
end

local nodes = {
	-- START
	["start"] = {
		v  = "start",
		sq = { k = "for_glory",          n = "for_glory" },
		ci = { k = "lets_find_treasure", n = "lets_find"  },
	},

	-- OPENING CHOICE
	["for_glory"] = {
		v  = "for_glory",
		sq = { k = "i_was_clueless",   n = "c1/clueless" },
		ci = { k = "weve_come_so_far", n = "c1/far"      },
	},
	["lets_find"] = {
		v  = "lets_find_treasure",
		sq = { k = "i_was_clueless",   n = "c1/clueless" },
		ci = { k = "weve_come_so_far", n = "c1/far"      },
	},

	-- C1
	["c1/clueless"] = {
		v  = "choices/1/i_was_clueless",
		sq = { k = "what_is_this", n = "c2/what" },
		ci = { k = "its_mine_now", n = "c2/mine" },
	},
	["c1/far"] = {
		v  = "choices/1/weve_come_so_far",
		sq = { k = "what_is_this", n = "c2/what" },
		ci = { k = "its_mine_now", n = "c2/mine" },
	},

	-- C2
	["c2/what"] = {
		v  = "choices/2/what_is_this",
		sq = { k = "warrior_whip", n = "c3/whip" },
		ci = { k = "redstone_rap", n = "c3/rap"  },
	},
	["c2/mine"] = {
		v  = "choices/2/its_mine_now",
		sq = { k = "warrior_whip", n = "c3/whip" },
		ci = { k = "redstone_rap", n = "c3/rap"  },
	},

	-- C3
	["c3/whip"] = {
		v  = "choices/3/warrior_whip",
		sq = { k = "you_try_it_axel",    n = "c4/try" },
		ci = { k = "way_a_head_of_you",  n = "c4/way" },
	},
	["c3/rap"] = {
		v  = "choices/3/redstone_rap",
		sq = { k = "you_try_it_axel",    n = "c4/try" },
		ci = { k = "way_a_head_of_you",  n = "c4/way" },
	},

	-- C4
	["c4/try"] = {
		v  = "choices/4/you_try_it_axel",
		sq = { k = "youre_not_worth_it", n = "c5/nw" },
		ci = { k = "dont_mess_with_me",  n = "c5/dm" },
	},
	["c4/way"] = {
		v  = "choices/4/way_a_head_of_you",
		sq = { k = "youre_not_worth_it", n = "c5/nw" },
		ci = { k = "dont_mess_with_me",  n = "c5/dm" },
	},

	-- C5
	["c5/nw"] = {
		v  = "choices/5/youre_not_worth_it",
		sq = { k = "time_to_party",        n = "c6/tp" },
		ci = { k = "this_place_is_awesome", n = "c6/pa" },
	},
	["c5/dm"] = {
		v  = "choices/5/dont_mess_with_me",
		sq = { k = "time_to_party",         n = "c6/tp" },
		ci = { k = "this_place_is_awesome", n = "c6/pa" },
	},

	-- C6
	["c6/tp"] = {
		v  = "choices/6/time_to_party",
		sq = { k = "tear_it_down",  n = "c7/td" },
		ci = { k = "leave_it_alone", n = "c7/la" },
	},
	["c6/pa"] = {
		v  = "choices/6/this_place_is_awesome",
		sq = { k = "tear_it_down",  n = "c7/td" },
		ci = { k = "leave_it_alone", n = "c7/la" },
	},

	-- C7
	["c7/td"] = {
		v  = "choices/7/tear_it_down",
		sq = { k = "i_still_feel_guilty", n = "c8/guilty" },
		ci = { k = "i_really_miss_him",   n = "c8/miss"   },
	},
	["c7/la"] = {
		v  = "choices/7/leave_it_alone",
		sq = { k = "i_still_feel_guilty", n = "c8/guilty" },
		ci = { k = "i_really_miss_him",   n = "c8/miss"   },
	},

	-- C8
	["c8/guilty"] = {
		v  = "choices/8/i_still_feel_guilty",
		sq = { k = "what_is_that",   n = "c9/what" },
		ci = { k = "is_it_valuable", n = "c9/val"  },
	},
	["c8/miss"] = {
		v  = "choices/8/i_really_miss_him",
		sq = { k = "what_is_that",   n = "c9/what" },
		ci = { k = "is_it_valuable", n = "c9/val"  },
	},

	-- C9
	["c9/what"] = {
		v  = "choices/9/what_is_that",
		sq = { k = "hes_smart", n = "c10/smart" },
		ci = { k = "hes_funny", n = "c10/funny" },
	},
	["c9/val"] = {
		v  = "choices/9/is_it_valuable",
		sq = { k = "hes_smart", n = "c10/smart" },
		ci = { k = "hes_funny", n = "c10/funny" },
	},

	-- C10
	["c10/smart"] = {
		v  = "choices/10/hes_smart",
		sq = { k = "youll_regret_that",  n = "c11/regret"  },
		ci = { k = "please_be_careful",  n = "c11/careful" },
	},
	["c10/funny"] = {
		v  = "choices/10/hes_funny",
		sq = { k = "youll_regret_that",  n = "c11/regret"  },
		ci = { k = "please_be_careful",  n = "c11/careful" },
	},

	-- C11
	["c11/regret"] = {
		v  = "choices/11/youll_regret_that",
		sq = { k = "is_that_a_city",      n = "c12/city"  },
		ci = { k = "maybe_aidens_there",  n = "c12/aiden" },
	},
	["c11/careful"] = {
		v  = "choices/11/please_be_careful",
		sq = { k = "is_that_a_city",      n = "c12/city"  },
		ci = { k = "maybe_aidens_there",  n = "c12/aiden" },
	},

	-- C12
	["c12/city"] = {
		v  = "choices/12/is_that_a_city",
		sq = { k = "is_something_wrong",         n = "c13/wrong" },
		ci = { k = "did_you_see_the_blaze_rods",  n = "c13/rods"  },
	},
	["c12/aiden"] = {
		v  = "choices/12/maybe_aidens_there",
		sq = { k = "is_something_wrong",         n = "c13/wrong" },
		ci = { k = "did_you_see_the_blaze_rods",  n = "c13/rods"  },
	},

	-- C13 (simple n → zone)
	["c13/wrong"] = { v = "choices/13/is_something_wrong",         n = "c14/zone" },
	["c13/rods"]  = { v = "choices/13/did_you_see_the_blaze_rods", n = "c14/zone" },

	-- C14: zone + innkeeper choice
	["c14/zone"]      = { zone = zone_sky_city },
	["c14/innkeeper"] = {
		v  = "choices/14/innkeeper",
		sq = { k = "dont_lie_to_me",  n = "c15/lie"   },
		ci = { k = "you_can_trust_me", n = "c15/trust" },
	},

	-- C15
	["c15/lie"] = {
		v  = "choices/15/dont_lie_to_me",
		sq = { k = "help_ivor",    n = "c16/ivor" },
		ci = { k = "go_with_milo", n = "c16/milo" },
	},
	["c15/trust"] = {
		v  = "choices/15/you_can_trust_me",
		sq = { k = "help_ivor",    n = "c16/ivor" },
		ci = { k = "go_with_milo", n = "c16/milo" },
	},

	-- C16: sets mi variable
	["c16/milo"] = {
		pre = function() mi = "milo" end,
		v   = "choices/16/go_with_milo",
		sq  = { rl = "Yeah, sure whatever",       n = "c17/milo/yeah"    },
		ci  = { k  = "your_secrets_safe_with_me", n = "c17/milo/secrets" },
	},
	["c16/ivor"] = {
		pre = function() mi = "ivor" end,
		v   = "choices/16/help_ivor",
		sq  = { k = "shut_up_both_of_you",   n = "c17/ivor/shut"  },
		ci  = { k = "yeah_aidens_our_focus", n = "c17/ivor/focus" },
	},

	-- C17
	["c17/milo/yeah"] = {
		v  = "choices/17/milo/yeah_sure_whatever",
		sq = { k = "our_friends_need_us", n = "c18/milo/friends" },
		ci = { k = "you_have_a_plan",     n = "c18/milo/plan"    },
	},
	["c17/milo/secrets"] = {
		v  = "choices/17/milo/your_secrets_safe_with_me",
		sq = { k = "our_friends_need_us", n = "c18/milo/friends" },
		ci = { k = "you_have_a_plan",     n = "c18/milo/plan"    },
	},
	["c17/ivor/shut"] = {
		v  = "choices/17/ivor/shut_up_both_of_you",
		sq = { k = "aiden_is_using_you", n = "c18/ivor/aiden" },
		ci = { k = "he_stole_from_us",   n = "c18/ivor/stole" },
	},
	["c17/ivor/focus"] = {
		v  = "choices/17/ivor/yeah_aidens_our_focus",
		sq = { k = "aiden_is_using_you", n = "c18/ivor/aiden" },
		ci = { k = "he_stole_from_us",   n = "c18/ivor/stole" },
	},

	-- C18
	["c18/milo/friends"] = {
		v  = "choices/18/milo/our_friends_need_us",
		sq = { k = "craft_anvil", n = "c19/milo/anvil" },
		ci = { k = "craft_boots", n = "c19/milo/boots" },
	},
	["c18/milo/plan"] = {
		v  = "choices/18/milo/you_have_a_plan",
		sq = { k = "craft_anvil", n = "c19/milo/anvil" },
		ci = { k = "craft_boots", n = "c19/milo/boots" },
	},
	["c18/ivor/aiden"] = {
		v  = "choices/18/ivor/aiden_is_using_you",
		sq = { k = "we_can_help_you",     n = "c19/ivor/help"  },
		ci = { k = "you_just_want_power", n = "c19/ivor/power" },
	},
	["c18/ivor/stole"] = {
		v  = "choices/18/ivor/he_stole_from_us",
		sq = { k = "we_can_help_you",     n = "c19/ivor/help"  },
		ci = { k = "you_just_want_power", n = "c19/ivor/power" },
	},

	-- C19
	["c19/milo/anvil"] = {
		v  = "choices/19/milo/craft_anvil",
		sq = { k = "ill_do_it_for_my_friends", n = "c20/ma/friends" },
		ci = { k = "we_had_a_deal",             n = "c20/ma/deal"    },
	},
	["c19/milo/boots"] = {
		v  = "choices/19/milo/craft_boots",
		sq = { k = "ill_do_it_for_my_friends", n = "c20/mb/friends" },
		ci = { k = "we_had_a_deal",             n = "c20/mb/deal"    },
	},
	["c19/ivor/help"] = {
		v  = "choices/19/ivor/we_can_help_you",
		sq = { k = "hes_just_a_liar",    n = "c20/ivor/liar" },
		ci = { k = "were_not_criminals", n = "c20/ivor/crim" },
	},
	["c19/ivor/power"] = {
		v  = "choices/19/ivor/you_just_want_power",
		sq = { k = "hes_just_a_liar",    n = "c20/ivor/liar" },
		ci = { k = "were_not_criminals", n = "c20/ivor/crim" },
	},

	-- C20
	["c20/ma/friends"] = {
		v  = "choices/20/milo_anvil/ill_do_it_for_my_friends",
		sq = { k = "keep_it_down_milo", n = "c21/milo/keep" },
		ci = { k = "supposedly",         n = "c21/milo/sup"  },
	},
	["c20/ma/deal"] = {
		v  = "choices/20/milo_anvil/we_had_a_deal",
		sq = { k = "keep_it_down_milo", n = "c21/milo/keep" },
		ci = { k = "supposedly",         n = "c21/milo/sup"  },
	},
	["c20/mb/friends"] = {
		v  = "choices/20/milo_boots/ill_do_it_for_my_friends",
		sq = { k = "keep_it_down_milo", n = "c21/milo/keep" },
		ci = { k = "supposedly",         n = "c21/milo/sup"  },
	},
	["c20/mb/deal"] = {
		v  = "choices/20/milo_boots/we_had_a_deal",
		sq = { k = "keep_it_down_milo", n = "c21/milo/keep" },
		ci = { k = "supposedly",         n = "c21/milo/sup"  },
	},
	["c20/ivor/liar"] = {
		v  = "choices/20/ivor/hes_just_a_liar",
		sq = { k = "aiden_is_much_worse", n = "c21/ivor/worse" },
		ci = { k = "its_the_right_thing", n = "c21/ivor/right" },
	},
	["c20/ivor/crim"] = {
		v  = "choices/20/ivor/were_not_criminals",
		sq = { k = "aiden_is_much_worse", n = "c21/ivor/worse" },
		ci = { k = "its_the_right_thing", n = "c21/ivor/right" },
	},

	-- C21
	["c21/milo/keep"] = { v = "choices/21/milo/keep_it_down_milo", n = "nm1/zone" },
	["c21/milo/sup"]  = { v = "choices/21/milo/supposedly",        n = "nm1/zone" },
	["c21/ivor/worse"] = {
		v  = "choices/21/ivor/aiden_is_much_worse",
		sq = { k = "aiden_cant_get_it",   n = "c22/cant"  },
		ci = { k = "taking_it_is_wrong",  n = "c22/wrong" },
	},
	["c21/ivor/right"] = {
		v  = "choices/21/ivor/its_the_right_thing",
		sq = { k = "aiden_cant_get_it",  n = "c22/cant"  },
		ci = { k = "taking_it_is_wrong", n = "c22/wrong" },
	},

	-- C22
	["c22/cant"] = {
		v  = "choices/22/aiden_cant_get_it",
		sq = { k = "look_before_you_punch", n = "c23/look"  },
		ci = { k = "petra_you_trust_him",   n = "c23/petra" },
	},
	["c22/wrong"] = {
		v  = "choices/22/taking_it_is_wrong",
		sq = { k = "look_before_you_punch", n = "c23/look"  },
		ci = { k = "petra_you_trust_him",   n = "c23/petra" },
	},

	-- C23 (simple n → zone)
	["c23/look"]  = { v = "choices/23/look_before_you_punch", n = "nm1/zone" },
	["c23/petra"] = { v = "choices/23/petra_you_trust_him",   n = "nm1/zone" },

	-- THRONE ROOM ZONE
	["nm1/zone"]   = { zone = zone_throne_room },
	["nm1/lever2"] = {
		v  = "choices/no_mi/1/lever_slot_2",
		sq = { rl = "These generate\n\n resources",   n = "nm23/gen"  },
		ci = { rl = "The Eversource\n\n makes eggs?", n = "nm23/eggs" },
	},

	-- NM23
	["nm23/gen"] = {
		v  = "choices/no_mi/23/these_generate_resources",
		sq = { k = "the_people_need_it",    n = "c24/people"  },
		ci = { k = "well_take_the_chicken", n = "c24/chicken" },
	},
	["nm23/eggs"] = {
		v  = "choices/no_mi/23/the_eversource_makes_eggs",
		sq = { k = "the_people_need_it",    n = "c24/people"  },
		ci = { k = "well_take_the_chicken", n = "c24/chicken" },
	},

	-- C24 (dv uses mi)
	["c24/people"] = {
		dv = function() return "choices/24/" .. mi .. "/the_people_need_it" end,
		sq = { k = "back_lukas_up",   n = "c25/lukas"   },
		ci = { k = "save_the_founder", n = "c25/founder" },
	},
	["c24/chicken"] = {
		dv = function() return "choices/24/" .. mi .. "/well_take_the_chicken" end,
		sq = { k = "back_lukas_up",   n = "c25/lukas"   },
		ci = { k = "save_the_founder", n = "c25/founder" },
	},

	-- C25: sets save variable
	["c25/lukas"] = {
		pre = function() save = "lukas" end,
		v   = "choices/25/back_lukas_up",
		sq  = { k = "it_doesnt_matter",  n = "c26/it" },
		ci  = { k = "no_its_your_fault", n = "c26/no" },
	},
	["c25/founder"] = {
		pre = function() save = "founder" end,
		v   = "choices/25/save_the_founder",
		sq  = { k = "it_doesnt_matter",  n = "c26/it" },
		ci  = { k = "no_its_your_fault", n = "c26/no" },
	},

	-- C26 (dv uses mi)
	["c26/it"] = {
		dv = function() return "choices/26/" .. mi .. "/it_doesnt_matter" end,
		sq = { k = "bring_everyone_here",  n = "c27/bring" },
		ci = { k = "we_kick_aidens_butt", n = "c27/kick"  },
	},
	["c26/no"] = {
		dv = function() return "choices/26/" .. mi .. "/no_its_your_fault" end,
		sq = { k = "bring_everyone_here",  n = "c27/bring" },
		ci = { k = "we_kick_aidens_butt", n = "c27/kick"  },
	},

	-- C27
	["c27/bring"] = {
		dv = function() return "choices/27/" .. mi .. "/bring_everyone_here" end,
		sq = { k = "im_going_home",  n = "c28/home"   },
		ci = { k = "its_my_portal", n = "c28/portal" },
	},
	["c27/kick"] = {
		v  = "choices/27/we_kick_aidens_butt",
		sq = { k = "im_going_home",  n = "c28/home"   },
		ci = { k = "its_my_portal", n = "c28/portal" },
	},

	-- C28
	["c28/home"] = {
		v  = "choices/28/im_going_home",
		sq = { k = "potion_of_speed",        n = "c29/speed" },
		ci = { k = "potion_of_invisibility", n = "c29/invis" },
	},
	["c28/portal"] = {
		v  = "choices/28/its_my_portal",
		sq = { k = "potion_of_speed",        n = "c29/speed" },
		ci = { k = "potion_of_invisibility", n = "c29/invis" },
	},

	-- C29 (speed dv uses mi)
	["c29/speed"] = {
		dv = function() return "choices/29/" .. mi .. "/potion_of_speed" end,
		sq = { k = "give_up_aiden",     n = "c30/give" },
		ci = { k = "ill_kick_your_butt", n = "c30/kick" },
	},
	["c29/invis"] = {
		v  = "choices/29/potion_of_invisibility",
		sq = { k = "give_up_aiden",     n = "c30/give" },
		ci = { k = "ill_kick_your_butt", n = "c30/kick" },
	},

	-- C30 (dv uses mi)
	["c30/give"] = {
		dv = function() return "choices/30/" .. mi .. "/give_up_aiden" end,
		sq = { k = "its_too_dangerous", n = "c31/danger" },
		ci = { k = "you_should_rest",   n = "c31/rest"   },
	},
	["c30/kick"] = {
		dv = function() return "choices/30/" .. mi .. "/ill_kick_your_butt" end,
		sq = { k = "its_too_dangerous", n = "c31/danger" },
		ci = { k = "you_should_rest",   n = "c31/rest"   },
	},

	-- C31
	["c31/danger"] = {
		v  = "choices/31/its_too_dangerous",
		sq = { k = "im_glad_youre_okay",  n = "c32/glad"  },
		ci = { k = "sorry_i_didnt_help", n = "c32/sorry" },
	},
	["c31/rest"] = {
		v  = "choices/31/you_should_rest",
		sq = { k = "im_glad_youre_okay",  n = "c32/glad"  },
		ci = { k = "sorry_i_didnt_help", n = "c32/sorry" },
	},

	-- C32
	["c32/glad"] = {
		v  = "choices/32/im_glad_youre_okay",
		sq = { k = "have_some_fun", n = "c33/fun"  },
		ci = { k = "take_it_slow",  n = "c33/slow" },
	},
	["c32/sorry"] = {
		v  = "choices/32/sorry_i_didnt_help",
		sq = { k = "have_some_fun", n = "c33/fun"  },
		ci = { k = "take_it_slow",  n = "c33/slow" },
	},

	-- C33
	["c33/fun"] = {
		v  = "choices/33/have_some_fun",
		sq = { k = "come_on_milo",    n = "c34/milo"    },
		ci = { k = "relax_founder",   n = "c34/founder" },
	},
	["c33/slow"] = {
		v  = "choices/33/take_it_slow",
		sq = { k = "come_on_milo",   n = "c34/milo"    },
		ci = { k = "relax_founder",  n = "c34/founder" },
	},

	-- C34 (nd uses save for c35 routing)
	["c34/milo"] = {
		v  = "choices/34/come_on_milo",
		sq = { k = "build_something_new", nd = function() return "c35/" .. save .. "/build"  end },
		ci = { k = "you_could_travel",    nd = function() return "c35/" .. save .. "/travel" end },
	},
	["c34/founder"] = {
		v  = "choices/34/relax_founder",
		sq = { k = "build_something_new", nd = function() return "c35/" .. save .. "/build"  end },
		ci = { k = "you_could_travel",    nd = function() return "c35/" .. save .. "/travel" end },
	},

	-- C35 endings
	["c35/lukas/build"]    = { dv = function() return "choices/35/lukas/build_something_new"   end, post = ep5_end },
	["c35/lukas/travel"]   = { dv = function() return "choices/35/lukas/you_could_travel"      end, post = ep5_end },
	["c35/founder/build"]  = { dv = function() return "choices/35/founder/build_something_new" end, post = ep5_end },
	["c35/founder/travel"] = { dv = function() return "choices/35/founder/you_could_travel"    end, post = ep5_end },
}

local current = ep5_node or "start"
ep5_node = nil
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
		if node.post then node.post(); break end
		if node.sq then
			local sq_txt = resolve_label(node.sq)
			local ci_txt = resolve_label(node.ci)
			ep5_node = current
			nextscene = EP_FILE
			ui2(sq_txt, ci_txt)
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
					ui2(sq_txt, ci_txt)
				elseif buttons.pressed(buttons.r) then
					SaveGame(5)
				end
			end
		elseif node.n then
			current = node.n
		else
			break
		end
	end
end
