debugoverlay = {}

function debugoverlay.loadSettings()
    local flags = { FREERAM = false, BATTERY = false, CPUFREQ = false, NICKNAME = false, TIMEDATE = false }
    local file = io.open("assets/saves/debuginfo.txt", "r")
    if file then
        for line in file:lines() do
            local id, val = line:match("^(%w+):(%d)")
            if id and flags[id] ~= nil then
                flags[id] = (val == "1")
            end
        end
        file:close()
    end
    return flags
end

function debugoverlay.draw(flags)
    local y = 0
    if flags.FREERAM then
        LUA.print(0, y, string.format("Free RAM: %.2f MB", LUA.getRAM() / (1024 * 1024)))
        y = y + 13
    end
    if flags.BATTERY then
        LUA.print(0, y, "Battery: " .. System.getBatteryPercent() .. "%")
        y = y + 13
    end
    if flags.CPUFREQ then
        LUA.print(0, y, "CPU: " .. System.getCPU() .. " MHz")
        y = y + 13
    end
    if flags.NICKNAME then
        LUA.print(0, y, "Nickname: " .. System.getNickname())
        y = y + 13
    end
    if flags.TIMEDATE then
        local t = System.getTime()
        LUA.print(0, y, string.format("Time: %02d:%02d:%02d %02d/%02d/%04d", t.hour, t.minutes, t.seconds, t.day, t.month, t.year))
        y = y + 13
    end
end
