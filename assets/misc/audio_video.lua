-- Load background
local bg = Image.load("assets/mainmenu/bg.png")
local audiovideotext = Image.load("assets/mainmenu/options/audiovideo_text.png")

-- Image preloader
local function preloadImages(prefix, suffix, count)
    local list = {}
    for i = 0, count do
        list[i + 1] = Image.load("assets/mainmenu/options/" .. string.format("%s%d%s", prefix, i, suffix))
    end
    return list
end

-- Load all image sets
local sliders = {
    {
        name = "music",
        level = 5,
        file = "assets/saves/menumusic.txt",
        static = preloadImages("menumusic_", "_static.png", 10),
        selected = preloadImages("menumusic_", "_selected.png", 10),
        posY = 55,
        soundType = sound.MP3
    },
    {
        name = "video",
        level = 5,
        file = "assets/saves/pmpvideos.txt",
        static = preloadImages("pmpvideos_", "_static.png", 10),
        selected = preloadImages("pmpvideos_", "_selected.png", 10),
        posY = 85,
    },
    {
        name = "ui",
        level = 5,
        file = "assets/saves/uisounds.txt",
        static = preloadImages("uisounds_", "_static.png", 10),
        selected = preloadImages("uisounds_", "_selected.png", 10),
        posY = 115,
        soundType = sound.WAV_1
    }
}

-- Slider visuals
local sliderStatic   = Image.load("assets/mainmenu/options/slider_static.png")
local sliderSelected = Image.load("assets/mainmenu/options/slider_selected.png")

-- Generate slider positions
for _, s in ipairs(sliders) do
    s.positions = {}
    for i = 0, 10 do
        table.insert(s.positions, { x = 35 + i * 16.3, y = s.posY })
    end
end

-- Load saved levels
local function loadLevel(path)
    local file = io.open(path, "r")
    if file then
        local saved = tonumber(file:read("*l"))
        file:close()
        if saved and saved >= 0 and saved <= 10 then return saved end
    end
    return 5
end

for _, s in ipairs(sliders) do
    s.level = loadLevel(s.file)
    if s.soundType then sound.volume(s.soundType, s.level * 10) end
end

-- Previous menu button
local prevMenu = {
    static = Image.load("assets/buttons/PREVIOUSMENU_ENG_STATIC.png"),
    selected = Image.load("assets/buttons/PREVIOUSMENU_ENG_SELECTED.png"),
    x = 0, y = 220
}

-- UI state
local selectedIndex = 1
local inPrev = false

-- Draw UI
local function drawUI()
    screen.clear()
    if bg then Image.draw(bg, 0, 0) end
    if audiovideotext then Image.draw(audiovideotext, 35, 38, 120, 13) end

    for i, s in ipairs(sliders) do
        local isSelected = (selectedIndex == i and not inPrev)
        local img = isSelected and s.selected[s.level + 1] or s.static[s.level + 1]
        if img then Image.draw(img, 35, s.posY) end

        local pos = s.positions[s.level + 1]
        local slider = isSelected and sliderSelected or sliderStatic
        if slider then Image.draw(slider, pos.x, pos.y, nil, nil, nil, nil, nil, nil, nil, nil, 190) end
    end

    local prevImg = inPrev and prevMenu.selected or prevMenu.static
    if prevImg then Image.draw(prevImg, prevMenu.x, prevMenu.y) end

    screen.flip()
end

-- First draw
drawUI()

-- Main loop
while true do
    buttons.read()

    if buttons.pressed(buttons.down) then
        if not inPrev then
            if selectedIndex < #sliders then
                selectedIndex = selectedIndex + 1
            else
                inPrev = true
            end
        end
        sound.play("assets/sounds/select.wav", sound.WAV_1, false, false)
        drawUI()

    elseif buttons.pressed(buttons.up) then
        if inPrev then
            inPrev = false
        elseif selectedIndex > 1 then
            selectedIndex = selectedIndex - 1
        end
        sound.play("assets/sounds/select.wav", sound.WAV_1, false, false)
        drawUI()
    end

    -- Slider logic
    if not inPrev then
        local s = sliders[selectedIndex]
        if buttons.pressed(buttons.left) and s.level > 0 then
            s.level = s.level - 1
            if s.soundType then sound.volume(s.soundType, s.level * 10) end
            drawUI()
        elseif buttons.pressed(buttons.right) and s.level < 10 then
            s.level = s.level + 1
            if s.soundType then sound.volume(s.soundType, s.level * 10) end
            drawUI()
        end
    end

    -- Confirm exit
    if inPrev and buttons.pressed(buttons.cross) then
        -- Save levels
        for _, s in ipairs(sliders) do
            local save = io.open(s.file, "w")
            if save then save:write(tostring(s.level)) save:close() end
        end

        -- Unload images
        local function unload(list)
            for _, img in ipairs(list) do if img then Image.unload(img) end end
        end

        for _, s in ipairs(sliders) do
            unload(s.static)
            unload(s.selected)
        end

        if bg then Image.unload(bg) end
        if sliderStatic then Image.unload(sliderStatic) end
        if sliderSelected then Image.unload(sliderSelected) end
        if prevMenu.static then Image.unload(prevMenu.static) end
        if prevMenu.selected then Image.unload(prevMenu.selected) end
	if audiovideotext then Image.unload(audiovideotext) end

        sound.play("assets/sounds/skeleton_1.wav", sound.WAV_1, false, false)
        sound.volume(sound.WAV_1, sliders[3].level * 10) -- UI volume
        break
    end
end
