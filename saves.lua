-- Function to save the game to a file considering the episode number
function SaveGame(episodeNumber)
    -- Check if the episode number is valid
    if type(episodeNumber) ~= "number" or episodeNumber < 1 or episodeNumber > 7 then
        print("Error: Episode number must be a number between 1 and 7.")
        return
    end

    -- Path to the save file
    local filePath = "assets/saves/variables_1.txt"

    -- Variables to save
    local variables = {
        reuben = reuben,
        tall_grass = tall_grass,
        creeper = creeper,
        pedestal = pedestal,
        slime = slime
    }

    -- Open the file for writing (only for episode 1)
    if episodeNumber == 1 then
        local file, err = io.open(filePath, "w")
        if not file then
            print("Save error:", err)
            return
        end

        -- Write non-nil variables to the file
        for key, value in pairs(variables) do
            if value ~= nil then
                file:write(string.format("%s = \"%s\"\n", key, tostring(value)))
            end
        end

        file:close()
        print("Game saved to file:", filePath)
        PMP.play("assets/mainmenu/lsave.pmp")
    else
        print("Save function is only available for episode 1.")
    end

    System.GC()
end

-- Function to load the game from a file considering the episode number
function LoadGame(episodeNumber)
    -- Validate that the episode number is correct
    if type(episodeNumber) ~= "number" or episodeNumber < 1 or episodeNumber > 7 then
        print("Error: Episode number must be a number between 1 and 7.")
        return nil
    end

    -- Path to the save file
    local filePath = "assets/saves/variables_1.txt"

    -- Open the file for reading (only for episode 1)
    if episodeNumber == 1 then
        local file = io.open(filePath, "r")
        if not file then
            print("Error: Save file not found.")
            return nil
        end

        -- Read and load variables from the file
        for line in file:lines() do
            local key, value = line:match("(%w+) = \"(.-)\"")
            if key and value then
                _G[key] = value -- Set the global variable
            end
        end

        file:close()
        print("Game loaded from file:", filePath)
    else
        print("Load function is only available for episode 1.")
    end
end
