-- saves.lua — game-wide save/load stubs.
-- Real logic lives in assets/misc/savefiles.lua (loaded lazily on first use).

currentSaveSlot = currentSaveSlot or 1
currentEpisode = currentEpisode or 1
skipEnabled = sav.get("settings", "skipR", false) or false

-- ==================== AUTOSAVE FREQUENCY ====================
-- Stored value: 0 = OFF, 1-10 = save every N choices.
autoSaveEnabled = true
choiceCounter = 0

-- ==================== SAVE ICON ====================
-- The little chest with the bouncing arrow that shows "the game is being
-- saved". Everything about it lives in this one table, so it can be changed
-- in a couple of lines:
--
--   x, y      — where the icon stands on the screen (480×272)
--   chestSize — how big the chest is drawn (in pixels on the screen)
--   arrowW, arrowH — the size of the arrow on the screen: its own, so it stays sharp
--   chest     — the cell {x, y, w, h} of the chest inside the spritesheet
--   arrow     — the cell {x, y, w, h} of the arrow inside the spritesheet
--   arrowDX   — the arrow is drawn this far to the right of the chest
--   arrowDY   — ... and this far above it (a negative number is up)
--   bob       — how much the arrow bounces up and down (pixels, rounded)
--   bobSpeed  — how fast the arrow bounces (radians per second; bigger = faster)
--   duration  — how long the animation lasts (seconds)
--
-- The speed, the bounce and the time are measured on a recording of the original
-- game (60 fps): the icon appears at once, stays 1.47 s and goes at once; the
-- arrow swings with a period of 1.03 s (6.1 rad/s) by about 1.7 px on a 720p
-- screen, that is about 1 px next to a chest of our size. The animation runs in
-- time, so it does not depend on the frame rate of the loop that draws it.
--
-- The two sizes are separate, so the arrow can be smaller than the chest
-- (or bigger) without touching anything else. The picture of the chest and
-- the picture of the arrow are scaled from their cell of the spritesheet
-- (48×48), so any size keeps the pixels of the picture sharp.
--
-- The arrow sits right above the chest and points down at it.
--
-- The icon is drawn ON TOP of whatever is on the screen, so the player sees
-- the game being saved even in the middle of a video. Every loop that
-- redraws the whole screen (the video overlay, the zone loop, the pause
-- menu, the save menu) calls drawSaveOverlay() right before screen.flip().
-- The engine double-buffers, so a partially redrawn screen would flicker.
SAVE_ICON = {
	x = 444,
	y = 132,
	-- the size of the two pictures on the screen (in pixels)
	chestSize = 24,
	arrowW = 13,
	arrowH = 15,
	-- the cells of the spritesheet
	chest = { 426, 26, 24, 24 },
	arrow = { 452, 26, 13, 15 },
	-- the position of the arrow relative to the chest
	arrowDX = 5,
	arrowDY = -15,
	-- the animation (measured on the original game)
	bob = 1,
	bobSpeed = 6.1,
	duration = 1.47,
}

-- Moves the save icon (the same as changing SAVE_ICON.x and SAVE_ICON.y).
function setSaveIcon(x, y)
	SAVE_ICON.x = x
	SAVE_ICON.y = y
end

-- The animation runs by a timer (milliseconds), not by frames: `t` is the
-- seconds since it started.
local saveAnim = { visible = false, clock = nil, t = 0 }

local function stopSaveAnim()
	saveAnim.visible = false
	saveAnim.t = 0
	if saveAnim.clock then
		timer.remove(saveAnim.clock)
		saveAnim.clock = nil
	end
end

function triggerSaveAnim()
	stopSaveAnim()
	saveAnim.clock = timer.create()
	timer.start(saveAnim.clock)
	saveAnim.visible = true
end

-- A save at a choice is written while the choice stands, but its icon is shown
-- as in the original game: after the answer, over the next video. AutoSave
-- with `deferAnim` only marks it, and PMP.playExt starts it with the video.
-- A local, not a global: every global flag goes into the save file.
local saveAnimPending = false

-- Non-blocking: just triggers the animation.
function PlaySaveAnim()
	saveAnimPending = false
	triggerSaveAnim()
end

function StartPendingSaveAnim()
	if saveAnimPending then PlaySaveAnim() end
end

function SaveAnimPending()
	return saveAnimPending
end

function updateSaveAnim()
	if not saveAnim.visible then return end
	saveAnim.t = timer.time(saveAnim.clock) / 1000
	if saveAnim.t >= (SAVE_ICON.duration or 1.47) then
		stopSaveAnim()
	end
end

function drawSaveAnim()
	if not saveAnim.visible then return end
	local s = SAVE_ICON
	local cs = s.chestSize or s.size or 32

	-- The chest: the picture of its cell, scaled to the wanted size.
	Image.draw(spritesheet, s.x, s.y, cs, cs, nil,
		s.chest[1], s.chest[2], s.chest[3], s.chest[4])

	-- The arrow: it bounces over the chest and points down at it.
	local bobY = math.floor(math.cos(saveAnim.t * (s.bobSpeed or 6.1)) * (s.bob or 0) + 0.5)
	Image.draw(spritesheet, s.x + s.arrowDX, s.y + s.arrowDY + bobY,
		s.arrowW, s.arrowH, nil,
		s.arrow[1], s.arrow[2], s.arrow[3], s.arrow[4])
end

-- Draws the save icon over the screen. Call it in every loop that redraws
-- the whole screen, right before the flip.
function drawSaveOverlay()
	updateSaveAnim()
	drawSaveAnim()
end

-- True while the save icon is on the screen.
function SaveAnimActive()
	updateSaveAnim()
	return saveAnim.visible
end

-- The last frame of a video under a choice: the screen must be drawn again for
-- the save icon, so the picture is kept until the next video starts (or the scene
-- ends, in script.lua). It is the frame the engine kept (PMP.takeLastFrame, 16-bit,
-- 277 KB), which has no subtitles on it. Image.fromScreen is only for a screen
-- without a video before it: PPSSPP with a hardware renderer does not write the
-- screen back to the VRAM, so there it gives a frame from long ago.
function ChoiceBackdropTake()
	if CHOICE_BACKDROP then return end
	local last = PMP.takeLastFrame()
	if last then
		CHOICE_BACKDROP = last
		return
	end
	local ok, img = pcall(Image.fromScreen)
	if ok then CHOICE_BACKDROP = img end
end

function ChoiceBackdropDraw()
	if CHOICE_BACKDROP then
		screen.clear()
		Image.draw(CHOICE_BACKDROP, 0, 0)
	end
end

function ChoiceBackdropFree()
	if CHOICE_BACKDROP then
		pcall(Image.unload, CHOICE_BACKDROP)
		CHOICE_BACKDROP = nil
	end
	PMP.freeLastFrame()
end

-- ================= SAVE STUBS (lazy-load assets/misc/savefiles.lua) =================
-- Autosave at choice checkpoints: throttled by the autosave_freq setting
-- (0 = off, 1 = every choice, N = every N choices). Writes the current slot
-- file so the save menu always reflects progress, and marks this episode
-- "continue" so the episode menu shows it. Unlike SaveGame it never clears
-- later episodes' status markers (replaying an older episode must not wipe a
-- marker for an episode already played). Called from each episode's choice node.
function AutoSave(episodeNumber, deferAnim)
	-- An icon left over from a choice that was never answered (the player
	-- quit from the pause menu) is not shown later.
	saveAnimPending = false
	local freq = sav.get("settings", "autosave_freq", 5) or 5
	if freq == 0 then return end
	choiceCounter = choiceCounter + 1
	if choiceCounter < freq then return end
	choiceCounter = 0
	local ep = tonumber(episodeNumber) or currentEpisode or 1
	currentEpisode = ep
	currentSaveSlot = currentSaveSlot or 1
	require("assets/misc/savefiles")
	-- An autosave must never stop the game: when the stick cannot write now,
	-- the next checkpoint simply tries again.
	local ok, saved = pcall(SaveToFile, currentSaveSlot)
	if not ok or saved == false then
		choiceCounter = freq
		if debugoverlay and debugoverlay.log then
			debugoverlay.log("autosave failed: " .. tostring(saved))
		end
		return
	end
	WriteSlotThumb(currentSaveSlot)
	if deferAnim then
		saveAnimPending = true
	else
		PlaySaveAnim()
	end
	wr(ep .. "_status", "continue")
	_G["status_" .. ep] = "continue"
end

function LoadEpisodeVars(episodeNumber)
	require("assets/misc/savefiles")
	local sf = GetSaveFile(currentSaveSlot)
	if sf and sf.vars then
		RestoreSaveVars(sf.vars)
	end
	-- The answers of the setup of the episode are restored as well, so the
	-- story of the episode is the one the player has chosen.
	if sf and sf.story then
		for key, val in pairs(sf.story) do
			_G[key] = val
		end
	end
end

-- Returns true if the current save slot has a save file.
function HasSaveGame()
	require("assets/misc/savefiles")
	return GetSaveFile(currentSaveSlot or 1) ~= nil
end

-- Plays the save animation, restores saved variables, and returns the path to
-- the episode's main file. If no save exists returns nil.
function LoadEpisode(episodeNumber)
	require("assets/misc/savefiles")
	local sf = GetSaveFile(currentSaveSlot)
	if not sf then return nil end
	LoadEpisodeVars(episodeNumber)
	choiceCounter = 0
	return "assets/video/episode" .. episodeNumber .. "/episode" .. episodeNumber .. ".lua"
end

-- Continues the episode if the current slot has a save of it: restores the
-- variables of the save and returns the scene of the episode (nil when there
-- is nothing to continue).
-- This is what the start.lua of the episodes use, so the game never asks for
-- the system save of the PSP — the project has its own saves.
function ContinueEpisode(episodeNumber)
	require("assets/misc/savefiles")
	local slot = currentSaveSlot or 1
	local sf = GetSaveFile(slot)
	if not sf or sf.episode ~= episodeNumber then return nil end
	LoadEpisodeVars(episodeNumber)
	choiceCounter = 0
	-- A save that has not reached a checkpoint of the episode (a new slot, or
	-- one that has just finished the episode before) starts it from the
	-- beginning, with its opening (the tagline of episode 1, the setup).
	if not (sf.vars and sf.vars["ep" .. episodeNumber .. "_node"] ~= nil) then
		return nil
	end
	return sf.scene or ("assets/video/episode" .. episodeNumber .. "/episode" .. episodeNumber .. ".lua")
end

-- Clears the save of the current slot for the episode (a new game/restart).
function ClearEpisodeSave(episodeNumber)
	require("assets/misc/savefiles")
	DeleteSaveFile(currentSaveSlot)
end
