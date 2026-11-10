-- The sounds of the game.
--
-- The engine raises a Lua error when a sound cannot be loaded (a missing
-- file, but also NOT ENOUGH MEMORY: on the 32 MB of the PSP this happens
-- when the video of the menu is playing and a lot of pictures are loaded).
-- Such an error kills the whole script, so every call is wrapped: a sound
-- that cannot be loaded is simply skipped, the game keeps running.
--
-- The sounds of the interface (select.wav, click.wav) are loaded only once
-- and are kept in the channel, so the memory of the PSP is not wasted on
-- loading the same file again and again.
local soundLoaded = {}

function sound.playEasy(path, channel, loop, loadToRAM, volume)
	if type(path) ~= "string" or path == "" then
		return
	end

	if type(loadToRAM) ~= "boolean" then
		loadToRAM = false
	end

	if type(loop) ~= "boolean" then
		loop = false
	end

	if volume == nil then
		volume = 100
	end

	-- The sound is loaded only when the channel does not already hold it:
	-- the engine keeps the file in the channel, and loading it again would
	-- eat the memory of the PSP. A channel holds one sound, so the cache is
	-- per channel.
	if soundLoaded[channel] ~= path then
		local ok = pcall(sound.cloud, path, channel, loadToRAM)
		if not ok then
			-- The sound cannot be loaded (no memory, no file): the game goes
			-- on, only without the sound.
			if debugoverlay and debugoverlay.log then
				debugoverlay.log("cannot load sound: " .. path)
			end
			soundLoaded[channel] = nil
			return
		end
		soundLoaded[channel] = path
	end

	-- The sound is played from the beginning every time.
	pcall(sound.play, channel, loop)
	pcall(sound.volume, channel, volume, volume)
end

-- Stops a channel and frees its sound (the buffers of a streamed AT3 stay in
-- the channel until then). The next playEasy() on it loads its file again.
function sound.unloadEasy(channel)
	pcall(sound.stop, channel)
	pcall(sound.unload, channel)
	soundLoaded[channel] = nil
end

function sound.volumeEasy(channel, volume)
	pcall(sound.volume, channel, volume, volume)
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

function PMP.playExt(path, stopButton, getPointer, subsPath, fontPath, fontSize, hexColor, hexBg, subsControl, loop, overlayFn)
	-- The frame kept under the last choice (saves.lua) belongs to the video
	-- before this one: it is freed, so the memory goes to this video.
	if ChoiceBackdropFree then ChoiceBackdropFree() end
	-- The subtitles of the language, or of its base language when it does not
	-- have this clip (a language pack does not have to be complete).
	if ResolveSubs then subsPath = ResolveSubs(subsPath) end
	if type(getPointer) ~= "boolean" then
		getPointer = false
	end
	if type(loop) ~= "boolean" then
		loop = false
	end

	local usedFont
	if type(fontPath) == "userdata" or type(fontPath) == "table" then
		usedFont = fontPath
	elseif type(fontPath) == "string" then
		usedFont = intraFont.load(fontPath)
	else
		usedFont = font
	end

	local fontSizeNow = (type(fontSize) == "number" and fontSize > 0) and fontSize or 1.0
	local nativeFontPx = 14  -- pexico загружен на 14px
	local subsEnabledNow = subsControl ~= false

	if subs_font then
		usedFont = subs_font
	end

	-- The video is started safely: a missing file or a video that does not
	-- fit into the memory of the PSP must not kill the game. In that case
	-- the function returns nil and the caller shows something else.
	local okStart, res = pcall(PMP.play, path, getPointer, loop, subsPath, stopButton)
	if not okStart or res == nil then
		if debugoverlay and debugoverlay.log then
			debugoverlay.log("cannot play video: " .. tostring(path))
		end
		pointer = nil
		return nil
	end
	pointer = res

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
	
	local lastSubs = ""
	local lastSubsTime = 0
	local currentDisplayLength = 0
	local typingSpeed = 0.01
	
	local function autoWrapText(text, maxPx)
		if not text or text == "" then
			return {}
		end

		local lines = {}
		local words = {}

		for word in text:gmatch("%S+") do
			table.insert(words, word)
		end

		if #words == 0 then
			return { text }
		end

		local currentLine = words[1]

		for i = 2, #words do
			local word = words[i]
			local candidate = currentLine .. " " .. word
			if intraFont.textW(usedFont, candidate, fontSizeNow) <= maxPx then
				currentLine = candidate
			else
				table.insert(lines, currentLine)
				currentLine = word
			end
		end

		table.insert(lines, currentLine)

		return lines
	end

	while PMP.getFrame(pointer) do
		screen.clear()
		buttons.read()
		Image.draw(pointer, 0, 0)
		
		local currentTime = os.clock()

		if subsEnabledNow then
			local subs = PMP.getSubs()
			if subs and subs ~= "" then
				if subs:find("\\n") then
					subs = subs:gsub("\\n", "\n")
				end
				subs = subs:gsub("\r\n", "\n")
				subs = subs:gsub("\r", "\n")
				
				if subs ~= lastSubs then
					lastSubs = subs
					currentDisplayLength = 0
					lastSubsTime = currentTime
				end
				
				if not paused then
					if currentDisplayLength < #subs then
						local elapsed = currentTime - lastSubsTime
						local targetLength = math.floor(elapsed / typingSpeed)
						if targetLength > #subs then
							targetLength = #subs
						end
						if targetLength > currentDisplayLength then
							currentDisplayLength = targetLength
						end
					end
				end

				while currentDisplayLength > 0 and currentDisplayLength < #subs do
					local b = subs:byte(currentDisplayLength + 1)
					if b and b >= 128 and b < 192 then
						currentDisplayLength = currentDisplayLength - 1
					else
						break
					end
				end

				local displaySubs = subs:sub(1, currentDisplayLength)

				local allLines = {}
				local start = 1

				while true do
					local found = displaySubs:find("\n", start)
					if not found then
						if start <= #displaySubs then
							table.insert(allLines, displaySubs:sub(start))
						end
						break
					end
					table.insert(allLines, displaySubs:sub(start, found - 1))
					start = found + 1
				end

				local finalLines = {}
				local maxPx = 440

				for _, originalLine in ipairs(allLines) do
					if originalLine ~= "" then
						local wrappedLines = autoWrapText(originalLine, maxPx)

						for _, wrappedLine in ipairs(wrappedLines) do
							table.insert(finalLines, wrappedLine)
						end

						if #wrappedLines > 0 then
							table.insert(finalLines, "")
						end
					else
						table.insert(finalLines, "")
					end
				end

				if #finalLines > 0 and finalLines[#finalLines] == "" then
					table.remove(finalLines, #finalLines)
				end

				local lineHeight = math.floor(nativeFontPx * fontSizeNow + 4)
				local totalHeight = #finalLines * lineHeight
				
				local maxWidth = 0
				for _, line in ipairs(finalLines) do
					if line ~= "" then
						local textWidth = intraFont.textW(usedFont, line, fontSizeNow)
						if textWidth > maxWidth then
							maxWidth = textWidth
						end
					end
				end
				
				local bgPaddingX = 0
				local bgPaddingY = 0
				
				local totalTextHeight = #finalLines * lineHeight
				local startY = 272 - totalTextHeight - 30
				
				local bgX = 240 - (maxWidth / 2) - bgPaddingX
				local bgWidth = maxWidth + (bgPaddingX * 2)
				local bgY = startY - bgPaddingY
				local bgHeight = totalTextHeight + (bgPaddingY * 2)
				
				screen.filledRect(bgX, bgY, bgWidth, bgHeight, bgColor)
				
				for i, line in ipairs(finalLines) do
					if line ~= "" then
						local y = startY + (i - 0.8) * lineHeight
						local x = 240 - intraFont.textW(usedFont, line, fontSizeNow) / 2
						
						if colorEnd then
							intraFont.printGradient(x, y, line, colorStart, colorEnd, usedFont, fontSizeNow)
						else
							intraFont.print(x, y, line, colorStart, usedFont, fontSizeNow)
						end
					end
				end
			else
				lastSubs = ""
				currentDisplayLength = 0
			end
		end

		if stopButton and buttons.pressed(stopButton) then
			PMP.stop(pointer)
			break
		elseif buttons.pressed(buttons.start) then
			if not paused then
				PMP.pause()
				PAUSE_IN_VIDEO = true
				local code = dofile("assets/misc/pause.lua")
				PAUSE_IN_VIDEO = false
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
			intraFont.print(
				235 - intraFont.textW(font, ui.paused, 2) / 2 + 8,
				105 + 14,
				ui.paused,
				Color.new(255, 255, 255),
				font,
				2
			)
		end

		-- The overlay may end the video (a choice answered over it): then
		-- the video stops on this frame and the function returns 2.
		local act = nil
		if type(overlayFn) == "function" then
			act = overlayFn()
		end

		screen.flip()
		if act == "stop" then
			PMP.stop(pointer)
			return 2
		end
	end
end

-- The credits of an episode: the video comes out of black and goes back to
-- black at its end, or when START skips it (the picture and the sound fade
-- together). The screen is black when it returns.
local CREDITS_IN, CREDITS_OUT = 0.8, 1.0   -- seconds
function PlayCredits(path)
	local Fade = require("assets/misc/fade")
	if ChoiceBackdropFree then ChoiceBackdropFree() end
	local vol = pmpvolume or 10
	PMP.setVolume(vol)
	local ok, frame = pcall(PMP.play, path, true, false, nil, nil)
	if not ok or not frame then
		screen.clear(); screen.flip()
		return
	end
	local fps = 29.97
	local skip = nil
	local smooth = function(v) if v <= 0 then return 0 elseif v >= 1 then return 1 end return v * v * (3 - 2 * v) end
	while PMP.getFrame(frame) do
		buttons.read()
		local pos, n = PMP.position(), PMP.frameCount()
		if not skip and buttons.pressed(buttons.start) then skip = Fade.start(CREDITS_OUT, true) end
		local a = 0
		if pos then a = 1 - smooth(pos / (CREDITS_IN * fps)) end
		if pos and n and n > 0 then a = math.max(a, smooth(1 - (n - 1 - pos) / (CREDITS_OUT * fps))) end
		if skip then a = math.max(a, skip:alpha() / 255) end
		screen.clear()
		Image.draw(frame, 0, 0)
		Fade.cover(math.floor(255 * a + 0.5))
		screen.flip()
		pcall(PMP.setVolume, math.floor(vol * (1 - a) + 0.5))
		if skip and skip:done() then break end
	end
	pcall(PMP.stop, frame)
	if PMP.freeLastFrame then PMP.freeLastFrame() end
	PMP.setVolume(vol)
	screen.clear(); screen.flip()
end
