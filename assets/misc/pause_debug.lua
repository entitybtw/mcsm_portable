local buttonsList = {
	{ id = "FREERAM", text = "Free RAM", isToggle = true, state = false },
	{ id = "BATTERY", text = "Battery", isToggle = true, state = false },
	{ id = "CPUFREQ", text = "CPU Freq", isToggle = true, state = false },
	{ id = "NICKNAME", text = "Nickname", isToggle = true, state = false },
	{ id = "TIMEDATE", text = "Time/Date", isToggle = true, state = false },
}

local selectedButton = 1
local buttonSprites = {
	selected = { srcx = 0, srcy = 164, srcw = 183, srch = 25 },
	static = { srcx = 184, srcy = 165, srcw = 183, srch = 25 },
}

local function drawButtons()
	local startX, startY, gap = 175, 40, 3
	local buttonScale = 0.75  -- Масштаб кнопок
	local textScale = 0.3 * buttonScale  -- Масштаб текста пропорционально кнопкам

	for i, button in ipairs(buttonsList) do
		local sprite = (i == selectedButton) and buttonSprites.selected or buttonSprites.static
		
		-- Масштабируем размеры спрайтов
		local scaledWidth = sprite.srcw * buttonScale + 3
		local scaledHeight = sprite.srch * buttonScale + 3
		local y = startY + (i - 1) * (scaledHeight + gap * buttonScale)

		Image.draw(
			spritesheet,
			startX,
			y,
			scaledWidth,
			scaledHeight,
			nil,
			sprite.srcx,
			sprite.srcy,
			sprite.srcw,
			sprite.srch,
			nil,
			nil,
			nil
		)

		-- Формируем текст с состоянием ON/OFF
		local label = button.text .. ": " .. (button.state and "ON" or "OFF")
		local textColor = (i == selectedButton) and Color.new(255, 255, 153) or Color.new(255, 255, 255)
		local textWidth = intraFont.textW(font, label, textScale)
		local textHeight = intraFont.textH(font) * textScale

		intraFont.printShadowed(
			startX + (scaledWidth - textWidth) / 2,
			y + (scaledHeight - textHeight) / 4,
			label,
			textColor,
			Color.new(0, 0, 0),
			font,
			90,
			1,
			textScale,
			0
		)
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
				text = string.format(
					"Time: %02d:%02d:%02d %02d/%02d/%04d",
					t.hour,
					t.minutes,
					t.seconds,
					t.day,
					t.month,
					t.year
				)
			end
			LUA.print(0, y, text)
			y = y + 13
		end
	end
end

local function saveSystemInfo()
	local file = io.open("assets/saves/debuginfo.txt", "w")
	if not file then
		return
	end
	for _, btn in ipairs(buttonsList) do
		if btn.isToggle then
			file:write(string.format("%s:%d\n", btn.id, btn.state and 1 or 0))
		end
	end
	file:close()
end

local function loadSystemInfo()
	local file = io.open("assets/saves/debuginfo.txt", "r")
	if not file then
		return
	end
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
	Image.draw(pause_bg, 0, 0)

	if buttons.pressed(buttons.up) and selectedButton > 1 then
		selectedButton = selectedButton - 1
		sound.playEasy("assets/sounds/select.wav", sound.WAV_1, false, false, uiLevel * 10)
	end
	if buttons.pressed(buttons.down) and selectedButton < #buttonsList then
		selectedButton = selectedButton + 1
		sound.playEasy("assets/sounds/select.wav", sound.WAV_1, false, false, uiLevel * 10)
	end
	if buttons.pressed(buttons.cross) then
		local current = buttonsList[selectedButton]
		if current.isToggle then
			current.state = not current.state
			sound.playEasy("assets/sounds/lava.wav", sound.WAV_1, false, false, uiLevel * 10)
		end
	end
	if buttons.pressed(buttons.circle) then
		saveSystemInfo()
		sound.playEasy("assets/sounds/skeleton_1.wav", sound.WAV_1, false, false, uiLevel * 10)
		ui_enabled = false
		screen.flip()
		LUA.sleep(165)
		ui_enabled = true
		break
	end

	if ui_enabled then
	drawButtons()
	drawSystemInfo()
	intraFont.printShadowed(
		230 - intraFont.textW(font, ui.debug_menu, 0.3) / 2 + 14,
		25,
		ui.debug_menu,
		Color.new(255, 255, 255),
		Color.new(0, 0, 0),
		font,
		90,
		1,
		0.3,
		0
	)
	Image.draw(
		spritesheet,
		240 - intraFont.textW(font, ui.previous_menu, 0.3) / 2 - 2,
		233 + 13,
		14,
		14,
		nil,
		384,
		0,
		15,
		15
	)
	intraFont.printShadowed(
		240 - intraFont.textW(font, ui.previous_menu, 0.3) / 2 + 14,
		233 + 14,
		ui.previous_menu,
		Color.new(255, 255, 255),
		Color.new(0, 0, 0),
		font,
		90,
		1,
		0.3,
		0
	)
end
	screen.flip()
end
