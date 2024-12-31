 -- Function to save the game to a file considering the episode number
function SaveGame(episodeNumber)
    -- Check if the episode number is valid
    if type(episodeNumber) ~= "number" or episodeNumber < 1 or episodeNumber > 7 then
        print("Error: Episode number must be a number between 1 and 7.")
        return
    end

    -- Path to the save file
    local filePath = string.format("assets/saves/%d_save.txt", episodeNumber)

    -- Get the current script path
    local script = debug.getinfo(2).source:sub(2) -- For example, "./name.lua"

    -- Attempt to open the file for writing
    local file, err = io.open(filePath, 'w')
    if file then
        file:write(script)
        file:close()
        print("Game saved to file:", filePath)
    else
        print("Save error:", err)
    end
    
    System.GC()
end

function LoadGame(episodeNumber)
    -- Validate that the episode number is correct
    if type(episodeNumber) ~= "number" or episodeNumber < 1 or episodeNumber > 7 then
        print("Error: Episode number must be a number between 1 and 7.")
        return nil
    end

    -- Path to the save file
    local filePath = string.format("assets/saves/%d_save.txt", episodeNumber)

    -- Attempt to open the file for reading
    local file = io.open(filePath, "rb")
    if not file then
        print("Error: Save file not found.")
        return nil
    end

    -- Read the content of the file
    local content = file:read("*a")
    file:close()
    return content
end
