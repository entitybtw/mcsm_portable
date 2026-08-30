-- files.lua — обёртка над единым JSON-хранилищем (assets/saves/data.json).
--
-- Все прежние текстовые файлики (em.txt, gp.txt, 2_status.txt ...) теперь живут
-- в JSON-секции "vars" с ключами = имя без пути/расширения. Старые .txt читаются
-- один раз для миграции, затем работаем только через JSON.

local function name_from(path)
	local n = tostring(path or "")
	-- убрать "assets/saves/" и окончание ".txt"
	n = n:gsub("^assets/saves/", ""):gsub("%.txt$", "")
	return n
end

-- записать строку в JSON (wr(name[,content]))
function wr(fileName, content)
	if type(fileName) ~= "string" or fileName == "" then return end
	if type(content) ~= "string" then content = tostring(content) end
	local key = name_from(fileName)
	sav.set("vars", key, content)
end

-- проверить наличие и записать в глобал (checkFile(path, globalVarName))
function checkFile(filePath, globalVarName)
	local key = name_from(filePath)
	local v = sav.get("vars", key)
	if v == nil then
		-- миграция: попробовать старый .txt
		local f = io.open(filePath, "r")
		if not f then return false end
		v = f:read("*l")
		f:close()
		sav.set("vars", key, v)
	end
	_G[globalVarName] = v
	return true
end

-- прочитать строку (cnt(path)) — возвращает значение или false
function cnt(filePath)
	local key = name_from(filePath)
	local v = sav.get("vars", key)
	if v == nil then
		local f = io.open(filePath, "r")
		if not f then return false end
		v = f:read("*l")
		f:close()
		sav.set("vars", key, v)
	end
	return v
end

-- удалить записи (rm(...имена)) — принимает имена или полные пути, и старые .txt
function rm(...)
	local files = { ... }
	local removed = false
	for _, fileName in ipairs(files) do
		if type(fileName) == "string" and fileName ~= "" then
			local key = name_from(fileName)
			if sav.exists("vars", key) then
				sav.del("vars", key)
				removed = true
			end
			-- старый txt (если остался)
			local f = io.open(fileName, "r")
			if not f then
				local p = "assets/saves/" .. name_from(fileName) .. ".txt"
				f = io.open(p, "r")
			end
			if f then
				f:close()
				pcall(System.removeFile, fileName)
				pcall(System.removeFile, "assets/saves/" .. name_from(fileName) .. ".txt")
			end
		end
	end
	sav.save()
	if System and System.GC then System.GC() end
end
