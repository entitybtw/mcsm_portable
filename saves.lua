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
    local script = debug.getinfo(2).source:sub(2) -- For example, "./name.lua"

    -- Save the script path (game state) in the save file
    local saveFile, saveErr = io.open(saveFilePath, "w")
    if saveFile then
        saveFile:write(script)  -- Write the script path to the save file
        saveFile:close()
        print("Game saved to file:", saveFilePath)
    else
        print("Save error:", saveErr)
        return
    end

    -- Variables to save (specific to episode number)
    local variables = {}
    if episodeNumber == 1 then
        variables = {
            reuben = reuben,
            tall_grass = tall_grass,
            building = building,
            pedestal = pedestal,
            slime = slime
        }
    elseif episodeNumber == 2 then
        variables = {
            -- Add your variables specific to episode 2
        }
    -- Add more `elseif` for each episode (3 to 7)
    else
        print("Error: No variables set for this episode.")
        return
    end

    -- Save the variables to the variables file
    local variablesFile, varErr = io.open(variablesFilePath, "w")
    if variablesFile then
        -- Write each variable to the file as a Lua assignment statement
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

    -- Play save sound effect
    PMP.play('assets/mainmenu/lsave.pmp')

    -- Perform garbage collection
    System.GC()
end

-- Function to load the game
function LoadGame(episodeNumber)
    -- Validate that the episode number is correct
    if type(episodeNumber) ~= "number" or episodeNumber < 1 or episodeNumber > 7 then
        print("Error: Episode number must be a number between 1 and 7.")
        return nil
    end

    -- Path to the save file and variables file
    local saveFilePath = string.format("assets/saves/%d_save.txt", episodeNumber)
    local variablesFilePath = string.format("assets/saves/%d_variables.txt", episodeNumber)

    -- Attempt to open the save file for reading
    local saveFile = io.open(saveFilePath, "rb")
    if not saveFile then
        print("Error: Save file not found.")
        return nil
    end

    -- Read the content of the save file (script path or game state)
    local saveContent = saveFile:read("*a")
    saveFile:close()
    print("Save file content loaded:", saveContent)

    -- Attempt to open the variables file for reading
    local variablesFile = io.open(variablesFilePath, "r")
    if not variablesFile then
        print("Error: Variables file not found.")
        return nil
    end

    -- Load variables from the file
    local loadedVariables = {}
    for line in variablesFile:lines() do
        -- Expecting lines in the form of "key = value"
        local key, value = line:match("^(%w+) = \"([^\"]+)\"$")
        if key then
            loadedVariables[key] = value
        end
    end
    variablesFile:close()

    -- Print the loaded variables (for debugging)
    for key, value in pairs(loadedVariables) do
        print(string.format("Loaded variable: %s = %s", key, value))
    end

    -- Return both the save content and the loaded variables
    return saveContent, loadedVariables
end
