local suffixes = { "st", "nd", "rd", "th", "th" }
local episodeVars = {
	[1] = { "reuben", "building", "sword", "ep1_node" },
	[2] = { "ep2_node" },
	[3] = { "ep3_node" },
	[4] = { "ep4_node" },
	[5] = { "ep5_node", "save", "mi" },
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
	wr(episodeNumber .. "_status", "continue")
	for i = episodeNumber + 1, 5 do
		rm(i .. "_status")
		_G["status_" .. i] = nil
	end

	local vars = episodeVars[episodeNumber]
	if not vars then return end

	local file = io.open(string.format("assets/saves/%d_variables.txt", episodeNumber), "w")
	if file then
		for _, key in ipairs(vars) do
			local val = _G[key]
			if val ~= nil then
				file:write(string.format('%s = "%s"\n', key, tostring(val)))
			end
		end
		file:close()
	end
end
