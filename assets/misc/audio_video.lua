local bg = Image.load("assets/mainmenu/bg.png")
local audiovideotext = Image.load("assets/mainmenu/options/audiovideo_text.png")
local hints = {
    music = Image.load("assets/mainmenu/options/menumusic_text.png"),
    video = Image.load("assets/mainmenu/options/pmpvideos_text.png"),
    ui = Image.load("assets/mainmenu/options/uisounds_text.png")
}
-- Preloads image list into memory
local function preloadImages(prefix, suffix, count)
    local list = {}
    for i = 0, count do
        list[i + 1] = Image.load("assets/mainmenu/options/" .. string.format("%s%d%s", prefix, i, suffix))
    end
    return list
end

-- Load all necessary image sets
local staticImages       = preloadImages("menumusic_", "_static.png", 10)
local selectedImages     = preloadImages("menumusic_", "_selected.png", 10)
local videoStaticImages  = preloadImages("pmpvideos_", "_static.png", 10)
local videoSelectedImages= preloadImages("pmpvideos_", "_selected.png", 10)
local uiStaticImages     = preloadImages("uisounds_", "_static.png", 10)
local uiSelectedImages   = preloadImages("uisounds_", "_selected.png", 10)

local sliderStatic   = Image.load("assets/mainmenu/options/slider_static.png")
local sliderSelected = Image.load("assets/mainmenu/options/slider_selected.png")

-- Generate slider positions
local sliderPositions, videoSliderPositions, uiSliderPositions = {}, {}, {}
for i = 0, 10 do
    table.insert(sliderPositions, { x = 35 + i * 16.3, y = 55 })
    table.insert(videoSliderPositions, { x = 35 + i * 16.3, y = 85 })
    table.insert(uiSliderPositions, { x = 35 + i * 16.3, y = 115 })
end

-- Initialize volume levels
local currentLevel, videoLevel, uiLevel = 5, 5, 5

local function loadLevel(path)
    local file = io.open(path, "r")
    if file then
        local saved = tonumber(file:read("*l"))
        file:close()
        if saved and saved >= 0 and saved <= 10 then return saved end
    end
    return 5
end

currentLevel = loadLevel("assets/saves/sound_levels/menumusic.txt")
videoLevel   = loadLevel("assets/saves/sound_levels/pmpvideos.txt")
uiLevel      = loadLevel("assets/saves/sound_levels/uisounds.txt")

-- Set initial volume
sound.volume(sound.MP3, currentLevel * 10)
sound.volume(sound.WAV_1, uiLevel * 10)

-- Load previous menu button graphics
local prevMenu = {
    static = Image.load("assets/buttons/PREVIOUSMENU_ENG_STATIC.png"),
    selected = Image.load("assets/buttons/PREVIOUSMENU_ENG_SELECTED.png"),
    x = 0,
    y = 220
}

-- UI state flags
local isSliderSelected, isVideoSliderSelected, isUiSliderSelected, isPrevSelected = true, false, false, false

-- Draw UI
local function drawui()
    screen.clear()
    if bg then Image.draw(bg, 0, 0) end
    if audiovideotext then Image.draw(audiovideotext, 35, 38, 120, 13) end

    local function drawSlider(imgList, selectedList, level, selectedFlag, posList, yPos)
        local img = selectedFlag and selectedList[level + 1] or imgList[level + 1]
        if img then Image.draw(img, 35, yPos) end
        local pos = posList[level + 1]
        local slider = selectedFlag and sliderSelected or sliderStatic
        if slider then
            Image.draw(slider, pos.x, pos.y, nil, nil, nil, nil, nil, nil, nil, nil, 190)
        end
    end

    drawSlider(staticImages, selectedImages, currentLevel, isSliderSelected, sliderPositions, 55)
    drawSlider(videoStaticImages, videoSelectedImages, videoLevel, isVideoSliderSelected, videoSliderPositions, 85)
    drawSlider(uiStaticImages, uiSelectedImages, uiLevel, isUiSliderSelected, uiSliderPositions, 115)

if not inPrev then
    local hintImg = nil
    if isSliderSelected then
        hintImg = hints.music
    elseif isVideoSliderSelected then
        hintImg = hints.video
    elseif isUiSliderSelected then
        hintImg = hints.ui
    end

    if hintImg then
        Image.draw(hintImg, 35, prevMenu.y - 10)
    end
end


    local prevImg = isPrevSelected and prevMenu.selected or prevMenu.static
    if prevImg then Image.draw(prevImg, prevMenu.x, prevMenu.y) end

    screen.flip()
end

drawui()

-- Main loop
while true do
    buttons.read()

    -- Navigation
    if buttons.pressed(buttons.down) then
        if isSliderSelected then
            isSliderSelected, isVideoSliderSelected = false, true
        elseif isVideoSliderSelected then
            isVideoSliderSelected, isUiSliderSelected = false, true
        elseif isUiSliderSelected then
            isUiSliderSelected, isPrevSelected = false, true
        end
        sound.play("assets/sounds/select.wav", sound.WAV_1, false, false)
        sound.volume(sound.WAV_1, uiLevel * 10)
        drawui()
    elseif buttons.pressed(buttons.up) then
        if isPrevSelected then
            isPrevSelected, isUiSliderSelected = false, true
        elseif isUiSliderSelected then
            isUiSliderSelected, isVideoSliderSelected = false, true
        elseif isVideoSliderSelected then
            isVideoSliderSelected, isSliderSelected = false, true
        end
        sound.play("assets/sounds/select.wav", sound.WAV_1, false, false)
        sound.volume(sound.WAV_1, uiLevel * 10)
        drawui()
    end

    -- Music slider
    if isSliderSelected then
        local changed = false
        if buttons.pressed(buttons.left) and currentLevel > 0 then
            currentLevel = currentLevel - 1
            changed = true
        elseif buttons.pressed(buttons.right) and currentLevel < 10 then
            currentLevel = currentLevel + 1
            changed = true
        end
        if changed then
            sound.volume(sound.MP3, currentLevel * 10)
            drawui()
        end
    end

    -- Video slider
    if isVideoSliderSelected then
        local changed = false
        if buttons.pressed(buttons.left) and videoLevel > 0 then
            videoLevel = videoLevel - 1
            pmpvolume = videoLevel * 10
            changed = true
        elseif buttons.pressed(buttons.right) and videoLevel < 10 then
            videoLevel = videoLevel + 1
            pmpvolume = videoLevel * 10
            changed = true
        end
        if changed then
            drawui()
        end
    end

    -- UI sound slider
    if isUiSliderSelected then
        local changed = false
        if buttons.pressed(buttons.left) and uiLevel > 0 then
            uiLevel = uiLevel - 1
            changed = true
        elseif buttons.pressed(buttons.right) and uiLevel < 10 then
            uiLevel = uiLevel + 1
            changed = true
        end
        if changed then
            sound.volume(sound.WAV_1, uiLevel * 10)
            drawui()
        end
    end

    -- Confirm and exit
    if isPrevSelected and buttons.pressed(buttons.cross) then
        -- Save levels
        local function saveLevel(path, level)
            local save = io.open(path, "w")
            if save then save:write(tostring(level)) save:close() end
        end

        saveLevel("assets/saves/sound_levels/menumusic.txt", currentLevel)
        saveLevel("assets/saves/sound_levels/pmpvideos.txt", videoLevel)
        saveLevel("assets/saves/sound_levels/uisounds.txt", uiLevel)

        -- Unload everything
        local function unloadList(list)
            for i = 1, #list do
                if list[i] then Image.unload(list[i]) end
            end
        end

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
        sound.volume(sound.WAV_1, uiLevel * 10)
        break
    end
end
