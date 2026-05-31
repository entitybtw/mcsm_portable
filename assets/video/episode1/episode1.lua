-- Episode 1: "The Order of the Stone"
-- Single data-driven file: all nodes, choices, and interactive zones.

local V = "assets/video/episode1/"
local S = "assets/subtitles/episode1/"
local EP_FILE = "assets/video/episode1/episode1.lua"

-- Play a video+subtitle clip. Returns true if user quit to main menu.
local function pv(rel)
	PMP.setVolume(pmpvolume)
	local r = PMP.playExt(
		V .. rel .. ".pmp", buttons.r, true,
		S .. rel .. ".srt", subs_font, subssize,
		"#FFFFFF", "#000000/110", subs
	)
	System.GC()  -- match per-scene GC from the main script.lua loop
	if r == 1 then
		nextscene = "./mainmenu.lua"
		return true
	end
	return false
end

-- Draw standard 2-choice UI (square=left, circle=right).
local function ui2(lk, rk)
	Image.draw(spritesheet, 25,  127, 15, 15, nil, 414, 0, 15, 15)
	Image.draw(spritesheet, 455, 127, 15, 15, nil, 384, 0, 15, 15)
	intraFont.print(45, 127, choices_one[lk], Color.new(255, 255, 255), font, 2)
	intraFont.print(450 - intraFont.textW(font, choices_one[rk], 2), 127,
		choices_one[rk], Color.new(255, 255, 255), font, 2)
	intraFont.print(240 - intraFont.textW(font, ui.save, 2) / 2, 230,
		ui.save, Color.new(255, 255, 255, 150), font, 2)
	debugoverlay.draw()
	screen.flip()
end

-- Draw 3-choice UI (square=left, circle=right, triangle=bottom-left).
local function ui3(sk, ck, tk)
	Image.draw(spritesheet, 25,  127, 15, 15, nil, 414, 0, 15, 15)
	Image.draw(spritesheet, 455, 127, 15, 15, nil, 384, 0, 15, 15)
	Image.draw(spritesheet, 140, 182, 15, 15, nil, 430, 0, 15, 15)
	intraFont.print(45, 127, choices_one[sk], Color.new(255, 255, 255), font, 2)
	intraFont.print(450 - intraFont.textW(font, choices_one[ck], 2), 127,
		choices_one[ck], Color.new(255, 255, 255), font, 2)
	intraFont.print(140 + 15 + 5, 182, choices_one[tk], Color.new(255, 255, 255), font, 2)
	intraFont.print(240 - intraFont.textW(font, ui.save, 2) / 2, 230,
		ui.save, Color.new(255, 255, 255, 150), font, 2)
	debugoverlay.draw()
	screen.flip()
end

-- ===== INTERACTIVE ZONES =====
-- Each returns the ID of the next node, or nil on quit (nextscene already set).

local function zone_woods()
	local bg = Image.load(V .. "choices/6/the_woods_zone.png")
	local bush_used, pigs_used, water_well_used, smoke_trail_used = false, false, false, false
	local in_zone, next_node = true, nil

	local function clip(rel)
		PMP.setVolume(pmpvolume)
		local r = PMP.playExt(V .. rel .. ".pmp", buttons.r, true,
			S .. rel .. ".srt", font, subssize, "#FFFFFF", "#000000/110", subs)
		System.GC()
		if r == 1 then in_zone = false; nextscene = "./mainmenu.lua" end
	end

	while in_zone do
		screen.clear()
		Image.draw(bg, 0, 0)

		if not smoke_trail_used then
			Image.draw(spritesheet, 257, 136, 15, 15, nil, 399, 0, 15, 15)
			intraFont.print(257 - intraFont.textW(font, choices_one.smoke_trail, 1.5)/2 + 8, 150,
				choices_one.smoke_trail, Color.new(255, 255, 255), font, 1.5)
		else
			Image.draw(spritesheet, 201, 130, 15, 15, nil, 399, 0, 15, 15)
			intraFont.print(201 - intraFont.textW(font, choices_one.tall_grass, 1.5)/2 + 8, 144,
				choices_one.tall_grass, Color.new(255, 255, 255), font, 1.5)
		end
		if not pigs_used then
			Image.draw(spritesheet, 389, 193, 15, 15, nil, 430, 0, 15, 15)
			intraFont.print(389 - intraFont.textW(font, choices_one.pigs, 1.5)/2 + 8, 207,
				choices_one.pigs, Color.new(255, 255, 255), font, 1.5)
		end
		if not bush_used then
			Image.draw(spritesheet, 88, 63, 15, 15, nil, 414, 0, 15, 15)
			intraFont.print(88 - intraFont.textW(font, choices_one.bush, 1.5)/2 + 8, 77,
				choices_one.bush, Color.new(255, 255, 255), font, 1.5)
		end
		if not water_well_used then
			Image.draw(spritesheet, 95, 167, 15, 15, nil, 384, 0, 15, 15)
			intraFont.print(95 - intraFont.textW(font, choices_one.water_well, 1.5)/2 + 8, 181,
				choices_one.water_well, Color.new(255, 255, 255), font, 1.5)
		end
		intraFont.print(240 - intraFont.textW(font, ui.save, 0.63)/2, 230,
			ui.save, Color.new(255, 255, 255, 150), font, 0.63)
		debugoverlay.draw()
		screen.flip()

		local picking = true
		while picking do
			buttons.read()
			if buttons.pressed(buttons.cross) then
				if not smoke_trail_used then
					clip("choices/6/smoke_trail"); smoke_trail_used = true; picking = false
				else
					in_zone = false; picking = false; next_node = "tall_grass"
				end
			elseif buttons.pressed(buttons.square) then
				if not bush_used then clip("choices/6/bush"); bush_used = true; picking = false end
			elseif buttons.pressed(buttons.circle) then
				if not water_well_used then clip("choices/6/water_well"); water_well_used = true; picking = false end
			elseif buttons.pressed(buttons.triangle) then
				if not pigs_used then clip("choices/6/pigs"); pigs_used = true; picking = false end
			elseif buttons.pressed(buttons.start) then
				local p = dofile("assets/misc/pause.lua"); picking = false
				if p == -1 then in_zone = false; nextscene = "./mainmenu.lua" end
			elseif buttons.pressed(buttons.r) then
				ep1_node = "woods_zone"; nextscene = EP_FILE; SaveGame(1)
			end
		end
	end

	Image.unload(bg)
	return next_node
end

local function zone_endercon()
	local bg = Image.load(V .. "choices/16/endercon_zone.png")
	local slime_used, chicken_machine_used, crafting_table_used, pigs_used = false, false, false, false
	local in_zone, next_node = true, nil

	local function clip(rel)
		PMP.setVolume(pmpvolume)
		local r = PMP.playExt(V .. rel .. ".pmp", buttons.r, true,
			S .. rel .. ".srt", font, subssize, "#FFFFFF", "#000000/110", subs)
		System.GC()
		if r == 1 then in_zone = false; nextscene = "./mainmenu.lua" end
	end

	while in_zone do
		screen.clear()
		Image.draw(bg, 0, 0)

		if not slime_used then
			Image.draw(spritesheet, 141, 139, 15, 15, nil, 384, 0, 15, 15)
			intraFont.print(141 - intraFont.textW(font, choices_one.slime, 1.5)/2 + 8, 153,
				choices_one.slime, Color.new(255, 255, 255), font, 1.5)
		end
		if not chicken_machine_used then
			Image.draw(spritesheet, 221, 122, 15, 15, nil, 414, 0, 15, 15)
			intraFont.print(221 - intraFont.textW(font, choices_one.chicken_machine, 1.5)/2 + 8, 136,
				choices_one.chicken_machine, Color.new(255, 255, 255), font, 1.5)
		else
			Image.draw(spritesheet, 221, 122, 15, 15, nil, 414, 0, 15, 15)
			intraFont.print(221 - intraFont.textW(font, "Chicken Machine 2", 1.5)/2 + 8, 136,
				"Chicken Machine 2", Color.new(255, 255, 255), font, 1.5)
		end
		if slime_used and not crafting_table_used then
			Image.draw(spritesheet, 334, 153, 15, 15, nil, 384, 0, 15, 15)
			intraFont.print(334 - intraFont.textW(font, choices_one.crafting_table, 1.5)/2 + 8, 167,
				choices_one.crafting_table, Color.new(255, 255, 255), font, 1.5)
		end
		if slime_used then
			Image.draw(spritesheet, 141, 139, 15, 15, nil, 399, 0, 15, 15)
			intraFont.print(141 - intraFont.textW(font, choices_one.lukas, 1.5)/2 + 8, 153,
				choices_one.lukas, Color.new(255, 255, 255), font, 1.5)
		end
		intraFont.print(240 - intraFont.textW(font, ui.save, 0.63)/2, 230,
			ui.save, Color.new(255, 255, 255, 150), font, 0.63)
		debugoverlay.draw()
		screen.flip()

		local picking = true
		while picking do
			buttons.read()
			if buttons.pressed(buttons.cross) then
				if slime_used then in_zone = false; picking = false; next_node = "c16/lukas" end
			elseif buttons.pressed(buttons.square) then
				if not chicken_machine_used then
					clip("choices/16/chicken_machine"); chicken_machine_used = true; picking = false
				else
					clip("choices/16/chicken_machine_2"); picking = false
				end
			elseif buttons.pressed(buttons.circle) then
				if not slime_used then
					clip("choices/16/slime"); slime_used = true; picking = false
				elseif not crafting_table_used then
					clip("choices/16/crafting_table"); crafting_table_used = true; picking = false
				end
			elseif buttons.pressed(buttons.triangle) then
				if not pigs_used then clip("choices/16/pigs"); pigs_used = true; picking = false end
			elseif buttons.pressed(buttons.start) then
				local p = dofile("assets/misc/pause.lua"); picking = false
				if p == -1 then in_zone = false; nextscene = "./mainmenu.lua" end
			elseif buttons.pressed(buttons.r) then
				ep1_node = "endercon_zone"; nextscene = EP_FILE; SaveGame(1)
			end
		end
	end

	Image.unload(bg)
	return next_node
end

local function zone_temple()
	local bg          = Image.load(V .. "choices/36/the_temple_zone.png")
	local bg_pedestal = Image.load(V .. "choices/36/the_temple_zone_pedestal.png")
	local lukas_talk, axel_talk, olivia_talk, pedestal_used = false, false, false, false
	local in_zone, next_node = true, nil

	local function clip(rel)
		PMP.setVolume(pmpvolume)
		local r = PMP.playExt(V .. rel .. ".pmp", buttons.r, true,
			S .. rel .. ".srt", font, subssize, "#FFFFFF", "#000000/110", subs)
		System.GC()
		if r == 1 then in_zone = false; nextscene = "./mainmenu.lua" end
	end

	while in_zone do
		screen.clear()
		Image.draw(pedestal_used and bg_pedestal or bg, 0, 0)

		if not olivia_talk then
			Image.draw(spritesheet, 305, 157, 15, 15, nil, 430, 0, 15, 15)
			intraFont.print(305 - intraFont.textW(font, choices_one.olivia, 1.5)/2 + 8, 171,
				choices_one.olivia, Color.new(255, 255, 255), font, 1.5)
		end
		if not axel_talk then
			Image.draw(spritesheet, 123, 161, 15, 15, nil, 414, 0, 15, 15)
			intraFont.print(123 - intraFont.textW(font, choices_one.axel, 1.5)/2 + 8, 175,
				choices_one.axel, Color.new(255, 255, 255), font, 1.5)
		end
		if not lukas_talk then
			Image.draw(spritesheet, 174, 153, 15, 15, nil, 384, 0, 15, 15)
			intraFont.print(174 - intraFont.textW(font, choices_one.lukas, 1.5)/2 + 8, 167,
				choices_one.lukas, Color.new(255, 255, 255), font, 1.5)
		end
		if not pedestal_used then
			Image.draw(spritesheet, 243, 139, 15, 15, nil, 399, 0, 15, 15)
			intraFont.print(243 - intraFont.textW(font, choices_one.pedestal, 1.5)/2 + 8, 153,
				choices_one.pedestal, Color.new(255, 255, 255), font, 1.5)
		else
			Image.draw(spritesheet, 392, 183, 15, 15, nil, 399, 0, 15, 15)
			intraFont.print(392 - intraFont.textW(font, choices_one.levers, 1.5)/2 + 8, 197,
				choices_one.levers, Color.new(255, 255, 255), font, 1.5)
		end
		intraFont.print(240 - intraFont.textW(font, ui.save, 0.63)/2, 230,
			ui.save, Color.new(255, 255, 255, 150), font, 0.63)
		debugoverlay.draw()
		screen.flip()

		local picking = true
		while picking do
			buttons.read()
			if buttons.pressed(buttons.cross) then
				if not pedestal_used then
					clip("choices/36/pedestal"); pedestal_used = true; picking = false
				else
					in_zone = false; picking = false; next_node = "c36/levers"
				end
			elseif buttons.pressed(buttons.square) then
				if not axel_talk then
					clip(pedestal_used and "choices/36/axel_pedestal" or "choices/36/axel")
					axel_talk = true; picking = false
				end
			elseif buttons.pressed(buttons.circle) then
				if not lukas_talk then
					clip(pedestal_used and "choices/36/lukas_pedestal" or "choices/36/lukas")
					lukas_talk = true; picking = false
				end
			elseif buttons.pressed(buttons.triangle) then
				if not olivia_talk then
					clip(pedestal_used and "choices/36/olivia_pedestal" or "choices/36/olivia")
					olivia_talk = true; picking = false
				end
			elseif buttons.pressed(buttons.start) then
				local p = dofile("assets/misc/pause.lua"); picking = false
				if p == -1 then in_zone = false; nextscene = "./mainmenu.lua" end
			elseif buttons.pressed(buttons.r) then
				ep1_node = "temple_zone"; nextscene = EP_FILE; SaveGame(1)
			end
		end
	end

	Image.unload(bg)
	Image.unload(bg_pedestal)
	return next_node
end

-- ===== NODE GRAPH =====
-- Each node:
--   v   = relative video/subtitle path (no extension)
--   dv  = function() returning v  (for dynamic paths)
--   pre = function()  runs before video  (side-effects: variable assignments)
--   sq  = { k=text_key, n=next_id [, fn=side_effect] }   square button
--   ci  = { k=text_key, n=next_id [, fn=side_effect] }   circle button
--   tr  = { k=text_key, n=next_id [, fn=side_effect] }   triangle button (3-choice)
--   n   = next_id   (no choice, just navigate)
--   post= function() runs after video instead of navigating (episode endings)
--   zone= function() interactive zone, returns next_id

local nodes = {

	["start"] = {
		v  = "START",
		sq = { k="hundred_chicken_sized", n="100cs" },
		ci = { k="ten_zombie_sized",      n="10zs"  },
	},

	["100cs"] = {
		v  = "100_chicken_sized",
		sq = { k="cool_mask",      n="cool_mask"      },
		ci = { k="not_funny_axel", n="not_funny_axel" },
	},
	["10zs"] = {
		v  = "10_zombie_sized",
		sq = { k="cool_mask",      n="cool_mask"      },
		ci = { k="not_funny_axel", n="not_funny_axel" },
	},

	["cool_mask"] = {
		v  = "choices/cool_mask",
		sq = { k="gabriel_is_awesome", n="c1/gabriel"   },
		ci = { k="no_big_deal",        n="c1/no_big_deal" },
	},
	["not_funny_axel"] = {
		v  = "choices/not_funny_axel",
		sq = { k="gabriel_is_awesome", n="c1/gabriel"   },
		ci = { k="no_big_deal",        n="c1/no_big_deal" },
	},

	["c1/gabriel"] = {
		v  = "choices/1/gabriel_is_awesome",
		sq = { k="build_a_creeper",  n="c2/creeper"  },
		ci = { k="build_a_enderman", n="c2/enderman" },
	},
	["c1/no_big_deal"] = {
		v  = "choices/1/no_big_deal",
		sq = { k="build_a_creeper",  n="c2/creeper"  },
		ci = { k="build_a_enderman", n="c2/enderman" },
	},

	-- Build choice branches (building variable set BEFORE video)
	["c2/creeper"] = {
		pre = function() building = "creeper" end,
		v  = "choices/2/build_a_creeper",
		sq = { k="dead_enders",      n="c3c/dead_enders"      },
		ci = { k="nether_maniacs",   n="c3c/nether_maniacs"   },
		tr = { k="order_of_the_pig", n="c3c/order_of_the_pig" },
	},
	["c2/enderman"] = {
		pre = function() building = "enderman" end,
		v  = "choices/2/build_a_enderman",
		sq = { k="dead_enders",      n="c3/dead_enders"      },
		ci = { k="nether_maniacs",   n="c3/nether_maniacs"   },
		tr = { k="order_of_the_pig", n="c3/order_of_the_pig" },
	},

	-- Creeper branch: deeper nesting
	["c3c/dead_enders"] = {
		v  = "choices/3/creeper/dead_enders",
		sq = { k="may_the_best_team_win", n="c3c4/may"   },
		ci = { k="we_going_to_crush_you", n="c3c4/crush" },
	},
	["c3c/nether_maniacs"] = {
		v  = "choices/3/creeper/nether_maniacs",
		sq = { k="may_the_best_team_win", n="c3c4/may"   },
		ci = { k="we_going_to_crush_you", n="c3c4/crush" },
	},
	["c3c/order_of_the_pig"] = {
		v  = "choices/3/creeper/order_of_the_pig",
		sq = { k="may_the_best_team_win", n="c3c4/may"   },
		ci = { k="we_going_to_crush_you", n="c3c4/crush" },
	},
	["c3c4/may"] = {
		v  = "choices/3/creeper/4/may_the_best_team_win",
		sq = { k="redstone_rap", n="c3c45/redstone" },
		ci = { k="warrior_whip", n="c3c45/warrior"  },
	},
	["c3c4/crush"] = {
		v  = "choices/3/creeper/4/we_going_to_crush_you",
		sq = { k="redstone_rap", n="c3c45/redstone" },
		ci = { k="warrior_whip", n="c3c45/warrior"  },
	},
	["c3c45/redstone"] = { v="choices/3/creeper/4/5/redstone_rap", n="woods_zone" },
	["c3c45/warrior"]  = { v="choices/3/creeper/4/5/warrior_whip",  n="woods_zone" },

	-- Enderman branch
	["c3/dead_enders"] = {
		v  = "choices/3/dead_enders",
		sq = { k="may_the_best_team_win", n="c4/may"   },
		ci = { k="we_going_to_crush_you", n="c4/crush" },
	},
	["c3/nether_maniacs"] = {
		v  = "choices/3/nether_maniacs",
		sq = { k="may_the_best_team_win", n="c4/may"   },
		ci = { k="we_going_to_crush_you", n="c4/crush" },
	},
	["c3/order_of_the_pig"] = {
		v  = "choices/3/order_of_the_pig",
		sq = { k="may_the_best_team_win", n="c4/may"   },
		ci = { k="we_going_to_crush_you", n="c4/crush" },
	},
	["c4/may"] = {
		pre = function() building = "enderman" end,
		v  = "choices/4/may_the_best_team_win",
		sq = { k="redstone_rap", n="c5/redstone" },
		ci = { k="warrior_whip", n="c5/warrior"  },
	},
	["c4/crush"] = {
		pre = function() building = "enderman" end,
		v  = "choices/4/we_going_to_crush_you",
		sq = { k="redstone_rap", n="c5/redstone" },
		ci = { k="warrior_whip", n="c5/warrior"  },
	},
	["c5/redstone"] = { v="choices/5/redstone_rap", n="woods_zone" },
	["c5/warrior"]  = { v="choices/5/warrior_whip",  n="woods_zone" },

	-- === Interactive Zone 1: The Woods ===
	["woods_zone"] = { zone=zone_woods },

	-- Tall Grass: sets reuben default, choice may override
	["tall_grass"] = {
		pre = function() reuben = "reuben" end,
		v   = "choices/6/tall_grass",
		sq  = { k="run_i_distract_them",      n="c7/run",
		        fn=function() reuben = "noreuben" end },
		ci  = { k="stay_close_i_protect_you", n="c7/stay" },
	},

	["c7/run"] = {
		v  = "choices/7/run_i_distract_them",
		sq = { k="im_all_in",          n="c8/all_in" },
		ci = { k="whats_in_it_for_me", n="c8/whats"  },
	},
	["c7/stay"] = {
		v  = "choices/7/stay_close_i_protect_you",
		sq = { k="im_all_in",          n="c8/all_in" },
		ci = { k="whats_in_it_for_me", n="c8/whats"  },
	},

	["c8/all_in"] = {
		v  = "choices/8/im_all_in",
		sq = { k="lever",       n="c9/lever" },
		ci = { k="stone_sword", n="c9/stone" },
	},
	["c8/whats"] = {
		v  = "choices/8/whats_in_it_for_me",
		sq = { k="lever",       n="c9/lever" },
		ci = { k="stone_sword", n="c9/stone" },
	},

	["c9/lever"] = {
		v  = "choices/9/lever",
		sq = { k="fight", n="c10/fight" },
		ci = { k="jump",  n="c10/jump"  },
	},
	["c9/stone"] = {
		v  = "choices/9/stone_sword",
		sq = { k="fight", n="c10/fight" },
		ci = { k="jump",  n="c10/jump"  },
	},

	["c10/fight"] = {
		v  = "choices/10/fight",
		sq = { k="party_time",   n="c11/party" },
		ci = { k="proud_of_you", n="c11/proud" },
	},
	["c10/jump"] = {
		v  = "choices/10/jump",
		sq = { k="party_time",   n="c11/party" },
		ci = { k="proud_of_you", n="c11/proud" },
	},

	["c11/party"] = {
		v  = "choices/11/party_time",
		sq = { k="im_jesse",   n="c12/jesse" },
		ci = { k="who_are_you", n="c12/who"  },
	},
	["c11/proud"] = {
		v  = "choices/11/proud_of_you",
		sq = { k="im_jesse",   n="c12/jesse" },
		ci = { k="who_are_you", n="c12/who"  },
	},

	["c12/jesse"] = {
		v  = "choices/12/im_jesse",
		sq = { k="got_a_bad_feeling", n="c13/bad"  },
		ci = { k="im_cool_if_he_is",  n="c13/cool" },
	},
	["c12/who"] = {
		v  = "choices/12/who_are_you",
		sq = { k="got_a_bad_feeling", n="c13/bad"  },
		ci = { k="im_cool_if_he_is",  n="c13/cool" },
	},

	["c13/bad"] = {
		v  = "choices/13/got_a_bad_feeling",
		sq = { k="your_friend_hurt_my_pig", n="c14/pig"  },
		ci = { k="your_machine_was_cool",   n="c14/cool" },
	},
	["c13/cool"] = {
		v  = "choices/13/im_cool_if_he_is",
		sq = { k="your_friend_hurt_my_pig", n="c14/pig"  },
		ci = { k="your_machine_was_cool",   n="c14/cool" },
	},

	["c14/pig"] = {
		v  = "choices/14/your_friend_hurt_my_pig",
		sq = { k="offer_sword", n="c15/offer"  },
		ci = { k="threaten",    n="c15/threat" },
	},
	["c14/cool"] = {
		v  = "choices/14/your_machine_was_cool",
		sq = { k="offer_sword", n="c15/offer"  },
		ci = { k="threaten",    n="c15/threat" },
	},

	-- Dynamic video paths (depend on reuben variable set in tall_grass)
	["c15/offer"] = {
		pre = function() sword = "" end,
		dv  = function() return "choices/15/offer_sword_" .. reuben end,
		n   = "endercon_zone",
	},
	["c15/threat"] = {
		pre = function() sword = "_sword" end,
		dv  = function() return "choices/15/threaten_" .. reuben end,
		n   = "endercon_zone",
	},

	-- === Interactive Zone 2: Endercon ===
	["endercon_zone"] = { zone=zone_endercon },

	["c16/lukas"] = {
		v  = "choices/16/lukas",
		sq = { k="we_ask_politely", n="c17/polite"  },
		ci = { k="we_get_payback",  n="c17/payback" },
	},

	["c17/polite"] = {
		v  = "choices/17/we_ask_politely",
		sq = { k="its_all_yours",  n="c18/all_yours" },
		ci = { k="leave_it_alone", n="c18/leave"     },
	},
	["c17/payback"] = {
		v  = "choices/17/we_get_payback",
		sq = { k="its_all_yours",  n="c18/all_yours" },
		ci = { k="leave_it_alone", n="c18/leave"     },
	},

	["c18/all_yours"] = {
		v  = "choices/18/its_all_yours",
		sq = { k="stay_quiet",  n="c19/quiet" },
		ci = { k="warn_olivia", n="c19/warn"  },
	},
	["c18/leave"] = {
		v  = "choices/18/leave_it_alone",
		sq = { k="stay_quiet",  n="c19/quiet" },
		ci = { k="warn_olivia", n="c19/warn"  },
	},

	["c19/quiet"] = {
		v  = "choices/19/stay_quiet",
		sq = { k="im_going_after_lukas", n="c20/lukas"   },
		ci = { k="lets_talk_to_gabriel", n="c20/gabriel" },
	},
	["c19/warn"] = {
		v  = "choices/19/warn_olivia",
		sq = { k="im_going_after_lukas", n="c20/lukas"   },
		ci = { k="lets_talk_to_gabriel", n="c20/gabriel" },
	},

	["c20/lukas"] = {
		v  = "choices/20/im_going_after_lukas",
		sq = { k="run_for_it", n="c20al/run" },
		ci = { k="sit_tight",  n="c20al/sit" },
	},
	["c20/gabriel"] = {
		v  = "choices/20/lets_talk_to_gabriel",
		sq = { k="somebody_stop_him", n="c21/stop" },
		ci = { k="this_cant_be_good", n="c21/good" },
	},
	["c20al/run"] = {
		v  = "choices/20/after_lukas/run_for_it",
		sq = { k="somebody_stop_him", n="c21/stop" },
		ci = { k="this_cant_be_good", n="c21/good" },
	},
	["c20al/sit"] = {
		v  = "choices/20/after_lukas/sit_tight",
		sq = { k="somebody_stop_him", n="c21/stop" },
		ci = { k="this_cant_be_good", n="c21/good" },
	},

	["c21/stop"] = {
		v  = "choices/21/somebody_stop_him",
		sq = { k="he_cant_stop_it",    n="c22/cant" },
		ci = { k="what_are_you_doing", n="c22/what" },
	},
	["c21/good"] = {
		v  = "choices/21/this_cant_be_good",
		sq = { k="he_cant_stop_it",    n="c22/cant" },
		ci = { k="what_are_you_doing", n="c22/what" },
	},

	["c22/cant"] = {
		v  = "choices/22/he_cant_stop_it",
		sq = { k="follow_gabriel", n="c23/gabriel" },
		ci = { k="help_lukas",     n="c23/lukas"   },
	},
	["c22/what"] = {
		v  = "choices/22/what_are_you_doing",
		sq = { k="follow_gabriel", n="c23/gabriel" },
		ci = { k="help_lukas",     n="c23/lukas"   },
	},

	["c23/gabriel"] = {
		v  = "choices/23/follow_gabriel",
		sq = { k="but_why_me",    n="c24/why"   },
		ci = { k="where_are_they", n="c24/where" },
	},
	["c23/lukas"] = {
		v  = "choices/23/help_lukas",
		sq = { k="but_why_me",    n="c24/why"   },
		ci = { k="where_are_they", n="c24/where" },
	},

	["c24/why"] = {
		v  = "choices/24/but_why_me",
		sq = { k="save_gabriel", n="c25/gabriel" },
		ci = { k="save_petra",   n="c25/petra"   },
	},
	["c24/where"] = {
		v  = "choices/24/where_are_they",
		sq = { k="save_gabriel", n="c25/gabriel" },
		ci = { k="save_petra",   n="c25/petra"   },
	},

	["c25/gabriel"] = {
		v  = "choices/25/save_gabriel",
		sq = { k="its_your_fault",     n="c26/fault" },
		ci = { k="petra_will_make_it", n="c26/make"  },
	},
	["c25/petra"] = {
		v  = "choices/25/save_petra",
		sq = { k="its_your_fault",     n="c26/fault" },
		ci = { k="petra_will_make_it", n="c26/make"  },
	},

	["c26/fault"] = {
		v  = "choices/26/its_your_fault",
		sq = { k="hands_in_the_air", n="c27/hands" },
		ci = { k="hold_on_tight",    n="c27/hold"  },
	},
	["c26/make"] = {
		v  = "choices/26/petra_will_make_it",
		sq = { k="hands_in_the_air", n="c27/hands" },
		ci = { k="hold_on_tight",    n="c27/hold"  },
	},

	["c27/hands"] = {
		v  = "choices/27/hands_in_the_air",
		sq = { k="it_was_fine",   n="c28/fine"  },
		ci = { k="yeah_its_awful", n="c28/awful" },
	},
	["c27/hold"] = {
		v  = "choices/27/hold_on_tight",
		sq = { k="it_was_fine",   n="c28/fine"  },
		ci = { k="yeah_its_awful", n="c28/awful" },
	},

	["c28/fine"] = {
		v  = "choices/28/it_was_fine",
		sq = { k="i_go_first",    n="c29/first" },
		ci = { k="you_can_do_it", n="c29/you"   },
	},
	["c28/awful"] = {
		v  = "choices/28/yeah_its_awful",
		sq = { k="i_go_first",    n="c29/first" },
		ci = { k="you_can_do_it", n="c29/you"   },
	},

	["c29/first"] = {
		v  = "choices/29/i_go_first",
		sq = { k="build_a_dirt_hut",  n="c30/dirt" },
		ci = { k="build_a_treehouse", n="c30/tree" },
	},
	["c29/you"] = {
		v  = "choices/29/you_can_do_it",
		sq = { k="build_a_dirt_hut",  n="c30/dirt" },
		ci = { k="build_a_treehouse", n="c30/tree" },
	},

	-- Shelter branch: dirt hut path
	["c30/dirt"] = {
		v  = "choices/30/build_a_dirt_hut",
		sq = { k="give_cookie", n="c31/give" },
		ci = { k="keep_cookie", n="c31/keep" },
	},
	["c31/give"] = {
		v  = "choices/31/give_cookie",
		sq = { k="stay_here",    n="c32/stay" },
		ci = { k="you_should_go", n="c32/go"  },
	},
	["c31/keep"] = {
		v  = "choices/31/keep_cookie",
		sq = { k="stay_here",    n="c32/stay" },
		ci = { k="you_should_go", n="c32/go"  },
	},
	["c32/stay"] = {
		v  = "choices/32/stay_here",
		sq = { k="craft_a_bow",          n="c34/bow"  },
		ci = { k="craft_a_fishing_pole", n="c34/fish" },
	},
	["c32/go"] = {
		v  = "choices/32/you_should_go",
		sq = { k="all_is_good",        n="c33/good" },
		ci = { k="keep_your_distance", n="c33/dist" },
	},

	-- Shelter branch: treehouse path
	["c30/tree"] = {
		v  = "choices/30/build_a_treehouse",
		sq = { k="give_cookie", n="c30t/give" },
		ci = { k="keep_cookie", n="c30t/keep" },
	},
	["c30t/give"] = {
		v  = "choices/30/treehouse/give_cookie",
		sq = { k="stay_here",    n="c30t31/stay" },
		ci = { k="you_should_go", n="c30t31/go"  },
	},
	["c30t/keep"] = {
		v  = "choices/30/treehouse/keep_cookie",
		sq = { k="stay_here",    n="c30t31/stay" },
		ci = { k="you_should_go", n="c30t31/go"  },
	},
	["c30t31/stay"] = {
		v  = "choices/30/treehouse/31/stay_here",
		sq = { k="craft_a_bow",          n="c34/bow"  },
		ci = { k="craft_a_fishing_pole", n="c34/fish" },
	},
	["c30t31/go"] = {
		v  = "choices/30/treehouse/31/you_should_go",
		sq = { k="all_is_good",        n="c33/good" },
		ci = { k="keep_your_distance", n="c33/dist" },
	},

	-- Merge back
	["c33/good"] = {
		v  = "choices/33/all_is_good",
		sq = { k="craft_a_bow",          n="c34/bow"  },
		ci = { k="craft_a_fishing_pole", n="c34/fish" },
	},
	["c33/dist"] = {
		v  = "choices/33/keep_your_distance",
		sq = { k="craft_a_bow",          n="c34/bow"  },
		ci = { k="craft_a_fishing_pole", n="c34/fish" },
	},

	["c34/bow"] = {
		v  = "choices/34/craft_a_bow",
		sq = { k="ivor_isnt_a_hero",    n="c35/ivor"     },
		ci = { k="this_explains_a_lot", n="c35/explains" },
	},
	["c34/fish"] = {
		v  = "choices/34/craft_a_fishing_pole",
		sq = { k="ivor_isnt_a_hero",    n="c35/ivor"     },
		ci = { k="this_explains_a_lot", n="c35/explains" },
	},

	["c35/ivor"]     = { v="choices/35/ivor_isnt_a_hero",    n="temple_zone" },
	["c35/explains"] = { v="choices/35/this_explains_a_lot", n="temple_zone" },

	-- === Interactive Zone 3: The Temple ===
	["temple_zone"] = { zone=zone_temple },

	["c36/levers"] = {
		v  = "choices/36/levers",
		sq = { k="go_for_magnus",    n="c37/magnus",
		       fn=function() wr("em","magnus"); pedestal=nil; temple_script=nil end },
		ci = { k="go_for_ellegaard", n="c37/ellegaard",
		       fn=function() wr("em","ellegaard"); pedestal=nil; temple_script=nil end },
	},

	-- Episode endings: play video then credits, return to main menu
	["c37/magnus"] = {
		pre  = function() wr("1_status","restart") end,
		v    = "choices/37/go_for_magnus",
		post = function()
			PMP.setVolume(pmpvolume)
			System.GC()
			PMP.playExt("assets/video/credits/ep1.pmp", buttons.start)
			nextscene = "./mainmenu.lua"
		end,
	},
	["c37/ellegaard"] = {
		pre  = function() wr("1_status","restart") end,
		v    = "choices/37/go_for_ellegaard",
		post = function()
			PMP.setVolume(pmpvolume)
			System.GC()
			PMP.playExt("assets/video/credits/ep1.pmp", buttons.start)
			nextscene = "./mainmenu.lua"
		end,
	},
}

-- ===== MAIN EPISODE LOOP =====

local current = ep1_node or "start"
ep1_node = nil  -- clear so stale value isn't re-used on next entry

while true do
	System.PowerTick()  -- PSP power management, matches script.lua main loop
	local node = nodes[current]
	if not node then break end

	-- Pre-video side-effects (variable assignments)
	if node.pre then node.pre() end

	-- Interactive zone: hand over control, get next node back
	if node.zone then
		current = node.zone()
		if nextscene == "./mainmenu.lua" then return 1 end
		if not current then break end

	else
		-- Play video clip
		local vpath = node.dv and node.dv() or node.v
		if vpath and pv(vpath) then return 1 end

		-- Post-video action (episode endings handle their own navigation)
		if node.post then
			node.post()
			break
		end

		-- Choice or simple pass-through
		if node.sq then
			-- Render choice UI
			if node.tr then
				ui3(node.sq.k, node.ci.k, node.tr.k)
			else
				ui2(node.sq.k, node.ci.k)
			end

			-- Arm save point: R will save at current node
			ep1_node  = current
			nextscene = EP_FILE

			local chose = false
			while not chose do
				buttons.read()
				if buttons.pressed(buttons.square) then
					if node.sq.fn then node.sq.fn() end
					current = node.sq.n
					chose = true
				elseif buttons.pressed(buttons.circle) then
					if node.ci.fn then node.ci.fn() end
					current = node.ci.n
					chose = true
				elseif node.tr and buttons.pressed(buttons.triangle) then
					if node.tr.fn then node.tr.fn() end
					current = node.tr.n
					chose = true
				elseif buttons.pressed(buttons.start) then
					local p = dofile("assets/misc/pause.lua")
					if p == -1 then
						nextscene = "./mainmenu.lua"
						return 1
					end
					-- Redraw after returning from pause menu
					if node.tr then
						ui3(node.sq.k, node.ci.k, node.tr.k)
					else
						ui2(node.sq.k, node.ci.k)
					end
				elseif buttons.pressed(buttons.r) then
					SaveGame(1)
				end
			end

		elseif node.n then
			current = node.n
		else
			break
		end
	end
end
