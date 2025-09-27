local circle = Image.load("assets/icons/circle.png")
local bg = Image.load("assets/mainmenu/pause_bg.png")

local btn_static = Image.load("assets/buttons/static.png")
local btn_selected = Image.load("assets/buttons/selected.png")

local buttonsList = {
    { id = "FREERAM", text = "Free RAM", isToggle = true, state = false },
    { id = "BATTERY", text = "Battery", isToggle = true, state = false },
    { id = "CPUFREQ", text = "CPU Freq", isToggle = true, state = false },
    { id = "NICKNAME", text = "Nickname", isToggle = true, state = false },
    { id = "TIMEDATE", text = "Time/Date", isToggle = true, state = false }
}

local selectedButton = 1

local function drawButtons()
    local startX = 150
    local startY = 40
    local scale = 0.3

    for i, button in ipairs(buttonsList) do
        local x = startX
        local y = startY + (i - 1) * (Image.H(btn_static) / 1.15)

        local bg = (i == selectedButton) and btn_selected or btn_static
        Image.draw(bg, x, y)

        local label = button.text .. ": " .. (button.state and "ON" or "OFF")
        local tw = intraFont.textW(font, label, scale)
        local th = intraFont.textH(font) * scale
        local tx = x + (Image.W(bg) - tw) / 2
        local ty = y + (Image.H(bg) - th)  / 2.7

        local color = (i == selectedButton)
            and Color.new(251, 238, 90)
            or Color.new(255, 255, 255)

        intraFont.printShadowed(
            tx, ty,
            label,
            color,
            Color.new(0, 0, 0),
            font,
            90, 1, scale, 0
        )
    end
end

local function unloadButtons()
    Image.unload(btn_static)
    Image.unload(btn_selected)
end

local function drawSystemInfo()
    local y = 0
    for _, btn in ipairs(buttonsList) do
        if btn.isToggle and btn.state then
            local text = ""
            if btn.id == "FREERAM" then
                text = string.format("Free RAM: %.2f MB", LUA.getRAM() / (1024 * 1024))
            elseif btn.id == "BATTERY" then
                text = "Battery: " .. System.getBatteryPercent() .. "%"
            elseif btn.id == "CPUFREQ" then
                text = "CPU: " .. System.getCPU() .. " MHz"
            elseif btn.id == "NICKNAME" then
                text = "Nickname: " .. System.getNickname()
            elseif btn.id == "TIMEDATE" then
                local t = System.getTime()
                text = string.format("Time: %02d:%02d:%02d %02d/%02d/%04d", t.hour, t.minutes, t.seconds, t.day, t.month, t.year)
            end
            LUA.print(0, y, text)
            y = y + 13
        end
    end
end

local function saveSystemInfo()
    local file = io.open("assets/saves/debuginfo.txt", "w")
    if not file then return end

    for _, btn in ipairs(buttonsList) do
        if btn.isToggle then
            local value = btn.state and 1 or 0
            file:write(string.format("%s:%d\n", btn.id, value))
        end
    end

    file:close()
end

local function loadSystemInfo()
    local file = io.open("assets/saves/debuginfo.txt", "r")
    if not file then return end

    for line in file:lines() do
        local id, val = line:match("^(%w+):(%d)")
        if id and val then
            for _, btn in ipairs(buttonsList) do
                if btn.id == id and btn.isToggle then
                    btn.state = (val == "1")
                    break
                end
            end
        end
    end

    file:close()
end

loadSystemInfo()

while true do
    screen.clear()
    buttons.read()
    Image.draw(bg, 0, 0)
    intraFont.printShadowed(205, 25, "Debug Menu", Color.new(255, 255, 255), Color.new(0, 0, 0), font, 90, 1, 0.3, 0)
    if buttons.pressed(buttons.up) and selectedButton > 1 then
        selectedButton = selectedButton - 1
        sound.playEasy("assets/sounds/select.wav", sound.WAV_1, false, false)
    end
    if buttons.pressed(buttons.down) and selectedButton < #buttonsList then
        selectedButton = selectedButton + 1
        sound.playEasy("assets/sounds/select.wav", sound.WAV_1, false, false)
    end

    if buttons.pressed(buttons.cross) then
        local current = buttonsList[selectedButton]
        if current.isToggle then
            current.state = not current.state
            sound.playEasy("assets/sounds/click.wav", sound.WAV_1, false, false)
        end
    end
    
    if buttons.pressed(buttons.circle) then
        unloadButtons()
        saveSystemInfo()
        Image.unload(bg)
        Image.unload(circle)
        sound.playEasy("assets/sounds/skeleton_1.wav", sound.WAV_1, false, false)
        sound.volumeEasy(sound.WAV_1, uiLevel * 10)
        break
    end

    drawButtons()
    drawSystemInfo()
    Image.draw(circle, 240 - intraFont.textW(font, "Previous Menu", 0.3) / 2 - 2, 233 + 13, 14, 14)
    intraFont.printShadowed(240 - intraFont.textW(font, "Previous Menu", 0.3) / 2 + 14, 233 + 14, "Previous Menu", Color.new(255,255,255), Color.new(0, 0, 0), font, 90, 1, 0.3, 0)   
    screen.flip()
end
