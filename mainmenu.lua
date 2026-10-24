local fade = 255
local welanim = 255
local step = -10
local delay_time = 4000
local c_black = Color.new(0, 0, 0)
local cos = math.cos
local stat = sound.state(5)
local arrowX = 39
local arrowStep = 0
local welsel = false

require("assets/misc/safe")

-- The background video of the menu. It is started safely: if the video does
-- not fit into the memory of the PSP, the menu simply shows the black
-- background instead of crashing.
safePlayMenuVideo("assets/ui/mcsm_mainmenu.pmp")

ui_enabled = true
debugoverlay.loadSettings()

local colorWhite = Color.new(255, 255, 255)

local timered = timer.create()
local welanim_duration = timer.create()
local welanimTick = 0   -- the frame counter for the running text of the block

local buttonsList = {
	{ k = "play" },
	{ k = "episodes" },
	{ k = "extras" },
	{ k = "settings" },
}

local selectedButton = 1

local buttonSprites = {
	selected = { srcx = 0, srcy = 164, srcw = 184, srch = 25 },
	static = { srcx = 184, srcy = 165, srcw = 184, srch = 25 },
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
    local startX, startY, gap = 45, 25, 0.1
    local buttonScale = 1.5

    for i, button in ipairs(buttonsList) do
        local sprite = (i == selectedButton) and buttonSprites.selected or buttonSprites.static
        
        local scaledWidth = sprite.srcw - 20
        local scaledHeight = sprite.srch * buttonScale - 5
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

        local textScale = 1
        local btntxt = ui[button.k]
        local textColor = (i == selectedButton) and Color.new(255, 255, 153) or colorWhite
        local textWidth = intraFont.textW(font, btntxt, textScale)
        local textHeight = intraFont.textH(font) * textScale

                drawShadowedText(math.floor(startX + (scaledWidth - textWidth) / 2), math.floor(y + (scaledHeight - textHeight) / 2), btntxt, textColor, Color.new(0, 0, 0), font, textScale)

    end
end

-- The block of the welcome: the plate, its border and the two lines of the
-- text. The text is broken into lines by words and aligned to the LEFT
-- edge of the block, so it fits into the block with any language and with
-- any font: a line that is too long scrolls inside the block instead of
-- running over its edge.
local WEL = { x = 267, y = 150, w = 180, h = 95 }
local WEL_TEXT_X = WEL.x + 6
local WEL_TEXT_W = WEL.w - 12
local WEL_TOP = WEL.y + 5

local function drawWelcome(welcolor, alpha)
	screen.filledRect(WEL.x, WEL.y - 1, WEL.w, 1, Color.new(255, 255, welcolor), 0, alpha - 55)
	screen.filledRect(WEL.x, WEL.y + WEL.h - 1, WEL.w, 1, Color.new(255, 255, welcolor), 0, alpha - 55)
	screen.filledRect(WEL.x - 1, WEL.y, 1, WEL.h, Color.new(255, 255, welcolor), 0, alpha - 55)
	screen.filledRect(WEL.x + WEL.w - 1, WEL.y, 1, WEL.h, Color.new(255, 255, welcolor), 0, alpha - 55)

	screen.filledRect(WEL.x, WEL.y, WEL.w, WEL.h, Color.new(74, 125, 110), 0, alpha - 100)

	-- The two texts of the block. The first one is on the top, the second
	-- one is on the bottom of the block, and both are aligned to the left
	-- edge of the block.
	local textColor = Color.new(255, 255, welcolor, alpha)
	local shadowColor = Color.new(0, 0, 0, alpha)
	local lineH = intraFont.textH(font) + 4

	local function drawLeft(y, text)
		local lines = wrapText(text, font, 1, WEL_TEXT_W)
		local blockH = #lines * lineH
		local ty = y - math.floor(blockH / 2)
		for i, line in ipairs(lines) do
			drawBoxedText(WEL_TEXT_X, ty + (i - 1) * lineH, WEL_TEXT_W, line,
				textColor, shadowColor, font, 1, welanimTick, false)
		end
	end

	drawLeft(WEL.y + 24, ui.welcome)
	drawLeft(WEL.y + WEL.h - 22, ui.welcome_sub)
end

local function drawAll()
		drawButtons()
		Image.draw(spritesheet, arrowX, 27, 28, 46, colorWhite, 444, 0, 11, 19)
		Image.draw(spritesheet, arrowX, 92, 28, 46, colorWhite, 444, 0, 11, 19)

		local welcolor = welsel and 183 or 255

		drawWelcome(welcolor, welanim)

		-- Bottom hint: cross = select (aligned with text)
		Image.draw(spritesheet, 45, 235, 20, 20, nil, 20, 111, 20, 20)
				drawShadowedText(69, 237, ui.select, colorWhite, Color.new(0, 0, 0), font, 1)
		debugoverlay.draw()
end

function stop_sound(channel)
	if sound.state(channel).state ~= "stopped" then
		sound.stop(channel)
	end
end

-- The music of the menu loops: the flag loop of sound.playEasy is true and
-- the volume of the menu is applied, so the music never stops in the
-- background and never restarts from the beginning.
if stat.state == "stopped" then
	sound.playEasy("assets/sounds/bg.at3", 5, true, false, (menumusic or 10) * 10)
else
	sound.volumeEasy(5, (menumusic or 10) * 10)
end

while true do
	welanimTick = welanimTick + 1
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

	if buttons.pressed(buttons.right) and not welsel and selectedButton == #buttonsList and welanim > 50  then
		welsel = true
		sound.playEasy("assets/sounds/select.wav", sound.WAV_1, false, false, uiLevel * 10)
	end
	
	if buttons.pressed(buttons.left) and welsel then
		welsel = false
		sound.playEasy("assets/sounds/select.wav", sound.WAV_1, false, false, uiLevel * 10)
	end

	if not welsel then
		if buttons.pressed(buttons.up) and selectedButton > 1 then
			selectedButton = selectedButton - 1
			sound.playEasy("assets/sounds/select.wav", sound.WAV_1, false, false, uiLevel * 10)
		end
		if buttons.pressed(buttons.down) and selectedButton < #buttonsList and not welsel then
			selectedButton = selectedButton + 1
			sound.playEasy("assets/sounds/select.wav", sound.WAV_1, false, false, uiLevel * 10)
		end
	end

	if buttons.pressed(buttons.triangle) then
		LUA.quit()
	end

	arrowStep = arrowStep + 0.2
	arrowX = 38 + cos(arrowStep) * 3
	if arrowStep >= 360 then
		arrowStep = 0
	end

local function doFadeOut()
	fade = 0
	while fade < 255 do
		screen.clear()
		drawAll()
		screen.filledRect(0, 0, 480, 272, c_black, 0, fade)
		screen.flip()
		fade = fade + 8
	end
	-- The video of the menu is stopped: the engine frees the texture of its
	-- frame, so the memory is not eaten by the menus that are opened again.
	stopMenuVideo()
	System.GC()
	LUA.sleep(200)
	fade_enabled = 0
	sound.playEasy("assets/sounds/click.wav", sound.WAV_1, false, false, uiLevel * 10)
	ui_enabled = false
	screen.flip()
	menuTransition(11)
	ui_enabled = true
end

	if buttons.pressed(buttons.cross) then
		if welsel then
			doFadeOut()
			dofile("assets/misc/extras.lua")
		else
			if selectedButton == 1 then
				doFadeOut()
				local epmenu = dofile("assets/ui/epmenu/epmenu.lua")
				if epmenu == 1 then
					break
				end
			elseif selectedButton == 2 then
				-- Episodes: open the popup list of episodes (official
				-- Menu_EpisodeSelect data). It overlays the still-running menu
				-- video, so no fade-out is needed. On confirm it hands the chosen
				-- episode to epmenu, exactly like the Play button does.
				sound.playEasy("assets/sounds/click.wav", sound.WAV_1, false, false, uiLevel * 10)
				local choice = dofile("assets/misc/episodes_popup.lua")
				if choice and choice.action == "start" then
					wr("lastep", tostring(choice.episode))
					doFadeOut()
					local epmenu = dofile("assets/ui/epmenu/epmenu.lua")
					if epmenu == 1 then
						break
					end
				end
			elseif selectedButton == 3 then
				doFadeOut()
				dofile("assets/misc/extras.lua")
			elseif selectedButton == 4 then
				fade_enabled = 0
				sound.playEasy("assets/sounds/click.wav", sound.WAV_1, false, false, uiLevel * 10)
				ui_enabled = false
				screen.flip()
				menuTransition(11)
				ui_enabled = true
				dofile("assets/misc/settings.lua")
			end
		end
	end

	if ui_enabled then
		drawAll()
	end

	if fade_enabled == 1 and fade > 0 then
		screen.filledRect(0, 0, 480, 272, c_black, 0, fade)
	end

	screen.flip()
end
