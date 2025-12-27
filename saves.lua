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
    System.SaveData(nextscene, episodeNumber .. suffix .. " episode save", "Minecraft Story Mode Save", "EBOOT.PBP", "assets/buttons/saves_icon.png", "assets/mainmenu/saves_bg.png")
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
        }

        local file, err = io.open(variablesFilePath, "w")
        if file then
            for key, value in pairs(variables) do
                if value ~= nil then
                    file:write(string.format("%s = \"%s\"\n", key, tostring(value)))
                end
            end
            file:close()
        end
    elseif episodeNumber == 5 then
        local saveDir = "assets/saves/"
        local variablesFilePath = string.format("%s%d_variables.txt", saveDir, episodeNumber)

        local variables = {
            save = save,
            mi = mi
        }

        local file, err = io.open(variablesFilePath, "w")
        if file then
            for key, value in pairs(variables) do
                if value ~= nil then
                    file:write(string.format("%s = \"%s\"\n", key, tostring(value)))
                end
            end
            file:close()
        end
    end
end