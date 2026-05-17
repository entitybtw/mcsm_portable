local buttonsList = {
	{ text = ui.controls },
	{ text = ui.audiovideo },
	{ text = ui.debug },
}

local selectedButton = 1
local buttonSprites = {
	selected = { srcx = 0, srcy = 164, srcw = 183, srch = 25 },
	static = { srcx = 184, srcy = 165, srcw = 183, srch = 25 },
}

local function drawButtons()
    local startX, startY, gap = 175, 40, 3
    local buttonScale = 0.75  -- Добавьте масштабирование кнопок

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

        -- Увеличиваем масштаб текста пропорционально
        local textScale = 1 * buttonScale  -- Было 1
        local textColor = (i == selectedButton) and Color.new(255, 255, 153) or Color.new(255, 255, 255)
        local textWidth = intraFont.textW(font, button.text, textScale)
        local textHeight = intraFont.textH(font) * textScale

        intraFont.printShadowed(
            startX + (scaledWidth - textWidth) / 2,
            y + (scaledHeight - textHeight) / 4,
            button.text,
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
	if buttons.pressed(buttons.circle) then
		sound.playEasy("assets/sounds/skeleton_1.wav", sound.WAV_1, false, false, uiLevel * 10)
		ui_enabled = false
		screen.flip()
		LUA.sleep(165)
		ui_enabled = true
		break
	end
	if buttons.pressed(buttons.cross) then
		if selectedButton == 1 then
			sound.playEasy("assets/sounds/click.wav", sound.WAV_1, false, false, uiLevel * 10)
			ui_enabled = false
			screen.flip()
			LUA.sleep(165)
			ui_enabled = true
			dofile("assets/misc/pause_controls.lua")
		elseif selectedButton == 2 then
			sound.playEasy("assets/sounds/click.wav", sound.WAV_1, false, false, uiLevel * 10)
			ui_enabled = false
			screen.flip()
			LUA.sleep(165)
			ui_enabled = true
			dofile("assets/misc/pause_audio_video.lua")
		elseif selectedButton == 3 then
			sound.playEasy("assets/sounds/click.wav", sound.WAV_1, false, false, uiLevel * 10)
			ui_enabled = false
			screen.flip()
			LUA.sleep(165)
			ui_enabled = true
			dofile("assets/misc/pause_debug.lua")
		end
	end

	if ui_enabled then
	drawButtons()
	intraFont.printShadowed(
		230 - intraFont.textW(font, ui.settings, 1) / 2 + 14,
		25,
		ui.settings,
		Color.new(255, 255, 255),
		Color.new(0, 0, 0),
		font,
		90,
		1,
		1,
		0
	)
	Image.draw(
		spritesheet,
		240 - (14 + intraFont.textW(font, ui.select, 1) + 7 + 14 + intraFont.textW(font, ui.previous_menu, 1)) / 2,
		246,
		13,
		13,
		nil,
		399,
		0,
		15,
		15
	)
	intraFont.printShadowed(
		240
			- (14 + intraFont.textW(font, ui.select, 1) + 10 + 14 + intraFont.textW(font, ui.previous_menu, 1)) / 2
			+ 14
			+ 5,
		247,
		ui.select,
		Color.new(255, 255, 255),
		Color.new(0, 0, 0),
		font,
		90,
		1,
		1,
		0
	)
	Image.draw(
		spritesheet,
		240
			- (14 + intraFont.textW(font, ui.select, 1) + 7 + 14 + intraFont.textW(font, ui.previous_menu, 1)) / 2
			+ 14
			+ intraFont.textW(font, ui.select, 1)
			+ 10,
		246,
		13,
		13,
		nil,
		384,
		0,
		15,
		15
	)
	intraFont.printShadowed(
		240
			- (14 + intraFont.textW(font, ui.select, 1) + 10 + 14 + intraFont.textW(font, ui.previous_menu, 1)) / 2
			+ 14
			+ intraFont.textW(font, ui.select, 1)
			+ 10
			+ 14
			+ 5,
		247,
		ui.previous_menu,
		Color.new(255, 255, 255),
		Color.new(0, 0, 0),
		font,
		90,
		1,
		1,
		0
	)
end
	debugoverlay.draw(debugoverlay.loadSettings())
	screen.flip()
end
