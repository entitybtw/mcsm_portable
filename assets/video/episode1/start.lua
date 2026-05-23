-- Entry point for Episode 1 (epmenu checks this file exists via hasStart()).
-- Handles save detection, intro text, then hands off to episode1.lua.

local path = System.LoadData("assets/ui/saves_bg.png")
if path then
	PMP.setVolume(pmpvolume)
	local result = PMP.playExt("assets/ui/lsave.pmp")
	if result == 1 then
		nextscene = "./mainmenu.lua"
		return 1
	end
	local varFile = io.open("assets/saves/1_variables.txt", "r")
	if varFile then
		for line in varFile:lines() do
			local k, v = line:match('^(%w+) = "([^"]+)"$')
			if k and v then _G[k] = v end
		end
		varFile:close()
	end
	nextscene = "assets/video/episode1/episode1.lua"
	return 1
end

-- New game: fade-in story tagline
PMP.setVolume(pmpvolume)
local result = PMP.playExt("assets/ui/lsave.pmp")
if result == 1 then
	nextscene = "./mainmenu.lua"
	return 1
end

local tagline = "The game series adapts to the choices you make.\n\n\n          The story is tailored by how you play"
local tagX = 230 - intraFont.textW(font, tagline, 0.3) / 2 + 8
local fade = 0

while fade < 255 do
	fade = math.min(fade + 8, 255)
	screen.clear()
	intraFont.print(tagX, 118 + 14, tagline, Color.new(255, 255, 255, fade), font, 0.3)
	screen.flip()
	LUA.sleep(16)
end
LUA.sleep(2000)
while fade > 0 do
	fade = math.max(fade - 8, 0)
	screen.clear()
	intraFont.print(tagX, 118 + 14, tagline, Color.new(255, 255, 255, fade), font, 0.3)
	screen.flip()
	LUA.sleep(16)
end

ep1_node = nil
nextscene = "assets/video/episode1/episode1.lua"
