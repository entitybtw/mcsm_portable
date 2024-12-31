function wr(fileName, content)
    -- Check if the file name is a string and not empty
    if type(fileName) ~= "string" or fileName == "" then
        print("Error: File name must be a non-empty string.")
        return
    end

    -- Check if the content is a string
    if type(content) ~= "string" then
        print("Error: Content must be a string.")
        return
    end

    -- File path
    local filePath = string.format("assets/saves/%s.txt", fileName)

    -- Try to open the file for writing
    local file, err = io.open(filePath, 'w')
    if file then
        file:write(content)
        file:close()
        print("Content written to file:", filePath)
    else
        print("Write error:", err)
    end

    -- Free memory (if necessary)
    System.GC()
end

function rm(...)
    -- Get the list of passed arguments
    local files = {...}

    -- Check if at least one argument is provided
    if #files == 0 then
        print("Error: No file names provided.")
        return
    end

    -- Iterate through all provided file names
    for _, fileName in ipairs(files) do
        -- Check if the file name is a string and not empty
        if type(fileName) ~= "string" or fileName == "" then
            print("Error: Invalid file name. Skipping.")
        else
            -- File path
            local filePath = string.format("assets/saves/%s.txt", fileName)

            -- Check if the file exists
            local fileExists = io.open(filePath, "r")
            if fileExists then
                fileExists:close() -- Close the file after checking

                -- Delete the file
                local success, err = System.removeFile(filePath)
                if success then
                    print("File deleted:", filePath)
                else
                    print("Delete error:", err)
                end
            else
                print("File does not exist:", filePath)
            end
        end
    end

    -- Free memory (if necessary)
    System.GC()
end
