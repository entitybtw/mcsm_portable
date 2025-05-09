-- Function to save the game to two files: save and variables, considering the episode number
function SaveGame(episodeNumber)
    -- Check if the episode number is valid
    if type(episodeNumber) ~= "number" or episodeNumber < 1 or episodeNumber > 7 then
        print("Error: Episode number must be a number between 1 and 7.")
        return
    end

    -- Ensure save directory exists
    local saveDir = "assets/saves/"
    os.execute("mkdir -p " .. saveDir)

    -- Paths to the save files
    local saveFilePath = string.format("%s%d_save.txt", saveDir, episodeNumber)
    local variablesFilePath = string.format("%s%d_variables.txt", saveDir, episodeNumber)

    -- Get the current script path
    local script = debug.getinfo(2).source:sub(2)

    -- Save the script path
    local saveFile, saveErr = io.open(saveFilePath, "w")
    if saveFile then
        saveFile:write(script)
        saveFile:close()
        print("Game saved to file:", saveFilePath)
    else
        print("Save error:", saveErr)
        return
    end

    -- Skip variable saving for episode 2
    if episodeNumber == 2 then
        print("Note: Skipping variable saving for episode 2.")
    else
        -- Variables to save
        local variables = {}

        if episodeNumber == 1 then
            variables = {
                reuben = reuben,
                tall_grass = tall_grass,
                building = building,
                pedestal = pedestal,
                slime = slime
            }
        else
            print("Warning: No variables defined for this episode.")
        end

        -- Save the variables
        local variablesFile, varErr = io.open(variablesFilePath, "w")
        if variablesFile then
            for key, value in pairs(variables) do
                if value ~= nil then
                    variablesFile:write(string.format("%s = \"%s\"\n", key, tostring(value)))
                end
            end
            variablesFile:close()
            print("Variables saved to file:", variablesFilePath)
        else
            print("Save error:", varErr)
        end
    end

    -- Play saving video
    PMP.setVolume(pmpvolume)
    PMP.play("assets/mainmenu/lsave.pmp")

    -- Garbage collection
    System.GC()
end

function LoadGame(episodeNumber)
    if type(episodeNumber) ~= "number" or episodeNumber < 1 or episodeNumber > 7 then
        print("Error: Episode number must be a number between 1 and 7.")
        return nil
    end

    local saveFilePath = string.format("assets/saves/%d_save.txt", episodeNumber)
    local variablesFilePath = string.format("assets/saves/%d_variables.txt", episodeNumber)

    local saveFile = io.open(saveFilePath, "rb")
    if not saveFile then
        print("Error: Save file not found.")
        return nil
    end

    local saveContent = saveFile:read("*a")
    saveFile:close()
    print("Save file content loaded:", saveContent)

    local loadedVariables = {}
    local variablesFile = io.open(variablesFilePath, "r")
    if variablesFile then
        for line in variablesFile:lines() do
            local key, value = line:match("^(%w+) = \"([^\"]+)\"$")
            if key then
                loadedVariables[key] = value
            end
        end
        variablesFile:close()

        for key, value in pairs(loadedVariables) do
            print(string.format("Loaded variable: %s = %s", key, value))
        end
    else
        print("Note: No variables file found, continuing without variables.")
    end

    return saveContent, loadedVariables
end
function checkFile(filePath, globalVarName)
    local file = io.open(filePath, "r")
    if not file then return false end
    local content = file:read("*l")
    file:close()
    _G[globalVarName] = content
    return true
end
