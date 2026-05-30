local V = "assets/video/episode4/"
local S = "assets/subtitles/episode4/"
local EP_FILE = "assets/video/episode4/episode4.lua"

local _vf = io.open("assets/saves/4_variables.txt", "r")
if _vf then
	for line in _vf:lines() do
		local k, v = line:match('^(%w+)%s*=%s*"([^"]*)"')
		if k and v then _G[k] = v end
	end
	_vf:close()
end
_vf = nil
checkFile("assets/saves/ema.txt", "ema")
checkFile("assets/saves/gp.txt", "gp")

local function B() return ema .. "_" .. gp .. "/" end

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
	local t = entry.tab or choices_four
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

local function ui3(ltxt, rtxt, tritxt)
	Image.draw(spritesheet, 25, 127, 15, 15, nil, 414, 0, 15, 15)
	Image.draw(spritesheet, 455, 127, 15, 15, nil, 384, 0, 15, 15)
	Image.draw(spritesheet, 140, 182, 15, 15, nil, 430, 0, 15, 15)
	intraFont.print(45, 127, ltxt, Color.new(255, 255, 255), font, 2)
	intraFont.print(450 - intraFont.textW(font, rtxt, 2), 127, rtxt, Color.new(255, 255, 255), font, 2)
	intraFont.print(140 + 15 + 5, 182, tritxt, Color.new(255, 255, 255), font, 2)
	intraFont.print(240 - intraFont.textW(font, ui.save, 2) / 2, 230, ui.save, Color.new(255, 255, 255, 150), font, 2)
	debugoverlay.draw()
	screen.flip()
end

local function ep4_end()
	wr("4_status", "restart")
	PMP.setVolume(pmpvolume)
	PMP.playExt("assets/video/credits/ep4.pmp", buttons.start)
	System.GC()
	nextscene = "./mainmenu.lua"
end

local function zone_ivors()
	local Bv = V .. B() .. "choices/16/"
	local Bs = S .. B() .. "choices/16/"
	local npc_dir = (gp == "gabriel") and "petra" or "gabriel"
	local npc_lbl = (gp == "gabriel") and choices_four.petra or choices_three.gabriel

	local bg = Image.load(Bv .. "ivors_house.png")
	local bookcase_used = false
	local redstone_hole_used = false
	local chest_used = false
	local crafting_table_used = false
	local put_lever = false
	local npc_talk = false
	local in_zone = true
	local ret = nil

	local function pc(rel)
		PMP.setVolume(pmpvolume)
		local r = PMP.playExt(Bv .. rel .. ".pmp", buttons.r, true,
			Bs .. rel .. ".srt", font, subssize, "#FFFFFF", "#000000/110", subs)
		System.GC()
		if r == 1 then nextscene = "./mainmenu.lua"; in_zone = false end
		return r == 1
	end

	while in_zone do
		screen.clear()
		Image.draw(bg, 0, 0)

		if not bookcase_used then
			Image.draw(spritesheet, 126, 169, 15, 15, nil, 384, 0, 15, 15)
			intraFont.print(126 - intraFont.textW(font, choices_four.bookcase, 1.5) / 2 + 8, 169 + 14,
				choices_four.bookcase, Color.new(255, 255, 255), font, 1.5)
		end

		if not chest_used then
			Image.draw(spritesheet, 272, 119, 15, 15, nil, 414, 0, 15, 15)
			intraFont.print(272 - intraFont.textW(font, choices_four.chest, 1.5) / 2 + 8, 119 + 14,
				choices_four.chest, Color.new(255, 255, 255), font, 1.5)
		elseif chest_used and not crafting_table_used then
			Image.draw(spritesheet, 289, 119, 15, 15, nil, 414, 0, 15, 15)
			intraFont.print(289 - intraFont.textW(font, choices_four.crafting_table, 1.5) / 2 + 8, 119 + 14,
				choices_four.crafting_table, Color.new(255, 255, 255), font, 1.5)
		end

		if not redstone_hole_used and not crafting_table_used then
			Image.draw(spritesheet, 397, 147, 15, 15, nil, 430, 0, 15, 15)
			intraFont.print(397 - intraFont.textW(font, choices_four.redstone_hole, 1.5) / 2 + 8, 147 + 14,
				choices_four.redstone_hole, Color.new(255, 255, 255), font, 1.5)
		end

		if not npc_talk then
			Image.draw(spritesheet, 210, 169, 15, 15, nil, 399, 0, 15, 15)
			intraFont.print(210 - intraFont.textW(font, npc_lbl, 1.5) / 2 + 8, 169 + 14,
				npc_lbl, Color.new(255, 255, 255), font, 1.5)
		end

		if crafting_table_used and not put_lever then
			Image.draw(spritesheet, 393, 146, 15, 15, nil, 414, 0, 15, 15)
			intraFont.print(393 - intraFont.textW(font, choices_four.put_lever, 1.5) / 2 + 8, 146 + 14,
				choices_four.put_lever, Color.new(255, 255, 255), font, 1.5)
		elseif put_lever then
			Image.draw(spritesheet, 393, 146, 15, 15, nil, 414, 0, 15, 15)
			intraFont.print(393 - intraFont.textW(font, choices_four.lever, 1.5) / 2 + 8, 146 + 14,
				choices_four.lever, Color.new(255, 255, 255), font, 1.5)
		end

		intraFont.print(240 - intraFont.textW(font, ui.save, 0.63) / 2, 230,
			ui.save, Color.new(255, 255, 255, 150), font, 0.63)
		debugoverlay.draw()
		screen.flip()

		local choosing = true
		while choosing do
			buttons.read()

			if buttons.pressed(buttons.circle) then
				if not bookcase_used then
					pc("bookcase")
					bookcase_used = true
				end
				choosing = false
			elseif buttons.pressed(buttons.square) then
				if not chest_used then
					pc("chest")
					chest_used = true
					choosing = false
				elseif chest_used and not crafting_table_used then
					pc("crafting_table")
					crafting_table_used = true
					choosing = false
				elseif crafting_table_used and not put_lever then
					pc("put_lever")
					put_lever = true
					choosing = false
				elseif put_lever then
					rm("ivors_house_variables")
					ret = "c16/lever"
					in_zone = false
					choosing = false
				end
			elseif buttons.pressed(buttons.triangle) then
				if not redstone_hole_used and not crafting_table_used then
					pc("redstone_hole")
					redstone_hole_used = true
				end
				choosing = false
			elseif buttons.pressed(buttons.cross) then
				if not npc_talk then
					npc_talk = true
					choosing = false
					if not pc(npc_dir) then
						local sq_txt = choices_four.youll_be_fine
						local ci_txt = choices_four.i_wont_lie_to_you
						ui2(sq_txt, ci_txt)
						local npc_ch = true
						while npc_ch do
							buttons.read()
							if buttons.pressed(buttons.square) then
								pc(npc_dir .. "/youll_be_fine")
								npc_ch = false
							elseif buttons.pressed(buttons.circle) then
								pc(npc_dir .. "/i_wont_lie_to_you")
								npc_ch = false
							elseif buttons.pressed(buttons.start) then
								local p = dofile("assets/misc/pause.lua")
								if p == -1 then
									nextscene = "./mainmenu.lua"
									in_zone = false
									npc_ch = false
								else
									ui2(sq_txt, ci_txt)
								end
							elseif buttons.pressed(buttons.r) then
								SaveGame(4)
								npc_ch = false
							end
						end
					end
				end
			elseif buttons.pressed(buttons.start) then
				local p = dofile("assets/misc/pause.lua")
				if p == -1 then
					nextscene = "./mainmenu.lua"
					in_zone = false
				end
				choosing = false
			elseif buttons.pressed(buttons.r) then
				SaveGame(4)
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
		dv = function() return B() .. "start" end,
		sq = { k = "ive_got_petra",   n = "ive_got"  },
		ci = { k = "ill_take_gabriel", n = "ill_take" },
	},

	-- OPENING CHOICE
	["ive_got"] = {
		dv = function() return B() .. "ive_got_petra" end,
		sq = { dk = function() return gp == "gabriel" and "she_doesnt_know_us"  or "he_forgot_everyone"  end,
		       nd = function() return gp == "gabriel" and "c1/she"              or "c1/he"               end },
		ci = { dk = function() return gp == "gabriel" and "give_her_some_space" or "give_him_some_space" end,
		       nd = function() return gp == "gabriel" and "c1/give_her"         or "c1/give_him"         end },
	},
	["ill_take"] = {
		dv = function() return B() .. "ill_take_gabriel" end,
		sq = { dk = function() return gp == "gabriel" and "she_doesnt_know_us"  or "he_forgot_everyone"  end,
		       nd = function() return gp == "gabriel" and "c1/she"              or "c1/he"               end },
		ci = { dk = function() return gp == "gabriel" and "give_her_some_space" or "give_him_some_space" end,
		       nd = function() return gp == "gabriel" and "c1/give_her"         or "c1/give_him"         end },
	},

	-- C1 nodes
	["c1/she"] = {
		dv = function() return B() .. "choices/1/she_doesnt_know_us" end,
		sq = { dk = function() return gp == "gabriel" and "stay_with_petra"    or "stay_with_gabriel"  end,
		       nd = function() return gp == "gabriel" and "c2/stay_g"          or "c2/stay_p"          end },
		ci = { dk = function() return gp == "gabriel" and "go_talk_to_gabriel" or "go_talk_to_petra"   end,
		       nd = function() return gp == "gabriel" and "c2/go_g"            or "c2/go_p"            end },
	},
	["c1/he"] = {
		dv = function() return B() .. "choices/1/he_forgot_everyone" end,
		sq = { dk = function() return gp == "gabriel" and "stay_with_petra"    or "stay_with_gabriel"  end,
		       nd = function() return gp == "gabriel" and "c2/stay_g"          or "c2/stay_p"          end },
		ci = { dk = function() return gp == "gabriel" and "go_talk_to_gabriel" or "go_talk_to_petra"   end,
		       nd = function() return gp == "gabriel" and "c2/go_g"            or "c2/go_p"            end },
	},
	["c1/give_her"] = {
		dv = function() return B() .. "choices/1/give_her_some_space" end,
		sq = { dk = function() return gp == "gabriel" and "stay_with_petra"    or "stay_with_gabriel"  end,
		       nd = function() return gp == "gabriel" and "c2/stay_g"          or "c2/stay_p"          end },
		ci = { dk = function() return gp == "gabriel" and "go_talk_to_gabriel" or "go_talk_to_petra"   end,
		       nd = function() return gp == "gabriel" and "c2/go_g"            or "c2/go_p"            end },
	},
	["c1/give_him"] = {
		dv = function() return B() .. "choices/1/give_him_some_space" end,
		sq = { dk = function() return gp == "gabriel" and "stay_with_petra"    or "stay_with_gabriel"  end,
		       nd = function() return gp == "gabriel" and "c2/stay_g"          or "c2/stay_p"          end },
		ci = { dk = function() return gp == "gabriel" and "go_talk_to_gabriel" or "go_talk_to_petra"   end,
		       nd = function() return gp == "gabriel" and "c2/go_g"            or "c2/go_p"            end },
	},

	-- C2 nodes
	["c2/stay_g"] = {
		dv = function() return B() .. "choices/2/stay_with_petra" end,
		sq = { k = "i_chose_gabriel",      n = "c3/petra/i_chose"  },
		ci = { k = "i_couldnt_save_you",   n = "c3/petra/couldnt"  },
	},
	["c2/go_g"] = {
		dv = function() return B() .. "choices/2/go_talk_to_gabriel" end,
		sq = { k = "doesnt_matter_now",    n = "c3/gabriel/doesnt"   },
		ci = { k = "we_all_make_mistakes", n = "c3/gabriel/mistakes" },
	},
	["c2/stay_p"] = {
		dv = function() return B() .. "choices/2/stay_with_gabriel" end,
		sq = { k = "just_have_our_back",   n = "c3/gabriel/just"  },
		ci = { k = "youll_get_a_chance",   n = "c3/gabriel/youll" },
	},
	["c2/go_p"] = {
		dv = function() return B() .. "choices/2/go_talk_to_petra" end,
		sq = { k = "its_ivors_fault",      n = "c3/petra/ivors" },
		ci = { k = "you_didnt_know",       n = "c3/petra/didnt" },
	},

	-- C3 nodes (all → c4)
	["c3/petra/i_chose"] = {
		dv = function() return B() .. "choices/3/petra/i_chose_gabriel" end,
		sq = { k = "they_could_be_alive", n = "c4/alive"   },
		ci = { k = "nothing_you_can_do",  n = "c4/nothing" },
	},
	["c3/petra/couldnt"] = {
		dv = function() return B() .. "choices/3/petra/i_couldnt_save_you" end,
		sq = { k = "they_could_be_alive", n = "c4/alive"   },
		ci = { k = "nothing_you_can_do",  n = "c4/nothing" },
	},
	["c3/gabriel/doesnt"] = {
		dv = function() return B() .. "choices/3/gabriel/doesnt_matter_now" end,
		sq = { k = "they_could_be_alive", n = "c4/alive"   },
		ci = { k = "nothing_you_can_do",  n = "c4/nothing" },
	},
	["c3/gabriel/mistakes"] = {
		dv = function() return B() .. "choices/3/gabriel/we_all_make_mistakes" end,
		sq = { k = "they_could_be_alive", n = "c4/alive"   },
		ci = { k = "nothing_you_can_do",  n = "c4/nothing" },
	},
	["c3/gabriel/just"] = {
		dv = function() return B() .. "choices/3/gabriel/just_have_our_back" end,
		sq = { k = "they_could_be_alive", n = "c4/alive"   },
		ci = { k = "nothing_you_can_do",  n = "c4/nothing" },
	},
	["c3/gabriel/youll"] = {
		dv = function() return B() .. "choices/3/gabriel/youll_get_a_chance" end,
		sq = { k = "they_could_be_alive", n = "c4/alive"   },
		ci = { k = "nothing_you_can_do",  n = "c4/nothing" },
	},
	["c3/petra/ivors"] = {
		dv = function() return B() .. "choices/3/petra/its_ivors_fault" end,
		sq = { k = "they_could_be_alive", n = "c4/alive"   },
		ci = { k = "nothing_you_can_do",  n = "c4/nothing" },
	},
	["c3/petra/didnt"] = {
		dv = function() return B() .. "choices/3/petra/you_didnt_know" end,
		sq = { k = "they_could_be_alive", n = "c4/alive"   },
		ci = { k = "nothing_you_can_do",  n = "c4/nothing" },
	},

	-- C4 nodes (sq uses choices_one)
	["c4/alive"] = {
		dv = function() return B() .. "choices/4/they_could_be_alive" end,
		sq = { k = "the_order_has_failed", tab = choices_one, n = "c5/failed" },
		ci = { k = "the_world_needs_us",                       n = "c5/world"  },
	},
	["c4/nothing"] = {
		dv = function() return B() .. "choices/4/nothing_you_can_do" end,
		sq = { k = "the_order_has_failed", tab = choices_one, n = "c5/failed" },
		ci = { k = "the_world_needs_us",                       n = "c5/world"  },
	},

	-- C5 nodes
	["c5/failed"] = {
		dv = function() return B() .. "choices/5/the_order_has_failed" end,
		sq = { k = "let_it_chase_us", n = "c6/chase"  },
		ci = { k = "use_the_amulet",  n = "c6/amulet" },
	},
	["c5/world"] = {
		dv = function() return B() .. "choices/5/the_world_needs_us_reuben" end,
		sq = { k = "let_it_chase_us", n = "c6/chase"  },
		ci = { k = "use_the_amulet",  n = "c6/amulet" },
	},

	-- C6 nodes (sq and ci use choices_five)
	["c6/chase"] = {
		dv = function() return B() .. "choices/6/let_it_chase_us" end,
		sq = { k = "warrior_whip", tab = choices_five, n = "c7/whip" },
		ci = { k = "redstone_rap", tab = choices_five, n = "c7/rap"  },
	},
	["c6/amulet"] = {
		dv = function() return B() .. "choices/6/use_the_amulet" end,
		sq = { k = "warrior_whip", tab = choices_five, n = "c7/whip" },
		ci = { k = "redstone_rap", tab = choices_five, n = "c7/rap"  },
	},

	-- C7 nodes
	["c7/whip"] = {
		dv = function() return B() .. "choices/7/warrior_whip" end,
		sq = { k = "are_we_there_yet", n = "c8/there" },
		ci = { k = "we_must_be_close",  n = "c8/close" },
	},
	["c7/rap"] = {
		dv = function() return B() .. "choices/7/redstone_rap" end,
		sq = { k = "are_we_there_yet", n = "c8/there" },
		ci = { k = "we_must_be_close",  n = "c8/close" },
	},

	-- C8 nodes
	["c8/there"] = {
		dv = function() return B() .. "choices/8/are_we_there_yet" end,
		sq = { k = "lets_head_back",    n = "c9/back" },
		ci = { k = "we_need_that_cake", n = "c9/cake" },
	},
	["c8/close"] = {
		dv = function() return B() .. "choices/8/we_must_be_close" end,
		sq = { k = "lets_head_back",    n = "c9/back" },
		ci = { k = "we_need_that_cake", n = "c9/cake" },
	},

	-- C9 nodes
	["c9/back"] = {
		dv = function() return B() .. "choices/9/lets_head_back" end,
		sq = { k = "ill_distract_them",  n = "c10/distract" },
		ci = { k = "get_ready_to_fight", n = "c10/fight"    },
	},
	["c9/cake"] = {
		dv = function() return B() .. "choices/9/we_need_that_cake" end,
		sq = { k = "i_have_no_idea",  n = "c10/idea"   },
		ci = { k = "he_bailed_on_me", n = "c10/bailed" },
	},

	-- C10 nodes
	["c10/distract"] = {
		dv = function() return B() .. "choices/10/ill_distract_them" end,
		sq = { k = "lets_go_inside",   n = "c11/inside" },
		ci = { k = "find_another_way", n = "c11/way"    },
	},
	["c10/fight"] = {
		dv = function() return B() .. "choices/10/get_ready_to_fight" end,
		sq = { k = "lets_go_inside",   n = "c11/inside" },
		ci = { k = "find_another_way", n = "c11/way"    },
	},
	["c10/idea"] = {
		dv = function() return B() .. "choices/10/cake/i_have_no_idea" end,
		sq = { k = "lets_go_inside",   n = "c11/inside" },
		ci = { k = "find_another_way", n = "c11/way"    },
	},
	["c10/bailed"] = {
		dv = function() return B() .. "choices/10/cake/he_bailed_on_me" end,
		sq = { k = "lets_go_inside",   n = "c11/inside" },
		ci = { k = "find_another_way", n = "c11/way"    },
	},

	-- C11 nodes
	["c11/inside"] = {
		dv = function() return B() .. "choices/11/lets_go_inside" end,
		sq = { k = "were_back_together",  n = "c12/back"     },
		ci = { k = "we_have_to_continue", n = "c12/continue" },
	},
	["c11/way"] = {
		dv = function() return B() .. "choices/11/find_another_way" end,
		sq = { k = "were_back_together",  n = "c12/back"     },
		ci = { k = "we_have_to_continue", n = "c12/continue" },
	},

	-- C12 nodes
	["c12/back"] = {
		dv = function() return B() .. "choices/12/were_back_together" end,
		sq = { k = "we_won_at_endercon",    n = "c13/won"      },
		ci = { k = "we_reunited_the_order", n = "c13/reunited" },
	},
	["c12/continue"] = {
		dv = function() return B() .. "choices/12/we_have_to_continue" end,
		sq = { k = "we_won_at_endercon",    n = "c13/won"      },
		ci = { k = "we_reunited_the_order", n = "c13/reunited" },
	},

	-- C13 nodes
	["c13/won"] = {
		dv = function() return B() .. "choices/13/we_won_at_endercon" end,
		sq = { k = "craft_sticky_piston",  n = "c14/piston" },
		ci = { k = "craft_redstone_block", n = "c14/block"  },
	},
	["c13/reunited"] = {
		dv = function() return B() .. "choices/13/we_reunited_the_order" end,
		sq = { k = "craft_sticky_piston",  n = "c14/piston" },
		ci = { k = "craft_redstone_block", n = "c14/block"  },
	},

	-- C14 nodes (gp-specific choice labels)
	["c14/piston"] = {
		dv = function() return B() .. "choices/14/craft_sticky_piston" end,
		sq = { dk = function() return gp == "gabriel" and "that_was_endercon"   or "is_that_true"   end, n = "c15/a" },
		ci = { dk = function() return gp == "gabriel" and "the_chicken_machine" or "youre_afraid"   end, n = "c15/b" },
	},
	["c14/block"] = {
		dv = function() return B() .. "choices/14/craft_redstone_block" end,
		sq = { dk = function() return gp == "gabriel" and "that_was_endercon"   or "is_that_true"   end, n = "c15/a" },
		ci = { dk = function() return gp == "gabriel" and "the_chicken_machine" or "youre_afraid"   end, n = "c15/b" },
	},

	-- C15 nodes (gp-specific video path, no choice)
	["c15/a"] = {
		dv = function()
			return B() .. "choices/15/" .. (gp == "gabriel" and "that_was_endercon" or "is_that_true")
		end,
		n = "c16/zone",
	},
	["c15/b"] = {
		dv = function()
			return B() .. "choices/15/" .. (gp == "gabriel" and "the_chicken_machine" or "youre_afraid")
		end,
		n = "c16/zone",
	},

	-- C16: interactive zone + lever choice
	["c16/zone"]  = { zone = zone_ivors },
	["c16/lever"] = {
		dv = function() return B() .. "choices/16/lever" end,
		sq = { k = "is_the_dragon_a_clue",    n = "c17/dragon"   },
		ci = { k = "are_those_ender_crystals", n = "c17/crystals" },
	},

	-- C17 nodes
	["c17/dragon"] = {
		dv = function() return B() .. "choices/17/is_the_dragon_a_clue" end,
		sq = { k = "that_was_amazing", n = "c18/amazing" },
		ci = { k = "youre_full_of_it", n = "c18/full"    },
	},
	["c17/crystals"] = {
		dv = function() return B() .. "choices/17/are_those_ender_crystals" end,
		sq = { k = "that_was_amazing", n = "c18/amazing" },
		ci = { k = "youre_full_of_it", n = "c18/full"    },
	},

	-- C18 nodes
	["c18/amazing"] = {
		dv = function() return B() .. "choices/18/that_was_amazing" end,
		sq = { k = "i_looked_up_to_you",   n = "c19/looked" },
		ci = { k = "you_lied_to_everyone",  n = "c19/lied"   },
	},
	["c18/full"] = {
		dv = function() return B() .. "choices/18/youre_full_of_it" end,
		sq = { k = "i_looked_up_to_you",   n = "c19/looked" },
		ci = { k = "you_lied_to_everyone",  n = "c19/lied"   },
	},

	-- C19 nodes
	["c19/looked"] = {
		dv = function() return B() .. "choices/19/i_looked_up_to_you" end,
		sq = { k = "youre_a_mad_man",    n = "c20/mad"    },
		ci = { k = "how_is_this_better", n = "c20/better" },
	},
	["c19/lied"] = {
		dv = function() return B() .. "choices/19/you_lied_to_everyone" end,
		sq = { k = "youre_a_mad_man",    n = "c20/mad"    },
		ci = { k = "how_is_this_better", n = "c20/better" },
	},

	-- C20 nodes (weapon split)
	["c20/mad"] = {
		dv = function() return B() .. "choices/20/youre_a_mad_man" end,
		sq = { k = "craft_diamond_hoe",     n = "c21/hoe"  },
		ci = { k = "craft_diamond_pickaxe", n = "c21/pick" },
	},
	["c20/better"] = {
		dv = function() return B() .. "choices/20/how_is_this_better" end,
		sq = { k = "craft_diamond_hoe",     n = "c21/hoe"  },
		ci = { k = "craft_diamond_pickaxe", n = "c21/pick" },
	},

	-- C21 nodes
	["c21/hoe"] = {
		dv = function() return B() .. "choices/21/craft_diamond_hoe" end,
		sq = { k = "i_made_a_weapon",    n = "c22/made_h"  },
		ci = { k = "fight_to_the_death", n = "c22/fight_h" },
	},
	["c21/pick"] = {
		dv = function() return B() .. "choices/21/craft_diamond_pickaxe" end,
		sq = { k = "i_made_a_weapon",    n = "c22/made_p"  },
		ci = { k = "fight_to_the_death", n = "c22/fight_p" },
	},

	-- C22 nodes
	["c22/made_h"] = {
		dv = function() return B() .. "choices/22/i_made_a_weapon_hoe" end,
		sq = { k = "come_back",  n = "c23/cb_h"  },
		ci = { k = "you_coward", n = "c23/cow_h" },
	},
	["c22/fight_h"] = {
		dv = function() return B() .. "choices/22/fight_to_the_death_hoe" end,
		sq = { k = "come_back",  n = "c23/cb_h"  },
		ci = { k = "you_coward", n = "c23/cow_h" },
	},
	["c22/made_p"] = {
		dv = function() return B() .. "choices/22/i_made_a_weapon_pickaxe" end,
		sq = { k = "come_back",  n = "c23/cb_p"  },
		ci = { k = "you_coward", n = "c23/cow_p" },
	},
	["c22/fight_p"] = {
		dv = function() return B() .. "choices/22/fight_to_the_death_pickaxe" end,
		sq = { k = "come_back",  n = "c23/cb_p"  },
		ci = { k = "you_coward", n = "c23/cow_p" },
	},

	-- C23 nodes (3-button tri choice)
	["c23/cb_h"] = {
		dv  = function() return B() .. "choices/23/come_back_hoe" end,
		sq  = { k = "tnt_launcher",   n = "c24/tnt_h"   },
		ci  = { k = "rocket_minecart", n = "c24/rocket_h" },
		tri = { k = "flying_machine",  n = "c24/fly_h"   },
	},
	["c23/cow_h"] = {
		dv  = function() return B() .. "choices/23/you_coward_hoe" end,
		sq  = { k = "tnt_launcher",   n = "c24/tnt_h"   },
		ci  = { k = "rocket_minecart", n = "c24/rocket_h" },
		tri = { k = "flying_machine",  n = "c24/fly_h"   },
	},
	["c23/cb_p"] = {
		dv  = function() return B() .. "choices/23/come_back_pickaxe" end,
		sq  = { k = "tnt_launcher",   n = "c24/tnt_p"   },
		ci  = { k = "rocket_minecart", n = "c24/rocket_p" },
		tri = { k = "flying_machine",  n = "c24/fly_p"   },
	},
	["c23/cow_p"] = {
		dv  = function() return B() .. "choices/23/you_coward_pickaxe" end,
		sq  = { k = "tnt_launcher",   n = "c24/tnt_p"   },
		ci  = { k = "rocket_minecart", n = "c24/rocket_p" },
		tri = { k = "flying_machine",  n = "c24/fly_p"   },
	},

	-- C24 nodes
	["c24/tnt_h"] = {
		dv = function() return B() .. "choices/24/tnt_launcher_hoe" end,
		sq = { k = "ill_be_fine", n = "c25/fine_h"   },
		ci = { k = "stay_hidden", n = "c25/hidden_h" },
	},
	["c24/rocket_h"] = {
		dv = function() return B() .. "choices/24/rocket_minecart_hoe" end,
		sq = { k = "ill_be_fine", n = "c25/fine_h"   },
		ci = { k = "stay_hidden", n = "c25/hidden_h" },
	},
	["c24/fly_h"] = {
		dv = function() return B() .. "choices/24/flying_machine_hoe" end,
		sq = { k = "ill_be_fine", n = "c25/fine_h"   },
		ci = { k = "stay_hidden", n = "c25/hidden_h" },
	},
	["c24/tnt_p"] = {
		dv = function() return B() .. "choices/24/tnt_launcher_pickaxe" end,
		sq = { k = "ill_be_fine", n = "c25/fine_p"   },
		ci = { k = "stay_hidden", n = "c25/hidden_p" },
	},
	["c24/rocket_p"] = {
		dv = function() return B() .. "choices/24/rocket_minecart_pickaxe" end,
		sq = { k = "ill_be_fine", n = "c25/fine_p"   },
		ci = { k = "stay_hidden", n = "c25/hidden_p" },
	},
	["c24/fly_p"] = {
		dv = function() return B() .. "choices/24/flying_machine_pickaxe" end,
		sq = { k = "ill_be_fine", n = "c25/fine_p"   },
		ci = { k = "stay_hidden", n = "c25/hidden_p" },
	},

	-- C25 nodes (weapon suffix drops after this)
	["c25/fine_h"] = {
		dv = function() return B() .. "choices/25/ill_be_fine_hoe" end,
		sq = { k = "everyone_okay", n = "c26/okay"   },
		ci = { k = "wheres_reuben", n = "c26/reuben" },
	},
	["c25/hidden_h"] = {
		dv = function() return B() .. "choices/25/stay_hidden_hoe" end,
		sq = { k = "everyone_okay", n = "c26/okay"   },
		ci = { k = "wheres_reuben", n = "c26/reuben" },
	},
	["c25/fine_p"] = {
		dv = function() return B() .. "choices/25/ill_be_fine_pickaxe" end,
		sq = { k = "everyone_okay", n = "c26/okay"   },
		ci = { k = "wheres_reuben", n = "c26/reuben" },
	},
	["c25/hidden_p"] = {
		dv = function() return B() .. "choices/25/stay_hidden_pickaxe" end,
		sq = { k = "everyone_okay", n = "c26/okay"   },
		ci = { k = "wheres_reuben", n = "c26/reuben" },
	},

	-- C26 nodes
	["c26/okay"] = {
		dv = function() return B() .. "choices/26/everyone_okay" end,
		sq = { k = "reuben_i_need_you",   n = "c27/reuben"  },
		ci = { k = "im_here_for_you_boy", n = "c27/im_here" },
	},
	["c26/reuben"] = {
		dv = function() return B() .. "choices/26/wheres_reuben" end,
		sq = { k = "reuben_i_need_you",   n = "c27/reuben"  },
		ci = { k = "im_here_for_you_boy", n = "c27/im_here" },
	},

	-- C27 nodes
	["c27/reuben"] = {
		dv = function() return B() .. "choices/27/reuben_i_need_you" end,
		sq = { k = "just_let_them_believe",  n = "c28/just"  },
		ci = { k = "they_deserve_the_truth", n = "c28/truth" },
	},
	["c27/im_here"] = {
		dv = function() return B() .. "choices/27/im_here_for_you_boy" end,
		sq = { k = "just_let_them_believe",  n = "c28/just"  },
		ci = { k = "they_deserve_the_truth", n = "c28/truth" },
	},

	-- C28 nodes
	["c28/just"] = {
		dv = function() return B() .. "choices/28/just_let_them_believe" end,
		sq = { k = "my_pig_reuben",    n = "c29/pig"   },
		ci = { k = "saving_the_world", n = "c29/world" },
	},
	["c28/truth"] = {
		dv = function() return B() .. "choices/28/they_deserve_the_truth" end,
		sq = { k = "my_pig_reuben",    n = "c29/pig"   },
		ci = { k = "saving_the_world", n = "c29/world" },
	},

	-- C29 endings
	["c29/pig"]   = { dv = function() return B() .. "choices/29/my_pig_reuben"    end, post = ep4_end },
	["c29/world"] = { dv = function() return B() .. "choices/29/saving_the_world" end, post = ep4_end },
}

local current = ep4_node or "start"
ep4_node = nil
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
			ep4_node = current
			nextscene = EP_FILE
			if node.tri then
				local tri_txt = resolve_label(node.tri)
				ui3(sq_txt, ci_txt, tri_txt)
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
					elseif buttons.pressed(buttons.triangle) then
						current = node.tri.n
						chose = true
					elseif buttons.pressed(buttons.start) then
						local p = dofile("assets/misc/pause.lua")
						if p == -1 then nextscene = "./mainmenu.lua"; return 1 end
						ui3(sq_txt, ci_txt, tri_txt)
					elseif buttons.pressed(buttons.r) then
						SaveGame(4)
					end
				end
			else
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
						SaveGame(4)
					end
				end
			end
		elseif node.n then
			current = node.n
		else
			break
		end
	end
end
