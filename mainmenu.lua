local fade = 255
local welanim = 255
local step = -10
local delay_time = 4000
local c_black = Color.new(0, 0, 0)
local cos = math.cos
local stat = sound.state(5)
local arrowX = 35
local arrowStep = 0
videoFrame = PMP.play("assets/ui/mcsm_mainmenu.pmp", true, true, nil, nil, 29.97)
ui_enabled = true

local timered = timer.create()
local welanim_duration = timer.create()

local buttonsList = {
	{ text = ui.play },
	{ text = ui.episodes },
	{ text = ui.extras },
	{ text = ui.changelogs },
	{ text = ui.settings },
}

local selectedButton = 1

local buttonSprites = {
	selected = { srcx = 0, srcy = 164, srcw = 183, srch = 25 },
	static = { srcx = 184, srcy = 165, srcw = 183, srch = 25 },
}

function menuTransition(time)
	-- Время в кадрах
	-- 60 кадров = 1 секунда
	local i = time
	while i > 0 do
		i = i - 1

		screen.clear()
		if PMP.getFrame(videoFrame) then
			Image.draw(videoFrame, 0, 0)
		end
		screen.flip()
	end
end

local function drawButtons()
    local startX, startY, gap = 45, 85, 3
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
        local textScale = 0.3 * buttonScale  -- Было 0.3
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

local function drawAll()
		drawButtons()
		Image.draw(spritesheet, arrowX, 85, 14, 22, nil, 444, 0, 7, 11)
		Image.draw(spritesheet, arrowX, 130, 14, 22, nil, 444, 0, 7, 11)

		screen.filledRect(266, 199, 157, 1, Color.new(255, 255, 255), 0, welanim - 55)
		screen.filledRect(266, 239, 157, 1, Color.new(255, 255, 255), 0, welanim - 55)
		screen.filledRect(266, 199, 1, 41, Color.new(255, 255, 255), 0, welanim - 55)
		screen.filledRect(422, 199, 1, 41, Color.new(255, 255, 255), 0, welanim - 55)

		screen.filledRect(267, 200, 155, 39, Color.new(104, 171, 151), 0, welanim - 155)
		Image.draw(spritesheet, 45, 35, 140, 45, nil, 0, 48, 210, 61, nil, nil, nil, true)

		intraFont.printShadowed(
			280,
			205,
			ui.welcome,
			Color.new(255, 255, 255, welanim),
			Color.new(0, 0, 0, welanim),
			font,
			90,
			1,
			0.209,
			0
		)
		intraFont.printShadowed(
			305,
			223,
			ui.welcome_sub,
			Color.new(255, 255, 255, welanim),
			Color.new(0, 0, 0, welanim),
			font,
			90,
			1,
			0.17,
			0
		)
		intraFont.printShadowed(61, 236, ui.select, Color.new(255, 255, 255), Color.new(0, 0, 0), font, 90, 1, 0.27, 0)
		Image.draw(spritesheet, 45, 233, 13, 13, nil, 399, 0, 15, 15)
		debugoverlay.draw(debugoverlay.loadSettings())
end

function stop_sound(channel)
	local state = sound.state(channel)
	if state.state ~= "stopped" then
		sound.stop(channel)
	end
	sound.stop(channel)
end

if stat.state == "stopped" then
	sound.playEasy("assets/sounds/bg.at3", 5)
end

while true do
	screen.clear()
	buttons.read()
	if PMP.getFrame(videoFrame) then
		Image.draw(videoFrame, 0, 0)
	end

	if fade_enabled == 1 then
		if fade > 0 then
			fade = fade - 8
		end
	end

	if timer.time(timered) == 0 then
		timer.start(timered)
	end

	if timer.time(welanim_duration) == 1 then
		timer.start(welanim_duration)
	end

	if timer.time(welanim_duration) >= 26000 then
		welanim = 0
		timer.stop(timered)
	end

	if timer.time(timered) >= delay_time then
		welanim = welanim + step
		if welanim >= 255 then
			welanim = 255
			step = -10
			timer.reset(timered)
		elseif welanim <= 1 then
			welanim = 1
			step = 10
			timer.reset(timered)
		end
	end

	if buttons.pressed(buttons.up) and selectedButton > 1 then
		selectedButton = selectedButton - 1
	sound.playEasy("assets/sounds/select.wav", sound.WAV_1, false, false, uiLevel * 10)
	end
	if buttons.pressed(buttons.down) and selectedButton < #buttonsList then
		selectedButton = selectedButton + 1
	sound.playEasy("assets/sounds/select.wav", sound.WAV_1, false, false, uiLevel * 10)
	end

	if buttons.pressed(buttons.triangle) then
		LUA.quit()
	end

	arrowStep = arrowStep + 0.2
	arrowX = 35 + cos(arrowStep) * 3
	if arrowStep >= 360 then
		arrowStep = 0
	end

	if buttons.pressed(buttons.cross) then
		if selectedButton == 1 then
			fade = 0
			while fade < 255 do
				screen.clear()
				drawAll()
				screen.filledRect(0, 0, 480, 272, c_black, 0, fade)
				screen.flip()
				fade = fade + 8
			end
			fade_enabled = 0
			sound.playEasy("assets/sounds/click.wav", sound.WAV_1, false, false, uiLevel * 10)
			PMP.stop(videoFrame)
			local epmenu = dofile("assets/ui/epmenu/epmenu.lua")
			if epmenu == 1 then
				break
			end
		elseif selectedButton == 3 then
			while fade < 255 do
				screen.clear()
				drawAll()
				screen.filledRect(0, 0, 480, 272, c_black, 0, fade)
				screen.flip()
				fade = fade + 8
			end
			PMP.stop(videoFrame)
			fade_enabled = 0
			sound.playEasy("assets/sounds/click.wav", sound.WAV_1, false, false, uiLevel * 10)
			ui_enabled = false
			screen.flip()
			menuTransition(11)
			ui_enabled = true
			dofile("assets/misc/extras.lua")
		elseif selectedButton == 4 then
			while fade < 255 do
				screen.clear()
				drawAll()
				screen.filledRect(0, 0, 480, 272, c_black, 0, fade)
				screen.flip()
				fade = fade + 8
			end
			PMP.stop(videoFrame)
			fade_enabled = 0
			sound.playEasy("assets/sounds/click.wav", sound.WAV_1, false, false, uiLevel * 10)
			ui_enabled = false
			screen.flip()
			menuTransition(11)
			ui_enabled = true
			dofile("assets/misc/changelogs.lua")
		elseif selectedButton == 5 then
			fade_enabled = 0
			sound.playEasy("assets/sounds/click.wav", sound.WAV_1, false, false, uiLevel * 10)
			ui_enabled = false
			screen.flip()
			menuTransition(11)
			ui_enabled = true
			dofile("assets/misc/settings.lua")
		end
	end

	if ui_enabled then
		drawButtons()
		Image.draw(spritesheet, arrowX, 85, 14, 22, nil, 444, 0, 7, 11)
		Image.draw(spritesheet, arrowX, 130, 14, 22, nil, 444, 0, 7, 11)

		screen.filledRect(266, 199, 157, 1, Color.new(255, 255, 255), 0, welanim - 55)
		screen.filledRect(266, 239, 157, 1, Color.new(255, 255, 255), 0, welanim - 55)
		screen.filledRect(266, 199, 1, 41, Color.new(255, 255, 255), 0, welanim - 55)
		screen.filledRect(422, 199, 1, 41, Color.new(255, 255, 255), 0, welanim - 55)

		screen.filledRect(267, 200, 155, 39, Color.new(104, 171, 151), 0, welanim - 155)
		Image.draw(spritesheet, 45, 35, 140, 45, nil, 0, 48, 210, 61, nil, nil, nil, true)

		intraFont.printShadowed(
			280,
			205,
			ui.welcome,
			Color.new(255, 255, 255, welanim),
			Color.new(0, 0, 0, welanim),
			font,
			90,
			1,
			0.209,
			0
		)
		intraFont.printShadowed(
			305,
			223,
			ui.welcome_sub,
			Color.new(255, 255, 255, welanim),
			Color.new(0, 0, 0, welanim),
			font,
			90,
			1,
			0.17,
			0
		)
		intraFont.printShadowed(61, 236, ui.select, Color.new(255, 255, 255), Color.new(0, 0, 0), font, 90, 1, 0.27, 0)
		Image.draw(spritesheet, 45, 233, 13, 13, nil, 399, 0, 15, 15)
		debugoverlay.draw(debugoverlay.loadSettings())
	end

	if fade_enabled == 1 and fade > 0 then
		screen.filledRect(0, 0, 480, 272, c_black, 0, fade)
	end

	screen.flip()
end
