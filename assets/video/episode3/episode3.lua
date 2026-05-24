local V = "assets/video/episode3/"
local S = "assets/subtitles/episode3/"
local EP_FILE = "assets/video/episode3/episode3.lua"

local _vf = io.open("assets/saves/3_variables.txt", "r")
if _vf then
	for line in _vf:lines() do
		local k, v = line:match('^(%w+)%s*=%s*"([^"]*)"')
		if k and v then _G[k] = v end
	end
	_vf:close()
end
_vf = nil
checkFile("assets/saves/gp.txt", "gp")

local function pv(rel)
	PMP.setVolume(pmpvolume)
	local r = PMP.playExt(V..rel..".pmp", buttons.r, true,
		S..rel..".srt", subs_font, subssize, "#FFFFFF", "#000000/110", subs)
	System.GC()
	if r == 1 then nextscene = "./mainmenu.lua"; return true end
	return false
end

local function resolve_label(entry)
	if entry.rl then return entry.rl end
	if entry.dk then return choices_three[entry.dk()] end
	return choices_three[entry.k]
end

local function ui2(ltxt, rtxt)
	Image.draw(spritesheet, 25, 127, 15, 15, nil, 414, 0, 15, 15)
	Image.draw(spritesheet, 455, 127, 15, 15, nil, 384, 0, 15, 15)
	intraFont.print(45, 127, ltxt, Color.new(255, 255, 255), font, 2)
	intraFont.print(450 - intraFont.textW(font, rtxt, 2), 127, rtxt, Color.new(255, 255, 255), font, 2)
	intraFont.print(240 - intraFont.textW(font, ui.save, 2) / 2, 230, ui.save, Color.new(255, 255, 255, 150), font, 2)
	debugoverlay.draw(debugoverlay.loadSettings())
	screen.flip()
end

local function zone_woolland(branch)
	local B = V..branch.."/choices/8/"
	local Bs = S..branch.."/choices/8/"
	local npc_k = branch
	local lev_k = "lever"..branch
	local bg = Image.load(B.."woolland.png")
	local bg_lev = Image.load(B.."woolland_"..lev_k..".png")
	local fountain_used, npc_talk, reuben_talk, leverreuben_used, lever_used = false, false, false, false, false
	local in_zone = true
	local ret = nil

	local function pc(rel)
		PMP.setVolume(pmpvolume)
		local r = PMP.playExt(B..rel..".pmp", buttons.r, true, Bs..rel..".srt", font, subssize, "#FFFFFF", "#000000/110", subs)
		System.GC()
		if r == 1 then nextscene = "./mainmenu.lua"; in_zone = false end
		return r == 1
	end

	while in_zone do
		screen.clear()
		if not lever_used then Image.draw(bg, 0, 0) else Image.draw(bg_lev, 0, 0) end

		if not fountain_used then
			Image.draw(spritesheet, 166, 131, 15, 15, nil, 399, 0, 15, 15)
			intraFont.print(166 - intraFont.textW(font, choices_three.fountain, 1.5) / 2 + 8, 131 + 14, choices_three.fountain, Color.new(255, 255, 255), font, 1.5)
		end
		if not npc_talk then
			Image.draw(spritesheet, 394, 224, 15, 15, nil, 414, 0, 15, 15)
			intraFont.print(394 - intraFont.textW(font, choices_three[npc_k], 1.5) / 2 + 8, 224 + 14, choices_three[npc_k], Color.new(255, 255, 255), font, 1.5)
		elseif npc_talk and not lever_used then
			Image.draw(spritesheet, 394, 224, 15, 15, nil, 414, 0, 15, 15)
			intraFont.print(394 - intraFont.textW(font, choices_three[lev_k], 1.5) / 2 + 8, 224 + 14, choices_three[lev_k], Color.new(255, 255, 255), font, 1.5)
		end
		if not reuben_talk then
			Image.draw(spritesheet, 305, 135, 15, 15, nil, 384, 0, 15, 15)
			intraFont.print(305 - intraFont.textW(font, choices_three.reuben, 1.5) / 2 + 8, 135 + 14, choices_three.reuben, Color.new(255, 255, 255), font, 1.5)
		elseif reuben_talk and not leverreuben_used then
			Image.draw(spritesheet, 305, 135, 15, 15, nil, 384, 0, 15, 15)
			intraFont.print(305 - intraFont.textW(font, choices_three.leverreuben, 1.5) / 2 + 8, 135 + 14, choices_three.leverreuben, Color.new(255, 255, 255), font, 1.5)
		end
		if lever_used and leverreuben_used then
			Image.draw(spritesheet, 126, 169, 15, 15, nil, 384, 0, 15, 15)
			intraFont.print(126 - intraFont.textW(font, choices_three.lukas, 1.5) / 2 + 8, 169 + 14, choices_three.lukas, Color.new(255, 255, 255), font, 1.5)
		end

		intraFont.print(240 - intraFont.textW(font, ui.save, 0.63) / 2, 230, ui.save, Color.new(255, 255, 255, 150), font, 0.63)
		debugoverlay.draw(debugoverlay.loadSettings())
		screen.flip()

		local choosing = true
		while choosing and in_zone do
			buttons.read()
			if buttons.pressed(buttons.cross) then
				if not fountain_used then
					if not pc("fountain") then fountain_used = true end
					choosing = false
				end
			elseif buttons.pressed(buttons.square) then
				if not npc_talk then
					if not pc(npc_k) then npc_talk = true end
					choosing = false
				elseif npc_talk and not lever_used then
					if not pc(lev_k) then lever_used = true end
					choosing = false
				end
			elseif buttons.pressed(buttons.circle) then
				if not reuben_talk then
					if not pc("reuben") then reuben_talk = true end
					choosing = false
				elseif reuben_talk and not leverreuben_used then
					if not pc("leverreuben") then leverreuben_used = true end
					choosing = false
				elseif leverreuben_used and lever_used then
					ret = (branch == "gabriel") and "g/c8/lukas" or "p/c8/lukas"
					in_zone = false
					choosing = false
				end
			elseif buttons.pressed(buttons.start) then
				local p = dofile("assets/misc/pause.lua")
				choosing = false
				if p == -1 then nextscene = "./mainmenu.lua"; in_zone = false end
			elseif buttons.pressed(buttons.r) then
				choosing = false
				SaveGame(3)
			end
		end
	end

	Image.unload(bg)
	Image.unload(bg_lev)
	return ret
end

local function zone_loot(branch)
	local B = V..branch.."/choices/16/"
	local Bs = S..branch.."/choices/16/"
	local bg = Image.load(B.."loot_room_zone.png")
	local bg_btn = Image.load(B.."loot_room_zone_button.png")
	local button_used, lukas_talk, olivia_talk, axel_talk = false, false, false, false
	local in_zone = true
	local ret = nil

	local function pc(rel)
		PMP.setVolume(pmpvolume)
		local r = PMP.playExt(B..rel..".pmp", buttons.r, true, Bs..rel..".srt", font, subssize, "#FFFFFF", "#000000/110", subs)
		System.GC()
		if r == 1 then nextscene = "./mainmenu.lua"; in_zone = false end
		return r == 1
	end

	while in_zone do
		screen.clear()
		if not button_used then Image.draw(bg, 0, 0) else Image.draw(bg_btn, 0, 0) end

		if not button_used then
			Image.draw(spritesheet, 224, 64, 15, 15, nil, 414, 0, 15, 15)
			intraFont.print(224 - intraFont.textW(font, choices_three.button, 1.5) / 2 + 8, 64 + 14, choices_three.button, Color.new(255, 255, 255), font, 1.5)
		else
			Image.draw(spritesheet, 321, 131, 15, 15, nil, 414, 0, 15, 15)
			intraFont.print(321 - intraFont.textW(font, choices_three.chest, 1.5) / 2 + 8, 131 + 14, choices_three.chest, Color.new(255, 255, 255), font, 1.5)
		end
		if not olivia_talk then
			Image.draw(spritesheet, 171, 132, 15, 15, nil, 430, 0, 15, 15)
			intraFont.print(171 - intraFont.textW(font, choices_three.olivia, 1.5) / 2 + 8, 132 + 14, choices_three.olivia, Color.new(255, 255, 255), font, 1.5)
		end
		if not lukas_talk then
			Image.draw(spritesheet, 277, 80, 15, 15, nil, 399, 0, 15, 15)
			intraFont.print(277 - intraFont.textW(font, choices_three.lukas, 1.5) / 2 + 8, 80 + 14, choices_three.lukas, Color.new(255, 255, 255), font, 1.5)
		end
		if not axel_talk then
			Image.draw(spritesheet, 341, 195, 15, 15, nil, 384, 0, 15, 15)
			intraFont.print(341 - intraFont.textW(font, choices_three.axel, 1.5) / 2 + 8, 195 + 14, choices_three.axel, Color.new(255, 255, 255), font, 1.5)
		end

		intraFont.print(345 - 5 - intraFont.textW(font, ui.save, 0.63), 230, ui.save, Color.new(255, 255, 255, 150), font, 0.63)
		debugoverlay.draw(debugoverlay.loadSettings())
		screen.flip()

		local choosing = true
		while choosing and in_zone do
			buttons.read()
			if buttons.pressed(buttons.square) then
				if not button_used then
					if not pc("button") then button_used = true end
					choosing = false
				else
					ret = (branch == "gabriel") and "g/c16/chest" or "p/c16/chest"
					in_zone = false
					choosing = false
				end
			elseif buttons.pressed(buttons.cross) then
				if not lukas_talk then
					if not pc(button_used and "lukas_button" or "lukas") then lukas_talk = true end
					choosing = false
				end
			elseif buttons.pressed(buttons.circle) then
				if not axel_talk then
					if not pc(button_used and "axel_button" or "axel") then axel_talk = true end
					choosing = false
				end
			elseif buttons.pressed(buttons.triangle) then
				if not olivia_talk then
					if not pc(button_used and "olivia_button" or "olivia") then olivia_talk = true end
					choosing = false
				end
			elseif buttons.pressed(buttons.start) then
				local p = dofile("assets/misc/pause.lua")
				choosing = false
				if p == -1 then nextscene = "./mainmenu.lua"; in_zone = false end
			elseif buttons.pressed(buttons.r) then
				choosing = false
				SaveGame(3)
			end
		end
	end

	Image.unload(bg)
	Image.unload(bg_btn)
	return ret
end

local function zone_lab()
	local BV = V.."no_gp/10/"
	local BS = S.."no_gp/10/"
	local bg = Image.load(BV.."the_lab.png")
	local exit1_used, olivia_talk, chest_used = false, false, false
	local area_1_search, upstairs_search, area_2_search = false, false, false
	local in_zone = true
	local ret = nil

	local function pc(rel)
		PMP.setVolume(pmpvolume)
		local r = PMP.playExt(BV..rel..".pmp", buttons.r, true, BS..rel..".srt", font, subssize, "#FFFFFF", "#000000/110", subs)
		System.GC()
		if r == 1 then nextscene = "./mainmenu.lua"; in_zone = false end
		return r == 1
	end

	while in_zone do
		screen.clear()
		Image.draw(bg, 0, 0)

		if (not exit1_used and not chest_used) or (area_1_search and area_2_search and upstairs_search) then
			Image.draw(spritesheet, 445, 179, 15, 15, nil, 399, 0, 15, 15)
			intraFont.print(445 - intraFont.textW(font, choices_three.exit, 1.5) / 2 + 8, 179 + 14, choices_three.exit, Color.new(255, 255, 255), font, 1.5)
		elseif chest_used and not upstairs_search then
			Image.draw(spritesheet, 344, 31, 15, 15, nil, 399, 0, 15, 15)
			intraFont.print(344 - intraFont.textW(font, choices_three.search_upstairs, 1.5) / 2 + 8, 31 + 14, choices_three.search_upstairs, Color.new(255, 255, 255), font, 1.5)
		end

		if not area_1_search and chest_used then
			Image.draw(spritesheet, 144, 170, 15, 15, nil, 414, 0, 15, 15)
			intraFont.print(144 - intraFont.textW(font, choices_three.search_area1, 1.5) / 2 + 8, 170 + 14, choices_three.search_area1, Color.new(255, 255, 255), font, 1.5)
		elseif not olivia_talk then
			Image.draw(spritesheet, 62, 203, 15, 15, nil, 414, 0, 15, 15)
			intraFont.print(62 - intraFont.textW(font, choices_three.olivia, 1.5) / 2 + 8, 203 + 14, choices_three.olivia, Color.new(255, 255, 255), font, 1.5)
		end

		if not area_2_search and chest_used then
			Image.draw(spritesheet, 310, 177, 15, 15, nil, 384, 0, 15, 15)
			intraFont.print(310 - intraFont.textW(font, choices_three.search_area2, 1.5) / 2 + 8, 177 + 14, choices_three.search_area2, Color.new(255, 255, 255), font, 1.5)
		elseif not chest_used then
			Image.draw(spritesheet, 155, 171, 15, 15, nil, 384, 0, 15, 15)
			intraFont.print(155 - intraFont.textW(font, choices_three.chest, 1.5) / 2 + 8, 171 + 14, choices_three.chest, Color.new(255, 255, 255), font, 1.5)
		end

		intraFont.print(240 - intraFont.textW(font, ui.save, 0.63) / 2, 230, ui.save, Color.new(255, 255, 255, 150), font, 0.63)
		debugoverlay.draw(debugoverlay.loadSettings())
		screen.flip()

		local choosing = true
		while choosing and in_zone do
			buttons.read()
			if buttons.pressed(buttons.cross) then
				if not exit1_used and not chest_used then
					if not pc("exit") then exit1_used = true end
					choosing = false
				elseif area_1_search and area_2_search and upstairs_search then
					ret = "sh/exit2"
					in_zone = false
					choosing = false
				elseif not upstairs_search and chest_used then
					if not pc("search_upstairs") then upstairs_search = true end
					choosing = false
				end
			elseif buttons.pressed(buttons.square) then
				if not area_1_search and chest_used then
					if not pc("search_area1") then area_1_search = true end
					choosing = false
				elseif not olivia_talk then
					if not pc("olivia") then olivia_talk = true end
					choosing = false
				end
			elseif buttons.pressed(buttons.circle) then
				if not area_2_search and chest_used then
					if not pc("search_area2") then area_2_search = true end
					choosing = false
				elseif not chest_used then
					if not pc("chest") then chest_used = true end
					choosing = false
				end
			elseif buttons.pressed(buttons.start) then
				local p = dofile("assets/misc/pause.lua")
				choosing = false
				if p == -1 then nextscene = "./mainmenu.lua"; in_zone = false end
			elseif buttons.pressed(buttons.r) then
				choosing = false
				SaveGame(3)
			end
		end
	end

	Image.unload(bg)
	return ret
end

local function ep3_end()
	wr("3_status", "restart")
	PMP.setVolume(pmpvolume)
	PMP.playExt("assets/video/credits/ep3.pmp", buttons.start)
	System.GC()
	nextscene = "./mainmenu.lua"
end

local c11_sq_nd = function() return (gp == "petra") and "p/c12/guess" or "g/c12/guess" end
local c11_ci_nd = function() return (gp == "petra") and "p/c12/not" or "g/c12/not" end

local nodes = {
	["start"] = { dn = function() return (gp == "petra") and "p/start" or "g/start" end },

	-- GABRIEL BRANCH --
	["g/start"] = {
		v = "gabriel/start",
		sq = { rl = "Let's keep this\n\n between us", n = "g/lets_keep" },
		ci = { rl = "We have to tell\n\n the others", n = "g/we_tell" },
	},
	["g/lets_keep"] = { v = "gabriel/lets_keep_this_between_us",
		sq = { k = "drop_amulet", n = "g/c1/drop" }, ci = { k = "jump_down", n = "g/c1/jump" } },
	["g/we_tell"] = { v = "gabriel/we_have_to_tell_the_others",
		sq = { k = "drop_amulet", n = "g/c1/drop" }, ci = { k = "jump_down", n = "g/c1/jump" } },

	["g/c1/drop"] = { v = "gabriel/choices/1/drop_amulet",
		sq = { k = "this_cant_be_good", n = "g/c2/this" }, ci = { k = "whats_that_doing_here", n = "g/c2/whats" } },
	["g/c1/jump"] = { v = "gabriel/choices/1/jump_down",
		sq = { k = "this_cant_be_good", n = "g/c2/this" }, ci = { k = "whats_that_doing_here", n = "g/c2/whats" } },

	["g/c2/this"] = { v = "gabriel/choices/2/this_cant_be_good",
		sq = { k = "jumping_is_easy", n = "g/c3/easy" }, ci = { k = "tuck_and_roll", n = "g/c3/tuck" } },
	["g/c2/whats"] = { v = "gabriel/choices/2/whats_that_doing_here",
		sq = { k = "jumping_is_easy", n = "g/c3/easy" }, ci = { k = "tuck_and_roll", n = "g/c3/tuck" } },

	["g/c3/easy"] = { v = "gabriel/choices/3/jumping_is_easy",
		sq = { k = "save_amulet", n = "g/c4/save" }, ci = { k = "help_reuben_and_axel", n = "g/c4/help" } },
	["g/c3/tuck"] = { v = "gabriel/choices/3/tuck_and_roll",
		sq = { k = "save_amulet", n = "g/c4/save" }, ci = { k = "help_reuben_and_axel", n = "g/c4/help" } },

	["g/c4/save"] = { v = "gabriel/choices/4/save_amulet",
		sq = { k = "dont_touch_my_pig", n = "g/c4s/dont" }, ci = { k = "thanks_for_saving_reuben", n = "g/c4s/thanks" } },
	["g/c4/help"] = { v = "gabriel/choices/4/help_reuben_and_axel",
		sq = { k = "give_it_back_its_mine", n = "g/c4h/give" }, ci = { k = "thanks_for_grabbing_it", n = "g/c4h/thanks" } },

	["g/c4s/dont"] = { v = "gabriel/choices/4/save_amulet/dont_touch_my_pig",
		sq = { k = "a_haunting", n = "g/c5/haunt" }, ci = { k = "dont_look_at_them", n = "g/c5/dont" } },
	["g/c4s/thanks"] = { v = "gabriel/choices/4/save_amulet/thanks_for_saving_reuben",
		sq = { k = "a_haunting", n = "g/c5/haunt" }, ci = { k = "dont_look_at_them", n = "g/c5/dont" } },
	["g/c4h/give"] = { v = "gabriel/choices/4/help_reuben_and_axel/give_it_back_its_mine",
		sq = { k = "a_haunting", n = "g/c5/haunt" }, ci = { k = "dont_look_at_them", n = "g/c5/dont" } },
	["g/c4h/thanks"] = { v = "gabriel/choices/4/help_reuben_and_axel/thanks_for_grabbing_it",
		sq = { k = "a_haunting", n = "g/c5/haunt" }, ci = { k = "dont_look_at_them", n = "g/c5/dont" } },

	["g/c5/haunt"] = { v = "gabriel/choices/5/a_haunting",
		sq = { k = "follow_lukas", n = "g/c6/lukas" }, ci = { k = "follow_me", n = "g/c6/me" } },
	["g/c5/dont"] = { v = "gabriel/choices/5/dont_look_at_them",
		sq = { k = "follow_lukas", n = "g/c6/lukas" }, ci = { k = "follow_me", n = "g/c6/me" } },

	["g/c6/lukas"] = { v = "gabriel/choices/6/follow_lukas",
		sq = { k = "its_beautiful", n = "g/c7/beautiful" }, ci = { k = "im_hallucinating", n = "g/c7/halluc" } },
	["g/c6/me"] = { v = "gabriel/choices/6/follow_me",
		sq = { k = "its_beautiful", n = "g/c7/beautiful" }, ci = { k = "im_hallucinating", n = "g/c7/halluc" } },

	["g/c7/beautiful"] = { v = "gabriel/choices/7/its_beautiful", n = "g/woolland" },
	["g/c7/halluc"]    = { v = "gabriel/choices/7/im_hallucinating", n = "g/woolland" },
	["g/woolland"]     = { zone = function() return zone_woolland("gabriel") end },

	["g/c8/lukas"] = { v = "gabriel/choices/8/lukas",
		sq = { k = "gabriel_is_sick", n = "g/c9/sick" }, ci = { k = "hes_fine", n = "g/c9/fine" } },
	["g/c9/sick"] = { v = "gabriel/choices/9/gabriel_is_sick",
		sq = { k = "we_are_a_team", n = "g/c9s/team" }, ci = { k = "you_can_do_this", n = "g/c9s/you" } },
	["g/c9s/team"] = { v = "gabriel/choices/9/gabriel_is_sick/we_are_a_team",
		sq = { k = "dont_give_up", n = "sh/dont" }, ci = { k = "soren_was_here", n = "sh/soren" } },
	["g/c9s/you"] = { v = "gabriel/choices/9/gabriel_is_sick/you_can_do_this",
		sq = { k = "dont_give_up", n = "sh/dont" }, ci = { k = "soren_was_here", n = "sh/soren" } },
	["g/c9/fine"] = { v = "gabriel/choices/9/hes_fine",
		sq = { k = "dont_give_up", n = "sh/dont" }, ci = { k = "soren_was_here", n = "sh/soren" } },

	-- PETRA BRANCH --
	["p/start"] = {
		v = "petra/start",
		sq = { rl = "Let's keep this\n\n between us", n = "p/lets_keep" },
		ci = { rl = "We have to tell\n\n the others", n = "p/we_tell" },
	},
	["p/lets_keep"] = { v = "petra/lets_keep_this_between_us",
		sq = { k = "drop_amulet", n = "p/c1/drop" }, ci = { k = "jump_down", n = "p/c1/jump" } },
	["p/we_tell"] = { v = "petra/we_have_to_tell_the_others",
		sq = { k = "drop_amulet", n = "p/c1/drop" }, ci = { k = "jump_down", n = "p/c1/jump" } },

	["p/c1/drop"] = { v = "petra/choices/1/drop_amulet",
		sq = { k = "this_cant_be_good", n = "p/c2/this" }, ci = { k = "whats_that_doing_here", n = "p/c2/whats" } },
	["p/c1/jump"] = { v = "petra/choices/1/jump_down",
		sq = { k = "this_cant_be_good", n = "p/c2/this" }, ci = { k = "whats_that_doing_here", n = "p/c2/whats" } },

	["p/c2/this"] = { v = "petra/choices/2/this_cant_be_good",
		sq = { k = "jumping_is_easy", n = "p/c3/easy" }, ci = { k = "tuck_and_roll", n = "p/c3/tuck" } },
	["p/c2/whats"] = { v = "petra/choices/2/whats_that_doing_here",
		sq = { k = "jumping_is_easy", n = "p/c3/easy" }, ci = { k = "tuck_and_roll", n = "p/c3/tuck" } },

	["p/c3/easy"] = { v = "petra/choices/3/jumping_is_easy",
		sq = { k = "save_amulet", n = "p/c4/save" }, ci = { k = "help_reuben_and_axel", n = "p/c4/help" } },
	["p/c3/tuck"] = { v = "petra/choices/3/tuck_and_roll",
		sq = { k = "save_amulet", n = "p/c4/save" }, ci = { k = "help_reuben_and_axel", n = "p/c4/help" } },

	["p/c4/save"] = { v = "petra/choices/4/save_amulet",
		sq = { k = "dont_touch_my_pig", n = "p/c4s/dont" }, ci = { k = "thanks_for_saving_reuben", n = "p/c4s/thanks" } },
	["p/c4/help"] = { v = "petra/choices/4/help_reuben_and_axel",
		sq = { k = "give_it_back_its_mine", n = "p/c4h/give" }, ci = { k = "thanks_for_grabbing_it", n = "p/c4h/thanks" } },

	["p/c4s/dont"] = { v = "petra/choices/4/save_amulet/dont_touch_my_pig",
		sq = { k = "a_haunting", n = "p/c5/haunt" }, ci = { k = "dont_look_at_them", n = "p/c5/dont" } },
	["p/c4s/thanks"] = { v = "petra/choices/4/save_amulet/thanks_for_saving_reuben",
		sq = { k = "a_haunting", n = "p/c5/haunt" }, ci = { k = "dont_look_at_them", n = "p/c5/dont" } },
	["p/c4h/give"] = { v = "petra/choices/4/help_reuben_and_axel/give_it_back_its_mine",
		sq = { k = "a_haunting", n = "p/c5/haunt" }, ci = { k = "dont_look_at_them", n = "p/c5/dont" } },
	["p/c4h/thanks"] = { v = "petra/choices/4/help_reuben_and_axel/thanks_for_grabbing_it",
		sq = { k = "a_haunting", n = "p/c5/haunt" }, ci = { k = "dont_look_at_them", n = "p/c5/dont" } },

	["p/c5/haunt"] = { v = "petra/choices/5/a_haunting",
		sq = { k = "follow_lukas", n = "p/c6/lukas" }, ci = { k = "follow_me", n = "p/c6/me" } },
	["p/c5/dont"] = { v = "petra/choices/5/dont_look_at_them",
		sq = { k = "follow_lukas", n = "p/c6/lukas" }, ci = { k = "follow_me", n = "p/c6/me" } },

	["p/c6/lukas"] = { v = "petra/choices/6/follow_lukas",
		sq = { k = "its_beautiful", n = "p/c7/beautiful" }, ci = { k = "im_hallucinating", n = "p/c7/halluc" } },
	["p/c6/me"] = { v = "petra/choices/6/follow_me",
		sq = { k = "its_beautiful", n = "p/c7/beautiful" }, ci = { k = "im_hallucinating", n = "p/c7/halluc" } },

	["p/c7/beautiful"] = { v = "petra/choices/7/its_beautiful", n = "p/woolland" },
	["p/c7/halluc"]    = { v = "petra/choices/7/im_hallucinating", n = "p/woolland" },
	["p/woolland"]     = { zone = function() return zone_woolland("petra") end },

	["p/c8/lukas"] = { v = "petra/choices/8/lukas",
		sq = { k = "petra_is_sick", n = "p/c9/sick" }, ci = { k = "hes_fine", n = "p/c9/fine" } },
	["p/c9/sick"] = { v = "petra/choices/9/petra_is_sick",
		sq = { k = "we_are_a_team", n = "p/c9s/team" }, ci = { k = "you_can_do_this", n = "p/c9s/you" } },
	["p/c9s/team"] = { v = "petra/choices/9/petra_is_sick/we_are_a_team",
		sq = { k = "dont_give_up", n = "sh/dont" }, ci = { k = "soren_was_here", n = "sh/soren" } },
	["p/c9s/you"] = { v = "petra/choices/9/petra_is_sick/you_can_do_this",
		sq = { k = "dont_give_up", n = "sh/dont" }, ci = { k = "soren_was_here", n = "sh/soren" } },
	["p/c9/fine"] = { v = "petra/choices/9/shes_fine",
		sq = { k = "dont_give_up", n = "sh/dont" }, ci = { k = "soren_was_here", n = "sh/soren" } },

	-- SHARED SECTION --
	["sh/dont"]  = { v = "no_gp/9/fine/dont_give_up", n = "sh/lab" },
	["sh/soren"] = { v = "no_gp/9/fine/soren_was_here", n = "sh/lab" },
	["sh/lab"]   = { zone = function() return zone_lab() end },

	["sh/exit2"] = { v = "no_gp/10/exit_2",
		sq = { k = "help_me_save_the_world", n = "sh/c11/help" },
		ci = { k = "you_need_to_be_a_hero", n = "sh/c11/hero" } },

	["sh/c11/help"] = { v = "no_gp/11/help_me_save_the_world",
		sq = { k = "i_guess_so", nd = c11_sq_nd }, ci = { k = "not_really", nd = c11_ci_nd } },
	["sh/c11/hero"] = { v = "no_gp/11/you_need_to_be_a_hero",
		sq = { k = "i_guess_so", nd = c11_sq_nd }, ci = { k = "not_really", nd = c11_ci_nd } },

	-- GABRIEL C12+ --
	["g/c12/guess"] = { v = "gabriel/choices/12/i_guess_so",
		sq = { k = "break_the_fountain", n = "g/c13/break" }, ci = { k = "dont_look_at_them", n = "g/c13/dont" } },
	["g/c12/not"] = { v = "gabriel/choices/12/not_really",
		sq = { k = "break_the_fountain", n = "g/c13/break" }, ci = { k = "dont_look_at_them", n = "g/c13/dont" } },

	["g/c13/break"] = { v = "gabriel/choices/13/break_the_fountain",
		sq = { k = "eyes_down", n = "g/c14/eyes" }, ci = { k = "hold_onto_me", n = "g/c14/hold" } },
	["g/c13/dont"] = { v = "gabriel/choices/13/dont_look_at_them",
		sq = { k = "eyes_down", n = "g/c14/eyes" }, ci = { k = "hold_onto_me", n = "g/c14/hold" } },

	["g/c14/eyes"] = { v = "gabriel/choices/14/eyes_down",
		sq = { k = "that_was_cool", n = "g/c15/cool" }, ci = { k = "that_was_scary", n = "g/c15/scary" } },
	["g/c14/hold"] = { v = "gabriel/choices/14/hold_onto_me",
		sq = { k = "that_was_cool", n = "g/c15/cool" }, ci = { k = "that_was_scary", n = "g/c15/scary" } },

	["g/c15/cool"]  = { v = "gabriel/choices/15/that_was_cool", n = "g/loot" },
	["g/c15/scary"] = { v = "gabriel/choices/15/that_was_scary", n = "g/loot" },
	["g/loot"]      = { zone = function() return zone_loot("gabriel") end },

	["g/c16/chest"] = { v = "gabriel/choices/16/chest",
		sq = { k = "will_you_help_us", n = "g/c17/will" }, ci = { k = "why_did_you_leave", n = "g/c17/why" } },
	["g/c17/will"] = { v = "gabriel/choices/17/will_you_help_us",
		sq = { k = "take_magnus_armor",    fn = function() wr("ema", "magnus") end,    n = "g/c18/mag" },
		ci = { k = "take_ellegaards_armor", fn = function() wr("ema", "ellegaard") end, n = "g/c18/ell" } },
	["g/c17/why"] = { v = "gabriel/choices/17/why_did_you_leave",
		sq = { k = "take_magnus_armor",    fn = function() wr("ema", "magnus") end,    n = "g/c18/mag" },
		ci = { k = "take_ellegaards_armor", fn = function() wr("ema", "ellegaard") end, n = "g/c18/ell" } },

	["g/c18/mag"] = { v = "gabriel/choices/18/take_magnus_armor",
		sq = { k = "i_owe_you_guys", n = "g/c18m/1owe" }, ci = { k = "it_was_all_me", n = "g/c18m/1itw" } },
	["g/c18/ell"] = { v = "gabriel/choices/18/take_ellegaards_armor",
		sq = { k = "i_owe_you_guys", n = "g/c18e/1owe" }, ci = { k = "it_was_all_me", n = "g/c18e/1itw" } },

	["g/c18m/1owe"] = { v = "gabriel/choices/18/magnus/1/i_owe_you_guys",
		sq = { k = "please_dont_die", n = "g/c18m/2pdd" }, ci = { k = "this_armor_is_yours", n = "g/c18m/2tay" } },
	["g/c18m/1itw"] = { v = "gabriel/choices/18/magnus/1/it_was_all_me",
		sq = { k = "please_dont_die", n = "g/c18m/2pdd" }, ci = { k = "this_armor_is_yours", n = "g/c18m/2tay" } },
	["g/c18m/2pdd"] = { v = "gabriel/choices/18/magnus/2/please_dont_die",    post = ep3_end },
	["g/c18m/2tay"] = { v = "gabriel/choices/18/magnus/2/this_armor_is_yours", post = ep3_end },

	["g/c18e/1owe"] = { v = "gabriel/choices/18/ellegaard/1/i_owe_you_guys",
		sq = { k = "please_dont_die", n = "g/c18e/2pdd" }, ci = { k = "this_armor_is_yours", n = "g/c18e/2tay" } },
	["g/c18e/1itw"] = { v = "gabriel/choices/18/ellegaard/1/it_was_all_me",
		sq = { k = "please_dont_die", n = "g/c18e/2pdd" }, ci = { k = "this_armor_is_yours", n = "g/c18e/2tay" } },
	["g/c18e/2pdd"] = { v = "gabriel/choices/18/ellegaard/2/please_dont_die",    post = ep3_end },
	["g/c18e/2tay"] = { v = "gabriel/choices/18/ellegaard/2/this_armor_is_yours", post = ep3_end },

	-- PETRA C12+ --
	["p/c12/guess"] = { v = "petra/choices/12/i_guess_so",
		sq = { k = "break_the_fountain", n = "p/c13/break" }, ci = { k = "dont_look_at_them", n = "p/c13/dont" } },
	["p/c12/not"] = { v = "petra/choices/12/not_really",
		sq = { k = "break_the_fountain", n = "p/c13/break" }, ci = { k = "dont_look_at_them", n = "p/c13/dont" } },

	["p/c13/break"] = { v = "petra/choices/13/break_the_fountain",
		sq = { k = "eyes_down", n = "p/c14/eyes" }, ci = { k = "hold_onto_me", n = "p/c14/hold" } },
	["p/c13/dont"] = { v = "petra/choices/13/dont_look_at_them",
		sq = { k = "eyes_down", n = "p/c14/eyes" }, ci = { k = "hold_onto_me", n = "p/c14/hold" } },

	["p/c14/eyes"] = { v = "petra/choices/14/eyes_down",
		sq = { k = "that_was_cool", n = "p/c15/cool" }, ci = { k = "that_was_scary", n = "p/c15/scary" } },
	["p/c14/hold"] = { v = "petra/choices/14/hold_onto_me",
		sq = { k = "that_was_cool", n = "p/c15/cool" }, ci = { k = "that_was_scary", n = "p/c15/scary" } },

	["p/c15/cool"]  = { v = "petra/choices/15/that_was_cool", n = "p/loot" },
	["p/c15/scary"] = { v = "petra/choices/15/that_was_scary", n = "p/loot" },
	["p/loot"]      = { zone = function() return zone_loot("petra") end },

	["p/c16/chest"] = { v = "petra/choices/16/chest",
		sq = { k = "will_you_help_us", n = "p/c17/will" }, ci = { k = "why_did_you_leave", n = "p/c17/why" } },
	["p/c17/will"] = { v = "petra/choices/17/will_you_help_us",
		sq = { k = "take_magnus_armor",    fn = function() wr("ema", "magnus") end,    n = "p/c18/mag" },
		ci = { k = "take_ellegaards_armor", fn = function() wr("ema", "ellegaard") end, n = "p/c18/ell" } },
	["p/c17/why"] = { v = "petra/choices/17/why_did_you_leave",
		sq = { k = "take_magnus_armor",    fn = function() wr("ema", "magnus") end,    n = "p/c18/mag" },
		ci = { k = "take_ellegaards_armor", fn = function() wr("ema", "ellegaard") end, n = "p/c18/ell" } },

	["p/c18/mag"] = { v = "petra/choices/18/take_magnus_armor",
		sq = { k = "i_owe_you_guys", n = "p/c18m/1owe" }, ci = { k = "it_was_all_me", n = "p/c18m/1itw" } },
	["p/c18/ell"] = { v = "petra/choices/18/take_ellegaards_armor",
		sq = { k = "i_owe_you_guys", n = "p/c18e/1owe" }, ci = { k = "it_was_all_me", n = "p/c18e/1itw" } },

	["p/c18m/1owe"] = { v = "petra/choices/18/magnus/1/i_owe_you_guys",
		sq = { k = "please_dont_die", n = "p/c18m/2pdd" }, ci = { k = "this_armor_is_yours", n = "p/c18m/2tay" } },
	["p/c18m/1itw"] = { v = "petra/choices/18/magnus/1/it_was_all_me",
		sq = { k = "please_dont_die", n = "p/c18m/2pdd" }, ci = { k = "this_armor_is_yours", n = "p/c18m/2tay" } },
	["p/c18m/2pdd"] = { v = "petra/choices/18/magnus/2/please_dont_die",    post = ep3_end },
	["p/c18m/2tay"] = { v = "petra/choices/18/magnus/2/this_armor_is_yours", post = ep3_end },

	["p/c18e/1owe"] = { v = "petra/choices/18/ellegaard/1/i_owe_you_guys",
		sq = { k = "please_dont_die", n = "p/c18e/2pdd" }, ci = { k = "this_armor_is_yours", n = "p/c18e/2tay" } },
	["p/c18e/1itw"] = { v = "petra/choices/18/ellegaard/1/it_was_all_me",
		sq = { k = "please_dont_die", n = "p/c18e/2pdd" }, ci = { k = "this_armor_is_yours", n = "p/c18e/2tay" } },
	["p/c18e/2pdd"] = { v = "petra/choices/18/ellegaard/2/please_dont_die",    post = ep3_end },
	["p/c18e/2tay"] = { v = "petra/choices/18/ellegaard/2/this_armor_is_yours", post = ep3_end },
}

local current = ep3_node or "start"
ep3_node = nil
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
			ui2(sq_txt, ci_txt)
			ep3_node = current
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
					ui2(sq_txt, ci_txt)
				elseif buttons.pressed(buttons.r) then
					SaveGame(3)
				end
			end
		elseif node.n then
			current = node.n
		else
			break
		end
	end
end
