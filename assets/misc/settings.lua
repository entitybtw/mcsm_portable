local selectedButton = 1
debugoverlay.loadSettings()

local buttonsList = {
	{ text = ui.controls },
	{ text = ui.audiovideo },
	{ text = ui.debug },
	{ text = ui.credits },
}

local buttonSprites = {
	selected = { srcx = 0, srcy = 164, srcw = 183, srch = 25 },
	static = { srcx = 184, srcy = 165, srcw = 183, srch = 25 },
}

local function drawButtons()
    local startX, startY, gap = 45, 50, 3
    local buttonScale = 0.75 

    for i, button in ipairs(buttonsList) do
        local sprite = (i == selectedButton) and buttonSprites.selected or buttonSprites.static
        
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

        local textScale = 1 * buttonScale  
        local textColor = (i == selectedButton) and Color.new(255, 255, 153) or Color.new(255, 255, 255)
        local textWidth = intraFont.textW(font, button.text, textScale)
        local textHeight = intraFont.textH(font) * textScale

        intraFont.printShadowed(
            math.floor(startX + (scaledWidth - textWidth) / 2),
            math.floor(y + (scaledHeight - textHeight) / 2),
            button.text,
            textColor,
            Color.new(0, 0, 0),
            font,
            90,
            1,
            1,
            0
        )
    end
end

while true do
	screen.clear()
	buttons.read()

	if PMP.getFrame(videoFrame) then
		Image.draw(videoFrame, 0, 0)
	end

	if buttons.pressed(buttons.up) and selectedButton > 1 then
		selectedButton = selectedButton - 1
	sound.playEasy("assets/sounds/select.wav", sound.WAV_1, false, false, uiLevel * 10)
	end
	if buttons.pressed(buttons.down) and selectedButton < #buttonsList then
		selectedButton = selectedButton + 1
	sound.playEasy("assets/sounds/select.wav", sound.WAV_1, false, false, uiLevel * 10)
	end

	if buttons.pressed(buttons.cross) then
		if selectedButton == 1 then
			sound.playEasy("assets/sounds/click.wav", sound.WAV_1, false, false, uiLevel * 10)
			ui_enabled = false
			screen.flip()
			menuTransition(11)
			ui_enabled = true
			dofile("assets/misc/controls.lua")
		elseif selectedButton == 2 then
			sound.playEasy("assets/sounds/click.wav", sound.WAV_1, false, false, uiLevel * 10)
			ui_enabled = false
			screen.flip()
			menuTransition(11)
			ui_enabled = true
			dofile("assets/misc/audio_video.lua")
		elseif selectedButton == 3 then
			sound.playEasy("assets/sounds/click.wav", sound.WAV_1, false, false, uiLevel * 10)
			ui_enabled = false
			screen.flip()
			menuTransition(11)
			ui_enabled = true
			dofile("assets/misc/debug.lua")
		elseif selectedButton == 4 then
			sound.playEasy("assets/sounds/click.wav", sound.WAV_1, false, false, uiLevel * 10)
			ui_enabled = false
			screen.flip()
			menuTransition(11)
			ui_enabled = true
			dofile("assets/misc/credits_episodes.lua")
		end
	end
	if buttons.pressed(buttons.circle) then
		sound.playEasy("assets/sounds/skeleton_1.wav", sound.WAV_1, false, false, uiLevel * 10)
		break
	end

	if ui_enabled then
	drawButtons()

	debugoverlay.draw()
	intraFont.printShadowed(45, 35, ui.settings, Color.new(255, 255, 255), Color.new(0, 0, 0), font, 90, 1, 1, 0)
Image.draw(spritesheet, 61 - 16, 233, 13, 13, nil, 399, 0, 15, 15)

intraFont.printShadowed(
    61,
    233,
    ui.select,
    Color.new(255, 255, 255),
    Color.new(0, 0, 0),
    font,
    90,
    1,
    1,
    0
)

Image.draw(spritesheet, 61 + intraFont.textW(font, ui.select, 1) + 10, 233, 13, 13, nil, 384, 0, 15, 15)

intraFont.printShadowed(
    61 + intraFont.textW(font, ui.select, 1) + 10 + 16,
    234,
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
	screen.flip()
end
