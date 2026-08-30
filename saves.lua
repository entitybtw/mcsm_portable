-- saves.lua — сохранение эпизодов в единое JSON-хранилище.
local suffixes = { "st", "nd", "rd", "th", "th" }
local episodeVars = {
	[1] = { "reuben", "building", "sword", "ep1_node", "1_status" },
	[2] = { "ep2_node", "2_status" },
	[3] = { "ep3_node", "3_status" },
	[4] = { "ep4_node", "4_status" },
	[5] = { "ep5_node", "save", "mi", "5_status" },
}

function SaveGame(episodeNumber)
	System.SaveData(
		nextscene,
		episodeNumber .. suffixes[episodeNumber] .. " episode save",
		"Minecraft Story Mode Save",
		"EBOOT.PBP",
		"assets/ui/saves_icon.png",
		"assets/ui/saves_bg.png"
	)

	-- статусы (в JSON через wr)
	wr(episodeNumber .. "_status", "continue")
	for i = episodeNumber + 1, 5 do
		rm(i .. "_status")
		_G["status_" .. i] = nil
	end

	-- переменные эпизода: сохраняем в секцию "saves" ключ "episode<N>"
	local vars = episodeVars[episodeNumber]
	local saved = {}
	for _, key in ipairs(vars) do
		local val = _G[key]
		if val ~= nil then saved[key] = tostring(val) end
	end
	sav.set("saves", "episode" .. episodeNumber, saved)
end

-- восстановить переменные сохранённого эпизода в глобалы (вызвать при возврате в эпизод)
function LoadEpisodeVars(episodeNumber)
	local saved = sav.get("saves", "episode" .. episodeNumber)
	if not saved then return end
	for key, val in pairs(saved) do
		_G[key] = val
	end
end

-- очистить сохранение эпизода
function ClearEpisodeSave(episodeNumber)
	sav.del("saves", "episode" .. episodeNumber)
	rm(episodeNumber .. "_status")
end
