function SaveGame(episodeNumber)
	local suffix = ""

	if episodeNumber == 1 then
		suffix = "st"
	elseif episodeNumber == 2 then
		suffix = "nd"
	elseif episodeNumber == 3 then
		suffix = "rd"
	elseif episodeNumber == 4 or episodeNumber == 5 then
		suffix = "th"
	end
	System.SaveData(
		nextscene,
		episodeNumber .. suffix .. " episode save",
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

	if episodeNumber == 1 then
		local saveDir = "assets/saves/"
		local variablesFilePath = string.format("%s%d_variables.txt", saveDir, episodeNumber)

		local variables = {
			reuben = reuben,
			building = building,
			sword = sword,
			ep1_node = ep1_node,
		}

		local file, err = io.open(variablesFilePath, "w")
		if file then
			for key, value in pairs(variables) do
				if value ~= nil then
					file:write(string.format('%s = "%s"\n', key, tostring(value)))
				end
			end
			file:close()
		end
	elseif episodeNumber == 2 then
		local saveDir = "assets/saves/"
		local variablesFilePath = string.format("%s%d_variables.txt", saveDir, episodeNumber)

		local variables = {
			ep2_node = ep2_node,
		}

		local file, err = io.open(variablesFilePath, "w")
		if file then
			for key, value in pairs(variables) do
				if value ~= nil then
					file:write(string.format('%s = "%s"\n', key, tostring(value)))
				end
			end
			file:close()
		end
	elseif episodeNumber == 3 then
		local saveDir = "assets/saves/"
		local variablesFilePath = string.format("%s%d_variables.txt", saveDir, episodeNumber)

		local variables = {
			ep3_node = ep3_node,
		}

		local file, err = io.open(variablesFilePath, "w")
		if file then
			for key, value in pairs(variables) do
				if value ~= nil then
					file:write(string.format('%s = "%s"\n', key, tostring(value)))
				end
			end
			file:close()
		end
	elseif episodeNumber == 5 then
		local saveDir = "assets/saves/"
		local variablesFilePath = string.format("%s%d_variables.txt", saveDir, episodeNumber)

		local variables = {
			save = save,
			mi = mi,
		}

		local file, err = io.open(variablesFilePath, "w")
		if file then
			for key, value in pairs(variables) do
				if value ~= nil then
					file:write(string.format('%s = "%s"\n', key, tostring(value)))
				end
			end
			file:close()
		end
	end
end
