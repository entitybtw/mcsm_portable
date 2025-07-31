function sound.playEasy(path, channel, loop, loadToRAM)
    if type(path) ~= "string" then return end

    if type(loadToRAM) ~= "boolean" then
        loadToRAM = false
    end

    if type(loop) ~= "boolean" then
        loop = false
    end

    sound.cloud(path, channel, loadToRAM)
    sound.play(channel, loop)
end

function sound.volumeEasy(channel, volume)

    sound.volume(channel, volume, volume)
end
local function hexToColor(input)
	if not input then
		return Color.new(255, 255, 255), nil
	end

	local parts = {}
	for part in string.gmatch(input, "[^/]+") do
		table.insert(parts, part)
	end

	local function hexToColorPart(hex, forcedAlpha)
		hex = hex:gsub("#", "")
		local r = tonumber(hex:sub(1, 2), 16) or 255
		local g = tonumber(hex:sub(3, 4), 16) or 255
		local b = tonumber(hex:sub(5, 6), 16) or 255
		local a = forcedAlpha or tonumber(hex:sub(7, 8), 16) or 255
		return Color.new(r, g, b, a)
	end

	if #parts == 1 then
		return hexToColorPart(parts[1]), nil
	elseif #parts == 2 then
		if parts[2]:match("^%d+$") then
			local alpha = tonumber(parts[2])
			return hexToColorPart(parts[1], alpha), nil
		else
			return hexToColorPart(parts[1]), hexToColorPart(parts[2])
		end
	elseif #parts == 3 then
		local alpha = tonumber(parts[3])
		return hexToColorPart(parts[1], alpha), hexToColorPart(parts[2], alpha)
	end

	return Color.new(255, 255, 255), nil
end


local function splitString(input)
	local result = {}
	for line in string.gmatch(input, "[^\n]+") do
		table.insert(result, line)
	end
	return result
end

function PMP.playEasy(path, stopButton, getPointer, subsPath, fontPath, fontSize, hexColor, hexBg, subsControl, loop)
    if type(getPointer) ~= "boolean" then getPointer = false end
    if type(loop) ~= "boolean" then loop = false end

    local usedFont
    if type(fontPath) == "userdata" or type(fontPath) == "table" then
        usedFont = fontPath
    elseif type(fontPath) == "string" then
        usedFont = intraFont.load(fontPath)
    else
        usedFont = font
    end

    -- Заменяем динамические функции на простые значения
    local fontSizeNow = fontSize or 12
    local subsEnabledNow = subsControl ~= false

    pointer = PMP.play(path, getPointer, loop, subsPath, stopButton)

    local colorStart, colorEnd
    if hexColor and hexColor:find("/") then
        local parts = {}
        for part in hexColor:gmatch("[^/]+") do
            table.insert(parts, part)
        end
        colorStart = hexToColor(parts[1])
        colorEnd = hexToColor(parts[2])
    else
        colorStart = hexToColor(hexColor)
    end

    local bgColor = hexToColor(hexBg)

    local paused = false

    while PMP.getFrame(pointer) do
        screen.clear()
        buttons.read()


        Image.draw(pointer, 0, 0)

        -- Используем статичные fontSizeNow и subsEnabledNow
        if subsEnabledNow then
            local subs = PMP.getSubs()
            if subs and subs ~= "" then
                for i, line in ipairs(splitString(subs)) do
                    local y = 210 + fontSizeNow * (i - 1)
                    local x = 240 - intraFont.textW(usedFont, line, fontSizeNow) / 2
                    local w = intraFont.textW(usedFont, line, fontSizeNow)
                    local h = fontSizeNow + 6


                    if colorEnd then
                        screen.filledRect(x - 4, y - 2, w + 7, h + 12, bgColor)
                        intraFont.printGradient(x, y, line, colorStart, colorEnd, usedFont, fontSizeNow)
                    else
                        intraFont.printBackground(x, y, line, colorStart, bgColor, usedFont, fontSizeNow)
                    end                                  
                end
            end
        end

        if stopButton and buttons.pressed(stopButton) then
            PMP.stop(pointer)
            break
        elseif buttons.pressed(buttons.start) then
            if not paused then
                PMP.pause()
                local code = dofile("assets/misc/pause.lua")
                if code == -1 then
                    PMP.stop(pointer)
                    return 1
                end
            end
        end

        if buttons.pressed(buttons.select) then
            paused = not paused
            PMP.pause()
        end

        if paused then
            screen.filledRect(0, 0, 480, 272, Color.new(0, 0, 0), nil, 150)
            intraFont.print(235 - intraFont.textW(font, "Paused", 1) / 2 + 8, 105 + 14, "Paused", Color.new(255,255,255), font, 1)
        end

        screen.flip()
    end
end
