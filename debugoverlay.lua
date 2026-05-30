debugoverlay = {}

local _cachedFlags = nil

local _debugButtons = {
	{ id = "FREERAM",  text = "Free RAM",  state = false },
	{ id = "BATTERY",  text = "Battery",   state = false },
	{ id = "CPUFREQ",  text = "CPU Freq",  state = false },
	{ id = "NICKNAME", text = "Nickname",  state = false },
	{ id = "TIMEDATE", text = "Time/Date", state = false },
}

function debugoverlay.getButtons()
	return _debugButtons
end

function debugoverlay.saveDebugInfo()
	local file = io.open("assets/saves/debuginfo.txt", "w")
	if not file then return end
	for _, btn in ipairs(_debugButtons) do
		file:write(string.format("%s:%d\n", btn.id, btn.state and 1 or 0))
	end
	file:close()
end

function debugoverlay.loadSettings()
	local flags = { FREERAM = false, BATTERY = false, CPUFREQ = false, NICKNAME = false, TIMEDATE = false }
	local file = io.open("assets/saves/debuginfo.txt", "r")
	if file then
		for line in file:lines() do
			local id, val = line:match("^(%w+):(%d)")
			if id then
				if flags[id] ~= nil then
					flags[id] = (val == "1")
				end
				for _, btn in ipairs(_debugButtons) do
					if btn.id == id then
						btn.state = (val == "1")
						break
					end
				end
			end
		end
		file:close()
	end
	_cachedFlags = flags
	return flags
end

function debugoverlay.draw(flags)
	local f = flags or _cachedFlags
	if not f then return end
	local y = 0
	if f.FREERAM then
		LUA.print(0, y, string.format("Free RAM: %.2f MB", LUA.getRAM() / (1024 * 1024)))
		y = y + 13
	end
	if f.BATTERY then
		LUA.print(0, y, "Battery: " .. System.getBatteryPercent() .. "%")
		y = y + 13
	end
	if f.CPUFREQ then
		LUA.print(0, y, "CPU: " .. System.getCPU() .. " MHz")
		y = y + 13
	end
	if f.NICKNAME then
		LUA.print(0, y, "Nickname: " .. System.getNickname())
		y = y + 13
	end
	if f.TIMEDATE then
		local t = System.getTime()
		LUA.print(
			0,
			y,
			string.format("Time: %02d:%02d:%02d %02d/%02d/%04d", t.hour, t.minutes, t.seconds, t.day, t.month, t.year)
		)
	end
end
