local circle = Image.load("assets/icons/circle.png")
local bg = Image.load("assets/mainmenu/pause_bg.png")

local buttonsList = {
    {
        id = "FREERAM", isToggle = true, state = false,
        normalImageOn = Image.load("assets/buttons/FREERAMON_ENG_STATIC.png"),
        normalImageOff = Image.load("assets/buttons/FREERAMOFF_ENG_STATIC.png"),
        selectedImageOn = Image.load("assets/buttons/FREERAMON_ENG_SELECTED.png"),
        selectedImageOff = Image.load("assets/buttons/FREERAMOFF_ENG_SELECTED.png")
    },
    {
        id = "BATTERY", isToggle = true, state = false,
        normalImageOn = Image.load("assets/buttons/BATTERYON_ENG_STATIC.png"),
        normalImageOff = Image.load("assets/buttons/BATTERYOFF_ENG_STATIC.png"),
        selectedImageOn = Image.load("assets/buttons/BATTERYON_ENG_SELECTED.png"),
        selectedImageOff = Image.load("assets/buttons/BATTERYOFF_ENG_SELECTED.png")
    },
    {
        id = "CPUFREQ", isToggle = true, state = false,
        normalImageOn = Image.load("assets/buttons/CPUFREQON_ENG_STATIC.png"),
        normalImageOff = Image.load("assets/buttons/CPUFREQOFF_ENG_STATIC.png"),
        selectedImageOn = Image.load("assets/buttons/CPUFREQON_ENG_SELECTED.png"),
        selectedImageOff = Image.load("assets/buttons/CPUFREQOFF_ENG_SELECTED.png")
    },
    {
        id = "NICKNAME", isToggle = true, state = false,
        normalImageOn = Image.load("assets/buttons/NICKNAMEON_ENG_STATIC.png"),
        normalImageOff = Image.load("assets/buttons/NICKNAMEOFF_ENG_STATIC.png"),
        selectedImageOn = Image.load("assets/buttons/NICKNAMEON_ENG_SELECTED.png"),
        selectedImageOff = Image.load("assets/buttons/NICKNAMEOFF_ENG_SELECTED.png")
    },
    {
        id = "TIMEDATE", isToggle = true, state = false,
        normalImageOn = Image.load("assets/buttons/TIMEDATEON_ENG_STATIC.png"),
        normalImageOff = Image.load("assets/buttons/TIMEDATEOFF_ENG_STATIC.png"),
        selectedImageOn = Image.load("assets/buttons/TIMEDATEON_ENG_SELECTED.png"),
        selectedImageOff = Image.load("assets/buttons/TIMEDATEOFF_ENG_SELECTED.png")
    }
}

local selectedButton = 1

local function drawButtons()
    for i, button in ipairs(buttonsList) do
        local x = 150
        local y = 40 + (i - 1) * 30

        if button.isToggle then
            if button.state then
                if i == selectedButton then
                    Image.draw(button.selectedImageOn, x, y)
                else
                    Image.draw(button.normalImageOn, x, y)
                end
            else
                if i == selectedButton then
                    Image.draw(button.selectedImageOff, x, y)
                else
                    Image.draw(button.normalImageOff, x, y)
                end
            end
        else
            if i == selectedButton then
                Image.draw(button.selectedImage, x, y)
            else
                Image.draw(button.normalImage, x, y)
            end
        end
    end
end

local function unloadButtons()
    for _, btn in pairs(buttonsList) do
        if btn.isToggle then
            Image.unload(btn.normalImageOn)
            Image.unload(btn.normalImageOff)
            Image.unload(btn.selectedImageOn)
            Image.unload(btn.selectedImageOff)
        else
            Image.unload(btn.normalImage)
            Image.unload(btn.selectedImage)
        end
    end
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
