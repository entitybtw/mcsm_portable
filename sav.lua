-- sav.lua — единое JSON-хранилище для всех настроек/сохранений.
--
-- Один файл: assets/saves/data.json
-- API:
--   sav.encode(t) -> string
--   sav.decode(s) -> table | nil
--   sav.load()    -> перечитать с диска
--   sav.save()    -> записать на диск
--   sav.get(section, key, default) / sav.set / sav.del / sav.exists
--   sav.section(section) / sav.clear()

sav = {}
sav.data = {}

-- ================= JSON ENCODE =================
local function json_encode(v)
	local t = type(v)
	if t == "nil" then return "null"
	elseif t == "boolean" then return v and "true" or "false"
	elseif t == "number" then
		if v ~= v or v == math.huge or v == -math.huge then return "null" end
		return ("%.17g"):format(v)
	elseif t == "string" then
		return '"' .. v:gsub('[%z\1-\31\\"]', function(c)
			if c == '\\' then return '\\\\'
			elseif c == '"' then return '\\"'
			elseif c == '\n' then return '\\n'
			elseif c == '\t' then return '\\t'
			elseif c == '\r' then return '\\r'
			else return string.format('\\u%04x', c:byte())
			end
		end) .. '"'
	elseif t == "table" then
		local isarr = true
		local n = 0
		for k in pairs(v) do
			n = n + 1
			if type(k) ~= "number" or k < 1 or k ~= math.floor(k) then isarr = false end
		end
		if isarr and n > 0 then
			for i = 1, n do if v[i] == nil then isarr = false break end end
		end
		local parts = {}
		if isarr then
			for i = 1, n do parts[#parts+1] = json_encode(v[i]) end
			return "[" .. table.concat(parts, ",") .. "]"
		else
			local keys = {}
			for k in pairs(v) do keys[#keys+1] = tostring(k) end
			table.sort(keys)
			for _, k in ipairs(keys) do
				parts[#parts+1] = json_encode(k) .. ":" .. json_encode(v[k])
			end
			return "{" .. table.concat(parts, ",") .. "}"
		end
	end
	return "null"
end
sav.encode = json_encode

-- ================= JSON DECODE (recursive descent) =================
local sidx, s
local function skipws()
	while sidx <= #s and s:sub(sidx, sidx):find("%s") do sidx = sidx + 1 end
end
local function u8(cp)
	if cp < 0x80 then return string.char(cp)
	elseif cp < 0x800 then return string.char(0xC0+math.floor(cp/64), 0x80+cp%64)
	elseif cp < 0x10000 then return string.char(0xE0+math.floor(cp/4096), 0x80+math.floor(cp/64)%64, 0x80+cp%64)
	else return string.char(0xF0+math.floor(cp/262144), 0x80+math.floor(cp/4096)%64, 0x80+math.floor(cp/64)%64, 0x80+cp%64) end
end
local function parse_value()
	skipws()
	if sidx > #s then return nil end
	local b = s:sub(sidx, sidx)
	if b == "{" then
		sidx = sidx + 1
		local obj = {}
		skipws()
		if s:sub(sidx, sidx) == "}" then sidx = sidx + 1 return obj end
		while true do
			skipws()
			local k = parse_value()        -- ключ (строка)
			if type(k) ~= "string" then return nil end
			skipws()
			if s:sub(sidx, sidx) ~= ":" then return nil end
			sidx = sidx + 1
			obj[k] = parse_value()
			skipws()
			local c = s:sub(sidx, sidx)
			if c == "," then sidx = sidx + 1
			elseif c == "}" then sidx = sidx + 1 return obj
			else return nil end
		end
	elseif b == "[" then
		sidx = sidx + 1
		local arr = {}
		local i = 1
		skipws()
		if s:sub(sidx, sidx) == "]" then sidx = sidx + 1 return arr end
		while true do
			arr[i] = parse_value()
			i = i + 1
			skipws()
			local c = s:sub(sidx, sidx)
			if c == "," then sidx = sidx + 1
			elseif c == "]" then sidx = sidx + 1 return arr
			else return nil end
		end
	elseif b == '"' then
		sidx = sidx + 1
		local buf = {}
		while sidx <= #s do
			local c = s:sub(sidx, sidx)
			sidx = sidx + 1
			if c == '"' then return table.concat(buf)
			elseif c == '\\' then
				local e = s:sub(sidx, sidx)
				sidx = sidx + 1
				if e == 'n' then buf[#buf+1] = "\n"
				elseif e == 't' then buf[#buf+1] = "\t"
				elseif e == 'r' then buf[#buf+1] = "\r"
				elseif e == 'b' then buf[#buf+1] = "\b"
				elseif e == 'f' then buf[#buf+1] = "\f"
				elseif e == 'u' then
					local hex = s:sub(sidx, sidx+3)
					sidx = sidx + 4
					buf[#buf+1] = u8(tonumber(hex, 16) or 0)
				else buf[#buf+1] = e end
			else buf[#buf+1] = c end
		end
		return nil
	elseif b == "t" and s:sub(sidx, sidx+3) == "true" then sidx = sidx+4 return true
	elseif b == "f" and s:sub(sidx, sidx+4) == "false" then sidx = sidx+5 return false
	elseif b == "n" and s:sub(sidx, sidx+3) == "null" then sidx = sidx+4 return nil
	else
		local num = s:match("^-?%d+%.?%d*[eE]?[%+%-]?%d*", sidx)
		if num and num ~= "" then sidx = sidx + #num return tonumber(num) end
		return nil
	end
end
sav.decode = function(str)
	if type(str) ~= "string" then return nil end
	s = str
	sidx = 1
	local v = parse_value()
	return v
end

-- ================= FILE STORE =================
function sav.load()
	local f = io.open("assets/saves/data.json", "r")
	if f then
		local txt = f:read("*a")
		f:close()
		local ok, val = pcall(function() return sav.decode(txt) end)
		if ok and type(val) == "table" then sav.data = val else sav.data = {} end
	else
		sav.data = {}
	end
end
function sav.save()
	local f = io.open("assets/saves/data.json", "w")
	if f then
		f:write(sav.encode(sav.data))
		f:close()
		if System and System.GC then System.GC() end
	end
end
function sav.get(section, key, default)
	local sec = sav.data[section]
	if sec == nil then return default end
	local v = sec[key]
	if v == nil then return default end
	return v
end
function sav.set(section, key, value)
	if sav.data[section] == nil then sav.data[section] = {} end
	sav.data[section][key] = value
	sav.save()
end
function sav.del(section, key)
	if key == nil then
		sav.data[section] = nil
	elseif sav.data[section] ~= nil then
		sav.data[section][key] = nil
		if next(sav.data[section]) == nil then sav.data[section] = nil end
	end
	sav.save()
end
function sav.exists(section, key)
	local sec = sav.data[section]
	if sec == nil then return false end
	if key == nil then return true end
	return sec[key] ~= nil
end
function sav.section(section) return sav.data[section] end
function sav.clear() sav.data = {} sav.save() end

sav.load()
return sav
