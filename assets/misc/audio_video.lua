-- load images
local bg = Image.load("assets/mainmenu/bg.png")
local audiovideotext = Image.load("assets/mainmenu/settings/audiovideo_text.png")
local hints = {
    music = Image.load("assets/mainmenu/settings/menumusic_text.png"),
    video = Image.load("assets/mainmenu/settings/pmpvideos_text.png"),
    ui = Image.load("assets/mainmenu/settings/uisounds_text.png")
}
local function preloadImages(prefix, suffix, count)
    local list = {}
    for i = 0, count do
        list[i + 1] = Image.load("assets/mainmenu/settings/" .. string.format("%s%d%s", prefix, i, suffix))
    end
    return list
end
local staticImages       = preloadImages("menumusic_", "_static.png", 10)
local selectedImages     = preloadImages("menumusic_", "_selected.png", 10)
local videoStaticImages  = preloadImages("pmpvideos_", "_static.png", 10)
local videoSelectedImages= preloadImages("pmpvideos_", "_selected.png", 10)
local uiStaticImages     = preloadImages("uisounds_", "_static.png", 10)
local uiSelectedImages   = preloadImages("uisounds_", "_selected.png", 10)

local sliderStatic   = Image.load("assets/mainmenu/settings/slider_static.png")
local sliderSelected = Image.load("assets/mainmenu/settings/slider_selected.png")

-- generate slider positions
local function generatePositions(yPos)
    local positions = {}
    for i = 0, 10 do
        table.insert(positions, { x = 35 + i * 16.3, y = yPos })
    end
    return positions
end

-- load levels function
local function loadLevels(path)
    local file = io.open(path, "r")
    if file then
        local savedLevels = {}
        for i = 1, 3 do
            local level = tonumber(file:read("*l"))
            table.insert(savedLevels, level)
        end
        file:close()
        if savedLevels[1] and savedLevels[2] and savedLevels[3] then
            return savedLevels[1], savedLevels[2], savedLevels[3]
        end
    end
    return 5, 5, 5 -- default levels
end


-- save levels function
local function saveLevels(path, levels)
    local file = io.open(path, "w")
    if file then
        for _, level in ipairs(levels) do
            file:write(level .. "\n")
        end
        file:close()
    end
end

-- load levels
local menumusic, pmpvideos, uiLevel = loadLevels("assets/saves/soundlevels.txt")

-- slider data structure
local sliders = {
    {
        name = "Music",
        level = menumusic,
        positions = generatePositions(55),
        staticImages = staticImages,
        selectedImages = selectedImages,
        apply = function(level) sound.volume(sound.MP3, level * 10) end,
        hint = hints.music
    },
    {
        name = "Video",
        level = pmpvideos,
        positions = generatePositions(85),
        staticImages = videoStaticImages,
        selectedImages = videoSelectedImages,
        apply = function(level) pmpvolume = level * 10 end,
        hint = hints.video
    },
    {
        name = "UI",
        level = uiLevel,
        positions = generatePositions(115),
        staticImages = uiStaticImages,
        selectedImages = uiSelectedImages,
        apply = function(level) sound.volume(sound.WAV_1, level * 10) end,
        hint = hints.ui
    }
}

-- apply volume
for _, slider in ipairs(sliders) do
    slider.apply(slider.level)
end

local prevMenu = {
    static = Image.load("assets/buttons/PREVIOUSMENU_ENG_STATIC.png"),
    selected = Image.load("assets/buttons/PREVIOUSMENU_ENG_SELECTED.png"),
    x = 0,
    y = 220
}

local selectedIndex = 1
local inPrev = false

local function drawSlider(slider, isSelected)
    local level = slider.level
    local img = isSelected and slider.selectedImages[level + 1] or slider.staticImages[level + 1]
    if img then Image.draw(img, 35, slider.positions[1].y) end
    local pos = slider.positions[level + 1]
    local sliderImg = isSelected and sliderSelected or sliderStatic
    if sliderImg then
        Image.draw(sliderImg, pos.x, pos.y, nil, nil, nil, nil, nil, nil, nil, nil, 190)
    end
end

local function drawui()
    screen.clear()
    if bg then Image.draw(bg, 0, 0) end
    if audiovideotext then Image.draw(audiovideotext, 35, 38, 120, 13) end

    for i, slider in ipairs(sliders) do
        drawSlider(slider, (i == selectedIndex) and not inPrev)
    end

    local hintImg = nil
    if not inPrev then
        hintImg = sliders[selectedIndex].hint
    end
    if hintImg then
        Image.draw(hintImg, 35, prevMenu.y - 10)
    end

    local prevImg = inPrev and prevMenu.selected or prevMenu.static
    if prevImg then Image.draw(prevImg, prevMenu.x, prevMenu.y) end

    debugoverlay.draw(debugoverlay.loadSettings())
    screen.flip()
end

drawui()

while true do
    buttons.read()

    -- navigation logic
    if buttons.pressed(buttons.down) then
        if not inPrev then
            if selectedIndex < #sliders then
                selectedIndex = selectedIndex + 1
            else
                inPrev = true
            end
        end
        sound.play("assets/sounds/select.wav", sound.WAV_1, false, false)
        drawui()
    elseif buttons.pressed(buttons.up) then
        if inPrev then
            inPrev = false
        elseif selectedIndex > 1 then
            selectedIndex = selectedIndex - 1
        end
        sound.play("assets/sounds/select.wav", sound.WAV_1, false, false)
        drawui()
    end

    -- slider logic
    if not inPrev then
        local slider = sliders[selectedIndex]
        local changed = false
        if buttons.pressed(buttons.left) and slider.level > 0 then
            slider.level = slider.level - 1
            changed = true
        elseif buttons.pressed(buttons.right) and slider.level < 10 then
            slider.level = slider.level + 1
            changed = true
        end
        if changed then
            slider.apply(slider.level)
            drawui()
        end
    end

    -- confirm and exit
    if inPrev and buttons.pressed(buttons.cross) then
        local levelsToSave = {}
        for _, slider in ipairs(sliders) do
            table.insert(levelsToSave, slider.level)
        end
        saveLevels("assets/saves/soundlevels.txt", levelsToSave)

        -- unload images function
        local function unloadList(list)
            for i = 1, #list do
                if list[i] then Image.unload(list[i]) end
            end
        end

        -- unload images
        unloadList(staticImages)
        unloadList(selectedImages)
        unloadList(videoStaticImages)
        unloadList(videoSelectedImages)
        unloadList(uiStaticImages)
        unloadList(uiSelectedImages)

        if bg then Image.unload(bg) end
        if sliderStatic then Image.unload(sliderStatic) end
        if sliderSelected then Image.unload(sliderSelected) end
        if prevMenu.static then Image.unload(prevMenu.static) end
        if prevMenu.selected then Image.unload(prevMenu.selected) end
        if audiovideotext then Image.unload(audiovideotext) end

        for _, img in pairs(hints) do
            if img then Image.unload(img) end
        end

        sound.play("assets/sounds/skeleton_1.wav", sound.WAV_1, false, false)
        sound.volume(sound.WAV_1, sliders[3].level * 10)
        break
    end
end
