-- only assets/saves path
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
-- any path
function checkFile(filePath, globalVarName)
    local file = io.open(filePath, "r")
    if not file then return false end
    local content = file:read("*l")
    file:close()
    globalVarName = content
    return true
end
function fileExists(filePath)
    local file = io.open(filePath, "r")
    if file then
        file:close()
        return true
    else
        return false
    end
end
function cnt(filePath)
    local file = io.open(filePath, "r")
    if not file then return false end
    local content = file:read("*l")
    file:close()
    return content
end