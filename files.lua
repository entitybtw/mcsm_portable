-- writes content to a file in assets/saves
function wr(fileName, content)
    if type(fileName) ~= "string" or fileName == "" then return end
    if type(content) ~= "string" then return end

    local filePath = string.format("assets/saves/%s.txt", fileName)
    local file = io.open(filePath, 'w')
    if file then
        file:write(content)
        file:close()
    end

    System.GC()
end

-- remove files from assets/saves
function rm(...)
    local files = {...}
    if #files == 0 then return end

    for _, fileName in ipairs(files) do
        if type(fileName) == "string" and fileName ~= "" then
            local filePath = string.format("assets/saves/%s.txt", fileName)
            local fileExists = io.open(filePath, "r")
            if fileExists then
                fileExists:close()
                System.removeFile(filePath)
            end
        end
    end

    System.GC()
end