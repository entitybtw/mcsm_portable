-- only assets/saves path
function wr(fileName, content)
	if type(fileName) ~= "string" or fileName == "" then
		return
	end
	if type(content) ~= "string" then
		return
	end

	local filePath = string.format("assets/saves/%s.txt", fileName)
	local file = io.open(filePath, "w")
	if file then
		file:write(content)
		file:close()
	end

	System.GC()
end
-- any path
function checkFile(filePath, globalVarName)
	local file = io.open(filePath, "r")
	if not file then
		return false
	end
	local content = file:read("*l")
	file:close()
	globalVarName = content
	return true
end
function cnt(filePath)
	local file = io.open(filePath, "r")
	if not file then
		return false
	end
	local content = file:read("*l")
	file:close()
	return content
end
