
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

-- The loading screen of the game (black, the spinner in the corner) and the
-- fades of the menus (the times of the original game). They stay for the
-- whole game, so they are loaded before the intro and the title: what lives
-- on must not stand above the big blocks of those two (the music of the
-- title is 3 MB), or their memory comes back in pieces.
loadingScreen = dofile("assets/misc/loading.lua")
Fade = dofile("assets/misc/fade.lua")

-- The screens before the title: who made the port, then the headphones
-- (assets/misc/intro.lua).
dofile("assets/misc/intro.lua").play()
collectgarbage("collect")

PMP.setVolume(pmpvolume)
-- The title screen (assets/misc/title.lua) with its music. START shows the
-- loading screen of the game.
local title = dofile("assets/misc/title.lua")
title.load()
local TITLE_MUSIC = sound.AT3_2
sound.playEasy("assets/ui/title/music.at3", TITLE_MUSIC, true, false, pmpvolume)
local titleClock = timer.create()
timer.start(titleClock)

-- After START, as in the original (bootTitle.lua and its chores):
--   ui_boot_startHide   "Press START" goes in 0.25 s
--   ui_boot_updateShow  the busy icon and the lines of the update come in
--                       0.5 s; the lines follow each other, then
--   ui_boot_updateHide  go in 0.5 s
--   ui_boot_titleHide   the screen goes to black in 3.03 s, the music in 3.84 s
local AFTER = { show = 0.25, fade = 0.5, black = 3.034, music = 3.842 }
local BUSY = { x = 226, y = 176, size = 9, pitch = 10, step = 0.25 }
local loadingSequence = {
	{ text = ui.loading_1, duration = 1.5 },
	{ text = ui.loading_2, duration = 0.7 },
	{ text = ui.loading_3, duration = 1.4 },
	{ text = ui.loading_4, duration = 0.4 },
	{ text = ui.loading_5, duration = 2.0 },
}
local LINES = 0
for _, step in ipairs(loadingSequence) do LINES = LINES + step.duration end
AFTER.hide = AFTER.show + AFTER.fade + LINES
AFTER.blackAt = AFTER.hide + AFTER.fade

local function centred(text, y, alpha)
	if not text or alpha <= 0 then return end
	intraFont.print(math.floor(240 - intraFont.textW(font, text, 1) / 2), y, text,
		Color.new(255, 255, 255, math.floor(alpha)), font, 1)
end

-- The update after START at the time s (seconds since START). Returns true when
-- the screen is black and the music silent.
local function drawAfterStart(s)
	local function smooth(v)
		if v <= 0 then return 0 elseif v >= 1 then return 1 end
		return v * v * (3 - 2 * v)
	end
	local a = math.min(smooth((s - AFTER.show) / AFTER.fade), 1 - smooth((s - AFTER.hide) / AFTER.fade))
	if a > 0 then
		loadingScreen.drawSpinner(s - AFTER.show, a, BUSY)
		centred(ui.loading, 209, 255 * a)
		local at = s - AFTER.show - AFTER.fade
		local line = loadingSequence[1]
		for _, step in ipairs(loadingSequence) do
			line = step
			if at < step.duration then break end
			at = at - step.duration
		end
		centred(line.text, 222, 255 * a)
	end
	local b = smooth((s - AFTER.blackAt) / AFTER.black)
	if b > 0 then
		screen.filledRect(0, 0, 480, 272, Color.new(0, 0, 0), nil, math.floor(255 * b))
	end
	local m = 1 - smooth((s - AFTER.blackAt) / AFTER.music)
	pcall(sound.volumeEasy, TITLE_MUSIC, math.floor((pmpvolume or 100) * m))
	return s >= AFTER.blackAt + AFTER.music
end

local startPressed = false
local titleDone = false
local startClock = nil

while true do
	local now = timer.time(titleClock) / 1000
	local since = startClock and timer.time(startClock) / 1000 or nil
	screen.clear()
	title.draw(now, since)
	buttons.read()

	if not startPressed and now >= title.START_AT and buttons.pressed(buttons.start) then
		startPressed = true
		startClock = timer.create()
		timer.start(startClock)
	end

	if since and drawAfterStart(since) then
		titleDone = true
	end

	screen.flip()
	-- The pictures are freed after the frame that used them is drawn.
	if titleDone then
		pcall(sound.stop, TITLE_MUSIC)
		pcall(sound.unload, TITLE_MUSIC)
		title.unload()
		timer.remove(startClock)
		timer.remove(titleClock)
		break
	end
end

-- Nothing of the title is kept: its tables are freed before the menus load.
title, startClock, titleClock = nil, nil, nil
collectgarbage("collect")

loadingScreen.play(buttons.start)

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
