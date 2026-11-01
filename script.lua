-- initialize variables
local fade = 255
local voidfade = 0
local textfade = 0
local rectfade = 0

spritesheet = Image.load("assets/ui/menu-spritesheet.png")
require("sav")
require("easy")
dofile("assets/misc/lang.lua")
getlang()
-- Fonts depend on the chosen language:
--   en/es/pt (latin) : minecraft (with cyrillic) UI + pexico subtitles
--   ru/uk   (cyrilic): unifont for both
applyFonts(lang)
if lang == "en" then require("ui_strings_en")
elseif lang == "es" then require("ui_strings_es")
elseif lang == "uk" then require("ui_strings_uk")
elseif lang == "pt" then require("ui_strings_pt")
else require("ui_strings") end

-- Глобальные цвета (палитра)
C_WHITE = Color.new(255, 255, 255)
C_WHITE_150 = Color.new(255, 255, 255, 150)
C_BLACK = Color.new(0, 0, 0)
C_YELLOW = Color.new(255, 255, 153)
C_GREEN = Color.new(74, 125, 110)
-- цвета с изменяемой прозрачностью / анимацией -> функции
function whiteA(a) return Color.new(255, 255, 255, a or 255) end
function blackA(a) return Color.new(0, 0, 0, a or 255) end
function welColor(ws, a) return Color.new(255, 255, ws, a or 255) end

-- ===== Настройки (единое JSON) =====
-- звуковые уровни (0..10) и субтитры
function loadLevels()
	return sav.get("settings", "menumusic", 10),
		sav.get("settings", "pmpvideos", 10),
		sav.get("settings", "uiLevel", 10)
end
function saveLevels(levels)
	sav.set("settings", "menumusic", levels[1])
	sav.set("settings", "pmpvideos", levels[2])
	sav.set("settings", "uiLevel", levels[3])
end
function saveSubs()
	sav.set("settings", "subs", subs == true)
end
menumusic, pmpvideos, uiLevel = loadLevels()
subs = sav.get("settings", "subs", true)
subssize = 1  -- фиксированный размер субтитров

-- load volumes
pmpvolume = (tonumber(pmpvideos) or 10) * 10

local byentitybtw = Image.load("assets/ui/byentitybtw.png")
local headphones = Image.load("assets/ui/headphones.png")

-- byentitybtw fade in/out
fade = 255
while fade > 0 do
	fade = fade - 8
	screen.clear()
	Image.draw(byentitybtw, 0, 0, 480, 272, nil, nil, nil, nil, nil, nil, 255 - fade)
	screen.flip()
	LUA.sleep(16)
end
LUA.sleep(2000)
fade = 0
while fade < 255 do
	fade = fade + 8
	screen.clear()
	Image.draw(byentitybtw, 0, 0, 480, 272, nil, nil, nil, nil, nil, nil, 255 - fade)
	screen.flip()
	LUA.sleep(16)
end

-- headphones fade in/out
fade = 255
while fade > 0 do
	fade = fade - 8
	screen.clear()
	Image.draw(headphones, 0, 0, 480, 272, nil, nil, nil, nil, nil, nil, 255 - fade)
	screen.flip()
	LUA.sleep(16)
end
LUA.sleep(1500)
fade = 0
while fade < 255 do
	fade = fade + 8
	screen.clear()
	Image.draw(headphones, 0, 0, 480, 272, nil, nil, nil, nil, nil, nil, 255 - fade)
	screen.flip()
	LUA.sleep(16)
end

Image.unload(byentitybtw)
Image.unload(headphones)

PMP.setVolume(pmpvolume)
-- The video of the title screen. It loops and can be interrupted with the
-- START button (the loading screen of the game is shown then).
local pointer = PMP.play("assets/ui/mcsm_title.pmp", true, true, nil, buttons.start)

-- The loading animation: a ring of 8 squares around an empty middle. Nothing is
-- stored in the spritesheet: the same alphas run around the ring.
local RING = { {0,0}, {1,0}, {2,0}, {2,1}, {2,2}, {1,2}, {0,2}, {0,1} }
local RING_ALPHA = { 255, 230, 204, 179, 153, 128, 102, 77 }
local RING_X, RING_Y, RING_STEP, RING_SIZE = 226, 176, 10, 9
local ringColor = Color.new(255, 255, 255)

local function drawLoadingRing(head, alpha)
	for i = 1, 8 do
		local cell = RING[i]
		screen.filledRect(RING_X + cell[1] * RING_STEP, RING_Y + cell[2] * RING_STEP,
			RING_SIZE, RING_SIZE, ringColor, 0,
			math.floor(RING_ALPHA[(i - 1 - head) % 8 + 1] * alpha / 255))
	end
end

local startPressed = false
local loadingStartTime = 0
local frameIndex = 0
local frameTimer = 0
local currentStep = 1
local stepTimer = 0

local videoStartTime = os.clock()
local loadingSequence = {
	{ text = ui.loading_1, duration = 1.5 },
	{ text = ui.loading_2, duration = 0.7 },
	{ text = ui.loading_3, duration = 1.4 },
	{ text = ui.loading_4, duration = 0.4 },
	{ text = ui.loading_5, duration = 2.0 },
}

while PMP.getFrame(pointer) do
	screen.clear()
	Image.draw(pointer, 0, 0)
	buttons.read()

	local currentVideoTime = os.clock() - videoStartTime
	if not startPressed and currentVideoTime >= 12 and buttons.pressed(buttons.start) then
		-- reset fades
		voidfade = 0
		textfade = 0
		rectfade = 0
		frameIndex = 0
		currentStep = 1

		startPressed = true
		loadingStartTime = os.clock()
		frameTimer = os.clock()
		stepTimer = os.clock()
	end

	if startPressed then
		if voidfade < 255 then
			voidfade = math.min(voidfade + 5, 255)
		end
		Image.draw(spritesheet, 177, 189, 124, 14, nil, 300, 26, 124, 14, nil, voidfade)

		local timeSinceStart = os.clock() - loadingStartTime

		if timeSinceStart >= 1 and timeSinceStart < 8 then
			if os.clock() - frameTimer >= 0.2 then
				frameIndex = (frameIndex + 1) % 8
				frameTimer = os.clock()
			end

			if textfade < 255 then
				textfade = math.min(textfade + 5, 255)
			end

			intraFont.print(
				235 - intraFont.textW(font, ui.loading, 1) / 2 + 8,
				195 + 14,
				ui.loading,
				Color.new(255, 255, 255, textfade),
				font,
				1
			)

			drawLoadingRing(frameIndex + 1, textfade)

			if currentStep <= #loadingSequence then
				local step = loadingSequence[currentStep]
				intraFont.print(
					235 - intraFont.textW(font, step.text, 1) / 2 + 8,
					222,
					step.text,
					Color.new(255, 255, 255, textfade),
					font,
					1
				)

				if os.clock() - stepTimer >= step.duration then
					currentStep = currentStep + 1
					stepTimer = os.clock()
				end
			end
		end

		if timeSinceStart >= 6 and textfade > 0 then
			textfade = math.max(textfade - 8, 0)
		end

		if timeSinceStart >= 8 then
			rectfade = math.min(rectfade + 3, 255)
			screen.filledRect(0, 0, 480, 272, Color.new(0, 0, 0), nil, rectfade)
		end

		if timeSinceStart >= 10 then
			PMP.stop(pointer)
			break
		end
	end

	screen.flip()
end

-- The loading video of the game. It can be interrupted with the START
-- button, so the player is never stuck on the loading screen.
PMP.play("assets/ui/loading.pmp", false, false, nil, buttons.start)

require("assets/misc/safe")
require("saves")
require("debugoverlay")
require("files")
sound.playEasy("assets/sounds/bg.at3", 5, true, false, menumusic * 10)

fade_enabled = 1
nextscene = "./mainmenu.lua"

-- The main loop of the game: the current scene is run, then the next one
-- is started.
--
-- The call is wrapped: an error inside a scene (a broken save file, a
-- missing file, a video that does not fit into the memory) must not kill
-- the whole game. The player is taken back to the main menu instead, and
-- the error is written into the log of the debug overlay.
local SCENE_ERRORS = 0
while true do
	System.PowerTick()

	local scene = nextscene
	if type(scene) ~= "string" or scene == "" then
		scene = "./mainmenu.lua"
		nextscene = scene
	end

	-- Every scene starts on a clean heap: the videos need big solid blocks, and
	-- the garbage of the last scene would stand in the middle of them.
	cleanupScreen()
	collectgarbage("collect")

	local ok, err = pcall(dofile, scene)
	if not ok then
		SCENE_ERRORS = SCENE_ERRORS + 1
		local msg = tostring(err)
		if debugoverlay and debugoverlay.log then
			debugoverlay.log("error in " .. scene .. ": " .. msg)
		end
		-- After three errors in a row the game goes to the main menu, so it
		-- never gets stuck in a broken scene.
		if SCENE_ERRORS >= 3 then
			SCENE_ERRORS = 0
			nextscene = "./mainmenu.lua"
		end
		-- The game always has a scene to run.
		if type(nextscene) ~= "string" or nextscene == "" then
			nextscene = "./mainmenu.lua"
		end
	end

	System.GC()
end
