-- Глобальные переменные
subs = true
subssize = 0.4

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

local circle = Image.load("assets/icons/circle.png")
local musicSpritesheet = Image.load("assets/mainmenu/settings/menumusic_spritesheet.png")
local videoSpritesheet = Image.load("assets/mainmenu/settings/pmpvideos_spritesheet.png")
local uiSpritesheet = Image.load("assets/mainmenu/settings/uisounds_spritesheet.png")

local sliderStatic   = Image.load("assets/mainmenu/settings/slider_static.png")
local sliderSelected = Image.load("assets/mainmenu/settings/slider_selected.png")

local subsOnStatic = Image.load("assets/buttons/DISPSUBSON_ENG_STATIC.png")
local subsOnSelected = Image.load("assets/buttons/DISPSUBSON_ENG_SELECTED.png")
local subsOffStatic = Image.load("assets/buttons/DISPSUBSOFF_ENG_STATIC.png")
local subsOffSelected = Image.load("assets/buttons/DISPSUBSOFF_ENG_SELECTED.png")

local subSmallStatic = Image.load("assets/buttons/SUBSSMALL_ENG_STATIC.png")
local subSmallSelected = Image.load("assets/buttons/SUBSSMALL_ENG_SELECTED.png")
local subMediumStatic = Image.load("assets/buttons/SUBSMEDIUM_ENG_STATIC.png")
local subMediumSelected = Image.load("assets/buttons/SUBSMEDIUM_ENG_SELECTED.png")
local subLargeStatic = Image.load("assets/buttons/SUBSLARGE_ENG_STATIC.png")
local subLargeSelected = Image.load("assets/buttons/SUBSLARGE_ENG_SELECTED.png")

local function generatePositions(yPos)
    local positions = {}
    for i = 0, 10 do
        table.insert(positions, { x = 35 + i * 16.3, y = yPos })
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
        name = "Music",
        level = menumusic,
        positions = generatePositions(55),
        spritesheet = musicSpritesheet,
        apply = function(level) sound.volumeEasy(sound.MP3, level * 10) end,
        hintText = hints.music
    },
    {
        name = "Video",
        level = pmpvideos,
        positions = generatePositions(85),
        spritesheet = videoSpritesheet,
        apply = function(level) pmpvolume = level * 10 end,
        hintText = hints.video
    },
    {
        name = "UI",
        level = uiLevel,
        positions = generatePositions(115),
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

local function drawSpriteFromSheet(sheet, level, isSelected, x, y)
    local spriteWidth = 180
    local spriteHeight = 26
    local srcx = isSelected and 0 or 180
    local invertedLevel = 10 - level
    local srcy = invertedLevel * spriteHeight
    Image.draw(sheet, x, y, spriteWidth, spriteHeight, nil, srcx, srcy, spriteWidth, spriteHeight)
end

local function drawSlider(slider, isSelected)
    local level = slider.level
    drawSpriteFromSheet(slider.spritesheet, level, isSelected, 35, slider.positions[1].y)
    local pos = slider.positions[level + 1]
    local sliderImg = isSelected and sliderSelected or sliderStatic
    Image.draw(sliderImg, pos.x, pos.y, nil, nil, nil, nil, nil, nil, nil, nil, 190)
end

local function drawSubsToggle(isSelected)
    local x = 36
    local y = 140
    if subs then
        Image.draw(isSelected and subsOnSelected or subsOnStatic, x, y, 179, 37)
    else
        Image.draw(isSelected and subsOffSelected or subsOffStatic, x, y, 179, 37)
    end
end

local function drawSubsSize(isSelected)
    local x = 36
    local y = 170
    if subssizeIndex == 1 then
        Image.draw(isSelected and subSmallSelected or subSmallStatic, x, y, 179, 37)
    elseif subssizeIndex == 2 then
        Image.draw(isSelected and subMediumSelected or subMediumStatic, x, y, 179, 37)
    else
        Image.draw(isSelected and subLargeSelected or subLargeStatic, x, y, 179, 37)
    end
end

local function drawui()
    intraFont.printShadowed(40, 40, "Audio/Video Settings", Color.new(255, 255, 255), Color.new(0, 0, 0), font, 90, 1, 0.3, 0)

    for i, slider in ipairs(sliders) do
        drawSlider(slider, i == selectedIndex)
    end

    drawSubsToggle(selectedIndex == #sliders + 1)
    drawSubsSize(selectedIndex == #sliders + 2)

    local hintText
    if selectedIndex <= #sliders then
        hintText = sliders[selectedIndex].hintText
    elseif selectedIndex == #sliders + 1 then
        hintText = hints.subs
    elseif selectedIndex == #sliders + 2 then
        hintText = hints.subssize
    end

    if hintText then
        intraFont.setStyle(font, 0.6, Color.new(255, 255, 255), 0, intraFont.ALIGN_LEFT)
        intraFont.printShadowed(43, 210, hintText, Color.new(255,255,255), Color.new(0, 0, 0), font, 90, 1, 0.3, 0)
    end

    debugoverlay.draw(debugoverlay.loadSettings())
end

drawui()

while true do
    buttons.read()
    screen.clear()
    if PMP.getFrame(videoFrame) then
        Image.draw(videoFrame, 0, 0)
    end
    Image.draw(circle, 40, 233, 14, 14)
    intraFont.printShadowed(57, 234, "Previous Menu", Color.new(255, 255, 255), Color.new(0, 0, 0), font, 90, 1, 0.3, 0)
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
        Image.unload(musicSpritesheet)
        Image.unload(videoSpritesheet)
        Image.unload(uiSpritesheet)
        
        Image.unload(sliderStatic)
        Image.unload(sliderSelected)
        
        Image.unload(subsOnStatic)
        Image.unload(subsOnSelected)
        Image.unload(subsOffStatic)
        Image.unload(subsOffSelected)
        
        Image.unload(subSmallStatic)
        Image.unload(subSmallSelected)
        Image.unload(subMediumStatic)
        Image.unload(subMediumSelected)
        Image.unload(subLargeStatic)
        Image.unload(subLargeSelected)
           
        break
    end
end
