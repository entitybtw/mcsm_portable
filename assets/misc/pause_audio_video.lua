-- глобальные переменные
subs = true
subssize = 0.4

local btn_static = Image.load("assets/buttons/static.png")
local btn_selected = Image.load("assets/buttons/selected.png")
local subtitleSavePath = "assets/saves/subtitles.txt"

local function loadSubtitles()
    local file = io.open(subtitleSavePath, "r")
    if file then
        local s = file:read("*l")
        local size = tonumber(file:read("*l"))
        subs = (s == "true")
        subssize = size or 0.4
        file:close()
    end
end

local function saveSubtitles()
    local file = io.open(subtitleSavePath, "w")
    if file then
        file:write(tostring(subs) .. "\n")
        file:write(tostring(subssize) .. "\n")
        file:close()
    end
end

loadSubtitles()

local subssizeOptions = {0.35, 0.4, 0.415}
local subssizeIndex = 2
for i, v in ipairs(subssizeOptions) do
    if v == subssize then
        subssizeIndex = i
        break
    end
end

local hints = {
    music = "Adjust the Menu Music volume",
    video = "Adjust the PMP Videos volume",
    ui = "Adjust the UI Sounds volume",
    subs = "Displays subtitles at the bottom of the screen",
    subssize = "Adjust the size of the subtitles"
}

local bg = Image.load("assets/mainmenu/pause_bg.png")
local circle = Image.load("assets/icons/circle.png")
local sliderBg = Image.load("assets/mainmenu/settings/slider_bg.png")
local sliderStatic   = Image.load("assets/mainmenu/settings/slider_static.png")
local sliderSelected = Image.load("assets/mainmenu/settings/slider_selected.png")

local function generatePositions(yPos)
    local positions = {}
    for i = 0, 10 do
        table.insert(positions, { x = 153 + i * 16.3, y = yPos + 10 })
    end
    return positions
end

local function loadLevels(path)
    local file = io.open(path, "r")
    if file then
        local savedLevels = {}
        for i = 1, 3 do
            local level = tonumber(file:read("*l"))
            table.insert(savedLevels, level)
        end
        file:close()
        return unpack(savedLevels)
    end
    return 5, 5, 5
end

local function saveLevels(path, levels)
    local file = io.open(path, "w")
    if file then
        for _, level in ipairs(levels) do
            file:write(level .. "\n")
        end
        file:close()
    end
end

local menumusic, pmpvideos, uiLevel = loadLevels("assets/saves/soundlevels.txt")

local sliders = {
    {
        name = "Menu Music Volume",
        level = menumusic,
        positions = generatePositions(45),
        spritesheet = musicSpritesheet,
        apply = function(level) sound.volumeEasy(sound.MP3, level * 10) end,
        hintText = hints.music
    },
    {
        name = "PMP Videos Volume",
        level = pmpvideos,
        positions = generatePositions(45 + 30),
        spritesheet = videoSpritesheet,
        apply = function(level) pmpvolume = level * 10 end,
        hintText = hints.video
    },
    {
        name = "UI Sounds Volume",
        level = uiLevel,
        positions = generatePositions(45 + 60),
        spritesheet = uiSpritesheet,
        apply = function(level) sound.volumeEasy(sound.WAV_1, level * 10) end,
        hintText = hints.ui
    }
}

for _, slider in ipairs(sliders) do
    slider.apply(slider.level)
end

local selectedIndex = 1
local totalItems = #sliders + 2

local function drawSlider(slider, isSelected, y)
    local x = 150
    Image.draw(sliderBg, x, y, 183, 26)

    local scale = 0.27
    local text = slider.name .. ": " .. tostring(slider.level)
    local tw = intraFont.textW(font, text, scale)
    local th = intraFont.textH(font) * scale

    local tx = x + (179 - tw) / 2
    local ty = y + (37 - th) / 3.5

    local color = isSelected and Color.new(251,238,90) or Color.new(255,255,255)

    intraFont.printShadowed(tx, ty, text, color, Color.new(0,0,0), font, 90, 1, scale, 0)

    local pos = slider.positions[slider.level + 1]
    local sliderImg = isSelected and sliderSelected or sliderStatic
    Image.draw(sliderImg, pos.x, y)
end

local function drawToggle(text, stateText, isSelected, y)
    local x = 150
    local slcted = isSelected and btn_selected or btn_static
    Image.draw(slcted, x, y)

    local scale = 0.3
    local fullText = text .. ": " .. stateText
    local tw = intraFont.textW(font, fullText, scale)
    local th = intraFont.textH(font) * scale

    local tx = x + (179 - tw) / 2
    local ty = y + (37 - th) / 3

    local color = isSelected and Color.new(251,238,90) or Color.new(255,255,255)

    intraFont.printShadowed(tx, ty, fullText, color, Color.new(0,0,0), font, 90, 1, scale, 0)
end

local function drawui()
    intraFont.printShadowed(230 - intraFont.textW(font, "Audio/Video Settings", 0.3) / 2 + 14, 25, "Audio/Video Settings", Color.new(255,255,255), Color.new(0, 0, 0), font, 90, 1, 0.3, 0)   

    for i, slider in ipairs(sliders) do
        drawSlider(slider, i == selectedIndex, 15 + i * 30)
    end

    drawToggle("Subtitles", subs and "On" or "Off", selectedIndex == #sliders + 1, 1 + (#sliders + 1) * 32)
    local sizeText = (subssizeIndex == 1 and "Small") or (subssizeIndex == 2 and "Medium") or "Large"
    drawToggle("Subtitle Size", sizeText, selectedIndex == #sliders + 2, 1 + (#sliders + 2) * 32)

    local hintText
    if selectedIndex <= #sliders then
        hintText = sliders[selectedIndex].hintText
    elseif selectedIndex == #sliders + 1 then
        hintText = hints.subs
    elseif selectedIndex == #sliders + 2 then
        hintText = hints.subssize
    end

    if hintText then
        intraFont.setStyle(font, 0.6, Color.new(255, 255, 255), 0, intraFont.ALIGN_CENTER)
        intraFont.printShadowed(238 - intraFont.textW(font, hintText, 0.3) / 2 + 8, 220 + 14, hintText, Color.new(255,255,255), Color.new(0, 0, 0), font, 90, 1, 0.3, 0)
    end
end

while true do
    buttons.read()
    screen.clear()
    Image.draw(bg, 0, 0)
    Image.draw(circle, 240 - intraFont.textW(font, "Previous Menu", 0.3) / 2 - 2, 233 + 13, 14, 14)
    intraFont.printShadowed(240 - intraFont.textW(font, "Previous Menu", 0.3) / 2 + 14, 233 + 14, "Previous Menu", Color.new(255,255,255), Color.new(0, 0, 0), font, 90, 1, 0.3, 0)   

    drawui()
    screen.flip()

    if buttons.pressed(buttons.down) and selectedIndex < totalItems then
        selectedIndex = selectedIndex + 1
        sound.playEasy("assets/sounds/select.wav", sound.WAV_1, false, false)
    elseif buttons.pressed(buttons.up) and selectedIndex > 1 then
        selectedIndex = selectedIndex - 1
        sound.playEasy("assets/sounds/select.wav", sound.WAV_1, false, false)
    end

    if selectedIndex <= #sliders then
        local slider = sliders[selectedIndex]
        if buttons.pressed(buttons.left) and slider.level > 0 then
            slider.level = slider.level - 1
            slider.apply(slider.level)
        elseif buttons.pressed(buttons.right) and slider.level < 10 then
            slider.level = slider.level + 1
            slider.apply(slider.level)
        end
    elseif selectedIndex == #sliders + 1 then
        if buttons.pressed(buttons.cross) then
            subs = not subs
            saveSubtitles()
        end
    elseif selectedIndex == #sliders + 2 then
        if buttons.pressed(buttons.cross) then
            subssizeIndex = subssizeIndex % #subssizeOptions + 1
            subssize = subssizeOptions[subssizeIndex]
            saveSubtitles()
        end
    end

    if buttons.pressed(buttons.circle) then
        local levelsToSave = {}
        for _, slider in ipairs(sliders) do
            table.insert(levelsToSave, slider.level)
        end
        saveLevels("assets/saves/soundlevels.txt", levelsToSave)
        saveSubtitles()

        Image.unload(circle)

        Image.unload(bg)
        Image.unload(btn_static)
        Image.unload(btn_selected)
        Image.unload(sliderBg)
        Image.unload(sliderStatic)
        Image.unload(sliderSelected)
        break
    end
end
