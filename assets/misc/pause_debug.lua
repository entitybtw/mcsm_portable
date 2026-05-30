local buttonsList = debugoverlay.getButtons()
local selectedButton = 1
debugoverlay.loadSettings()

local buttonSprites = {
	selected = { srcx = 0, srcy = 164, srcw = 183, srch = 25 },
	static = { srcx = 184, srcy = 165, srcw = 183, srch = 25 },
}

local function drawButtons(startX)
	local startY, gap, buttonScale = 40, 3, 0.75
	for i, button in ipairs(buttonsList) do
		local sprite = (i == selectedButton) and buttonSprites.selected or buttonSprites.static
		local scaledWidth = sprite.srcw * buttonScale + 3
		local scaledHeight = sprite.srch * buttonScale + 3
		local y = startY + (i - 1) * (scaledHeight + gap * buttonScale)
		Image.draw(spritesheet, startX, y, scaledWidth, scaledHeight, nil, sprite.srcx, sprite.srcy, sprite.srcw, sprite.srch)
		local label = button.text .. ": " .. (button.state and "ON" or "OFF")
		local textColor = (i == selectedButton) and Color.new(255, 255, 153) or Color.new(255, 255, 255)
		local textWidth = intraFont.textW(font, label, 1)
		local textHeight = intraFont.textH(font)
		intraFont.printShadowed(
			math.floor(startX + (scaledWidth - textWidth) / 2),
			math.floor(y + (scaledHeight - textHeight) / 4),
			label, textColor, Color.new(0, 0, 0), font, 90, 1, 1, 0
		)
	end
end

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
		current.state = not current.state
		sound.playEasy("assets/sounds/lava.wav", sound.WAV_1, false, false, uiLevel * 10)
	end
	if buttons.pressed(buttons.circle) then
		debugoverlay.saveDebugInfo()
		debugoverlay.loadSettings()
		sound.playEasy("assets/sounds/skeleton_1.wav", sound.WAV_1, false, false, uiLevel * 10)
		ui_enabled = false
		screen.flip()
		LUA.sleep(165)
		ui_enabled = true
		break
	end

	if ui_enabled then
		drawButtons(175)
		debugoverlay.draw()
		intraFont.printShadowed(
			230 - intraFont.textW(font, ui.debug_menu, 1) / 2 + 14,
			25, ui.debug_menu, Color.new(255, 255, 255), Color.new(0, 0, 0), font, 90, 1, 1, 0
		)
		Image.draw(spritesheet, 240 - intraFont.textW(font, ui.previous_menu, 1) / 2 - 2, 233 + 13, 14, 14, nil, 384, 0, 15, 15)
		intraFont.printShadowed(
			240 - intraFont.textW(font, ui.previous_menu, 1) / 2 + 14,
			233 + 14, ui.previous_menu, Color.new(255, 255, 255), Color.new(0, 0, 0), font, 90, 1, 1, 0
		)
	end
	screen.flip()
end
