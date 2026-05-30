-- Общая логика для audio_video.lua и pause_audio_video.lua
-- Вызывать: dofile("assets/misc/av_common.lua") с предустановленным av_offsetX

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

local subssizeOptions = { 1, 1.4, 1.415 }
local subssizeIndex = 2
for i, v in ipairs(subssizeOptions) do
	if v == subssize then subssizeIndex = i; break end
end

local function generatePositions(yPos)
	local positions = {}
	for i = 0, 10 do
		table.insert(positions, { x = av_offsetX + i * 16.3, y = yPos + 10 })
	end
	return positions
end

local function loadLevels(path)
	local file = io.open(path, "r")
	if file then
		local t = {}
		for i = 1, 3 do t[i] = tonumber(file:read("*l")) end
		file:close()
		return unpack(t)
	end
	return 5, 5, 5
end

local function saveLevels(path, levels)
	local file = io.open(path, "w")
	if file then
		for _, v in ipairs(levels) do file:write(v .. "\n") end
		file:close()
	end
end

local menumusic, pmpvideos, uiLevel = loadLevels("assets/saves/soundlevels.txt")

local sliders = {
	{ name = ui.menumusic_volume, level = menumusic, positions = generatePositions(av_sliderY),        apply = function(l) sound.volumeEasy(5, l * 10) end,              hintText = ui.music },
	{ name = ui.pmp_volume,       level = pmpvideos, positions = generatePositions(av_sliderY + 30),   apply = function(l) pmpvolume = l * 10 end,                        hintText = ui.video },
	{ name = ui.ui_volume,        level = uiLevel,   positions = generatePositions(av_sliderY + 60),   apply = function(l) sound.volumeEasy(sound.WAV_1, l * 10) end,     hintText = ui.ui   },
}

for _, s in ipairs(sliders) do s.apply(s.level) end

local selectedIndex = 1
local totalItems = #sliders + 2

local buttonSprites = {
	selected = { srcx = 0,   srcy = 164, srcw = 183, srch = 25 },
	static   = { srcx = 184, srcy = 165, srcw = 183, srch = 25 },
}
local sliderSprites = {
	bg       = { srcx = 227, srcy = 110, srcw = 180, srch = 26 },
	selected = { srcx = 407, srcy = 110, srcw = 18,  srch = 26 },
	static   = { srcx = 425, srcy = 110, srcw = 18,  srch = 26 },
}

local function drawSlider(slider, isSelected, y)
	local x = av_offsetX - 2
	Image.draw(spritesheet, x, y, sliderSprites.bg.srcw, sliderSprites.bg.srch, nil, sliderSprites.bg.srcx, sliderSprites.bg.srcy, sliderSprites.bg.srcw, sliderSprites.bg.srch)
	local text = slider.name .. ": " .. tostring(slider.level)
	local tw = intraFont.textW(font, text, 1)
	local th = intraFont.textH(font)
	local color = isSelected and Color.new(255, 255, 153) or Color.new(255, 255, 255)
	intraFont.printShadowed(x + (179 - tw) / 2, math.floor(y + (37 - th) / 2), text, color, Color.new(0, 0, 0), font, 90, 1, 1, 0)
	local pos = slider.positions[slider.level + 1]
	local ss = isSelected and sliderSprites.selected or sliderSprites.static
	Image.draw(spritesheet, pos.x, y, ss.srcw, ss.srch, nil, ss.srcx, ss.srcy, ss.srcw, ss.srch)
end

local function drawToggle(text, stateText, isSelected, y)
	local x = av_offsetX - 2
	local sprite = isSelected and buttonSprites.selected or buttonSprites.static
	Image.draw(spritesheet, x, y, sprite.srcw, sprite.srch, nil, sprite.srcx, sprite.srcy, sprite.srcw, sprite.srch)
	local fullText = text .. ": " .. stateText
	local tw = intraFont.textW(font, fullText, 1)
	local th = intraFont.textH(font)
	local color = isSelected and Color.new(255, 255, 153) or Color.new(255, 255, 255)
	intraFont.printShadowed(x + (179 - tw) / 2, math.floor(y + (37 - th) / 2), fullText, color, Color.new(0, 0, 0), font, 90, 1, 1, 0)
end

local function drawui()
	intraFont.printShadowed(av_titleX, av_titleY, ui.audiovideotext, Color.new(255, 255, 255), Color.new(0, 0, 0), font, 90, 1, 1, 0)
	for i, slider in ipairs(sliders) do
		drawSlider(slider, i == selectedIndex, av_sliderY - 2 + i * 30)
	end
	drawToggle("Subtitles", subs and "On" or "Off", selectedIndex == #sliders + 1, 1 + (#sliders + 1) * av_toggleStep)
	local sizeText = (subssizeIndex == 1 and "Small") or (subssizeIndex == 2 and "Medium") or "Large"
	drawToggle("Subtitle Size", sizeText, selectedIndex == #sliders + 2, 1 + (#sliders + 2) * (av_toggleStep - 1))
	local hintText
	if selectedIndex <= #sliders then
		hintText = sliders[selectedIndex].hintText
	elseif selectedIndex == #sliders + 1 then
		hintText = ui.subs
	else
		hintText = ui.subssize
	end
	if hintText then
		intraFont.printShadowed(av_hintX, av_hintY, hintText, Color.new(255, 255, 255), Color.new(0, 0, 0), font, 90, 1, 1, 0)
	end
end

while true do
	buttons.read()
	screen.clear()
	av_drawBg()
	if ui_enabled then
		av_drawHint()
		drawui()
	end
	screen.flip()

	if buttons.pressed(buttons.down) and selectedIndex < totalItems then
		selectedIndex = selectedIndex + 1
		sound.playEasy("assets/sounds/select.wav", sound.WAV_1, false, false, uiLevel * 10)
	elseif buttons.pressed(buttons.up) and selectedIndex > 1 then
		selectedIndex = selectedIndex - 1
		sound.playEasy("assets/sounds/select.wav", sound.WAV_1, false, false, uiLevel * 10)
	end

	if selectedIndex <= #sliders then
		local slider = sliders[selectedIndex]
		if buttons.pressed(buttons.left) and slider.level > 0 then
			slider.level = slider.level - 1
			sound.playEasy("assets/sounds/skeleton_2.wav", sound.WAV_1, false, false, uiLevel * 10)
			slider.apply(slider.level)
		elseif buttons.pressed(buttons.right) and slider.level < 10 then
			slider.level = slider.level + 1
			sound.playEasy("assets/sounds/skeleton_2.wav", sound.WAV_1, false, false, uiLevel * 10)
			slider.apply(slider.level)
		end
	elseif selectedIndex == #sliders + 1 then
		if buttons.pressed(buttons.cross) then
			subs = not subs
			sound.playEasy("assets/sounds/lava.wav", sound.WAV_1, false, false, uiLevel * 10)
			saveSubtitles()
		end
	elseif selectedIndex == #sliders + 2 then
		if buttons.pressed(buttons.cross) then
			subssizeIndex = subssizeIndex % #subssizeOptions + 1
			subssize = subssizeOptions[subssizeIndex]
			sound.playEasy("assets/sounds/lava.wav", sound.WAV_1, false, false, uiLevel * 10)
			saveSubtitles()
		end
	end

	if buttons.pressed(buttons.circle) then
		local levelsToSave = {}
		for _, slider in ipairs(sliders) do table.insert(levelsToSave, slider.level) end
		saveLevels("assets/saves/soundlevels.txt", levelsToSave)
		saveSubtitles()
		av_onExit()
		break
	end
end
