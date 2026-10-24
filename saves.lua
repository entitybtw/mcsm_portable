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
--   arrowSize — how big the arrow is drawn (in pixels on the screen)
--   chest     — the cell {x, y, w, h} of the chest inside the spritesheet
--   arrow     — the cell {x, y, w, h} of the arrow inside the spritesheet
--   arrowDX   — the arrow is drawn this far to the right of the chest
--   arrowDY   — ... and this far above it (a negative number is up)
--   bob       — how much the arrow bounces up and down
--   bobSpeed  — how fast the arrow bounces (bigger = faster)
--   frames    — how long the animation lasts (in frames)
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
	arrowSize = 24,
	-- the cells of the spritesheet
	chest = { 0, 220, 48, 48 },
	arrow = { 48, 220, 48, 48 },
	-- the position of the arrow relative to the chest
	arrowDX = 0,
	arrowDY = -16,
	-- the animation
	bob = 3,
	bobSpeed = 0.15,
	frames = 90,
}

-- Moves the save icon (the same as changing SAVE_ICON.x and SAVE_ICON.y).
function setSaveIcon(x, y)
	SAVE_ICON.x = x
	SAVE_ICON.y = y
end

local saveAnim = { visible = false, timer = 0, bobAngle = 0 }
local SAVE_ANIM_FRAMES = SAVE_ICON.frames or 90   -- ~1.5 s at ~60 fps

function triggerSaveAnim()
	saveAnim.visible = true
	saveAnim.timer = 0
	saveAnim.bobAngle = 0
end

-- Non-blocking: just triggers the animation.
function PlaySaveAnim()
	triggerSaveAnim()
end

function updateSaveAnim()
	if not saveAnim.visible then return end
	saveAnim.timer = saveAnim.timer + 1
	saveAnim.bobAngle = saveAnim.bobAngle + (SAVE_ICON.bobSpeed or 0.15)
	if saveAnim.timer >= SAVE_ANIM_FRAMES then
		saveAnim.visible = false
		saveAnim.timer = 0
		saveAnim.bobAngle = 0
	end
end

function drawSaveAnim()
	if not saveAnim.visible then return end
	local s = SAVE_ICON
	local cs = s.chestSize or s.size or 32
	local as = s.arrowSize or s.size or 32

	-- The chest: the picture of its cell, scaled to the wanted size.
	Image.draw(spritesheet, s.x, s.y, cs, cs, nil,
		s.chest[1], s.chest[2], s.chest[3], s.chest[4])

	-- The arrow: it bounces over the chest and points down at it.
	local bobY = math.floor(math.cos(saveAnim.bobAngle) * (s.bob or 0))
	Image.draw(spritesheet, s.x + s.arrowDX, s.y + s.arrowDY + bobY,
		as, as, nil,
		s.arrow[1], s.arrow[2], s.arrow[3], s.arrow[4])
end

-- Draws the save icon over the screen. Call it in every loop that redraws
-- the whole screen, right before the flip.
function drawSaveOverlay()
	updateSaveAnim()
	drawSaveAnim()
end

-- ================= SAVE STUBS (lazy-load assets/misc/savefiles.lua) =================
-- SaveGame writes the file, then plays the blocking save animation.
function SaveGame(episodeNumber)
	currentEpisode = episodeNumber
	currentSaveSlot = currentSaveSlot or 1
	require("assets/misc/savefiles")
	SaveToFile(currentSaveSlot)
	PlaySaveAnim()
	wr(episodeNumber .. "_status", "continue")
	for i = episodeNumber + 1, 5 do
		rm(i .. "_status")
		_G["status_" .. i] = nil
	end
end

-- Autosave at choice checkpoints: throttled by the autosave_freq setting
-- (0 = off, 1 = every choice, N = every N choices). Writes the current slot
-- file so the save menu always reflects progress, and marks this episode
-- "continue" so the episode menu shows it. Unlike SaveGame it never clears
-- later episodes' status markers (replaying an older episode must not wipe a
-- marker for an episode already played). Called from each episode's choice node.
function AutoSave(episodeNumber)
	local freq = sav.get("settings", "autosave_freq", 1) or 1
	if freq == 0 then return end
	choiceCounter = choiceCounter + 1
	if choiceCounter < freq then return end
	choiceCounter = 0
	local ep = tonumber(episodeNumber) or currentEpisode or 1
	currentEpisode = ep
	currentSaveSlot = currentSaveSlot or 1
	require("assets/misc/savefiles")
	SaveToFile(currentSaveSlot)
	PlaySaveAnim()
	wr(ep .. "_status", "continue")
	_G["status_" .. ep] = "continue"
end

function LoadEpisodeVars(episodeNumber)
	require("assets/misc/savefiles")
	local sf = GetSaveFile(currentSaveSlot)
	if sf and sf.vars then
		for key, val in pairs(sf.vars) do
			_G[key] = val
		end
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
	return sf.scene or ("assets/video/episode" .. episodeNumber .. "/episode" .. episodeNumber .. ".lua")
end

-- Clears the save of the current slot for the episode (a new game/restart).
function ClearEpisodeSave(episodeNumber)
	require("assets/misc/savefiles")
	DeleteSaveFile(currentSaveSlot)
end
