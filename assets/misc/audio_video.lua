local bg = Image.load("assets/mainmenu/bg.png") -- load bg
local audiovideotext = Image.load("assets/mainmenu/settings/audiovideo_text.png") -- load audiovideotext


-- load sliders
local sliderStatic   = Image.load("assets/mainmenu/settings/slider_static.png")
local sliderSelected = Image.load("assets/mainmenu/settings/slider_selected.png")

-- load hints
local hints = {
    music = Image.load("assets/mainmenu/settings/menumusic_text.png"),
    video = Image.load("assets/mainmenu/settings/pmpvideos_text.png"),
    ui = Image.load("assets/mainmenu/settings/uisounds_text.png")
}

local sliders = {
    {
        name = "music",
        prefix = "menumusic_",
        y = 55,
        soundType = sound.MP3,
        level = 10,
    },
    {
        name = "video",
        prefix = "pmpvideos_",
        y = 85,
        soundType = nil,
        level = 10,
    },
    {
        name = "ui",
        prefix = "uisounds_",
        y = 115,
        soundType = sound.WAV_1,
        level = 10,
    }
}

for _, slider in ipairs(sliders) do
    slider.staticImages = {}
    slider.selectedImages = {}
    slider.positions = {}
    for i = 0, 10 do
        slider.staticImages[i + 1] = Image.load("assets/mainmenu/settings/" .. slider.prefix .. i .. "_static.png")
        slider.selectedImages[i + 1] = Image.load("assets/mainmenu/settings/" .. slider.prefix .. i .. "_selected.png")
        table.insert(slider.positions, { x = 35 + i * 16.3, y = slider.y })
    end
end

local function loadLevels(path)
    local file = io.open(path, "r")
    if file then
        for i = 1, 3 do
            local level = tonumber(file:read("*l"))
            if sliders[i] and level then sliders[i].level = level end
        end
        file:close()
    else
        for _, s in ipairs(sliders) do s.level = 5 end
    end
end

loadLevels("assets/saves/soundlevels.txt")

for _, s in ipairs(sliders) do
    if s.soundType then sound.volume(s.soundType, s.level * 10) end
end

local prevMenu = {
    static = Image.load("assets/buttons/PREVIOUSMENU_ENG_STATIC.png"),
    selected = Image.load("assets/buttons/PREVIOUSMENU_ENG_SELECTED.png"),
    x = 0,
    y = 220
}

local selectedIndex = 1
local inPrev = false

-- draw ui
local function drawui()
    screen.clear()
    if bg then Image.draw(bg, 0, 0) end
    if audiovideotext then Image.draw(audiovideotext, 35, 38, 120, 13) end

    for i, s in ipairs(sliders) do
        local imgList = (selectedIndex == i) and s.selectedImages or s.staticImages
        local sliderImg = (selectedIndex == i) and sliderSelected or sliderStatic
        local pos = s.positions[s.level + 1]
        local img = imgList[s.level + 1]
        if img then Image.draw(img, 35, s.y) end
        if sliderImg then Image.draw(sliderImg, pos.x, pos.y, nil, nil, nil, nil, nil, nil, nil, nil, 190) end
    end

    if not inPrev and hints[sliders[selectedIndex].name] then
        Image.draw(hints[sliders[selectedIndex].name], 35, prevMenu.y - 10)
    end

    local prevImg = (inPrev and prevMenu.selected) or prevMenu.static
    if prevImg then Image.draw(prevImg, prevMenu.x, prevMenu.y) end

    debugoverlay.draw(debugoverlay.loadSettings())
    screen.flip()
end

drawui()

while true do
    buttons.read()

    -- navgigation logic
    if buttons.pressed(buttons.down) then
        if not inPrev then
            selectedIndex = selectedIndex + 1
            if selectedIndex > #sliders then
                selectedIndex = #sliders
                inPrev = true
            end
        end
        sound.play("assets/sounds/select.wav", sound.WAV_1, false, false)
        sound.volume(sound.WAV_1, sliders[3].level * 10)
        drawui()
    elseif buttons.pressed(buttons.up) then
        if inPrev then
            inPrev = false
            selectedIndex = #sliders
        elseif selectedIndex > 1 then
            selectedIndex = selectedIndex - 1
        end
        sound.play("assets/sounds/select.wav", sound.WAV_1, false, false)
        sound.volume(sound.WAV_1, sliders[3].level * 10)
        drawui()
    end

    -- slider logic
    if not inPrev then
        local s = sliders[selectedIndex]
        local changed = false
        if buttons.pressed(buttons.left) and s.level > 0 then
            s.level = s.level - 1
            changed = true
        elseif buttons.pressed(buttons.right) and s.level < 10 then
            s.level = s.level + 1
            changed = true
        end
        if changed then
            if s.name == "video" then pmpvolume = s.level * 10 end
            if s.soundType then sound.volume(s.soundType, s.level * 10) end
            drawui()
        end
    end

    if inPrev and buttons.pressed(buttons.cross) then
        local save = io.open("assets/saves/soundlevels.txt", "w")
        if save then
            for _, s in ipairs(sliders) do
                save:write(s.level .. "\n")
            end
            save:close()
        end

        for _, s in ipairs(sliders) do
            for i = 1, #s.staticImages do Image.unload(s.staticImages[i]) end
            for i = 1, #s.selectedImages do Image.unload(s.selectedImages[i]) end
        end

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
