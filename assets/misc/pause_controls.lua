local img = Image.load("assets/ui/controls/psp.png")
local imgfade = 0
local creditfade = 0
local rectfade = 0
local imgtimer = timer.create()
local isFadingOut = false
local fadeOutProgress = 0
local exitAfterFade = false
debugoverlay.loadSettings()

while true do
	buttons.read()
	screen.clear()

	Image.draw(pause_bg, 0, 0)

	if isFadingOut then
		fadeOutProgress = math.max(fadeOutProgress - 1.5, 0)
		rectfade = fadeOutProgress
		if imgfade > 0 then imgfade = math.max(imgfade - 8, 0) end
		if creditfade > 0 then creditfade = math.max(creditfade - 5, 0) end
		if fadeOutProgress == 0 and exitAfterFade then
			Image.unload(img)
			sound.playEasy("assets/sounds/skeleton_1.wav", sound.WAV_1, false, false, uiLevel * 10)
			break
		end
	else
		local elapsed = timer.time(imgtimer)
		if elapsed >= 300 and imgfade < 255 then
			imgfade = math.min(imgfade + 15, 255)
		end
		creditfade = math.min(imgfade * 0.6, 100)
		rectfade = math.min(rectfade + 5, 50)
	end

	screen.filledRect(0, 0, 480, 272, Color.new(0, 0, 0), nil, rectfade)
	Image.draw(img, 47.5, 26, 385, 220, nil, nil, nil, nil, nil, nil, imgfade)
	Image.draw(spritesheet, 240 - intraFont.textW(font, ui.previous_menu, 1) / 2 - 8, 233 + 13, 14, 14, nil, 384, 0, 15, 15, nil, imgfade)
	intraFont.printShadowed(240 - intraFont.textW(font, ui.previous_menu, 1) / 2 + 8, 233 + 14, ui.previous_menu, Color.new(255, 255, 255, imgfade), Color.new(0, 0, 0, imgfade), font, 90, 1, 1, 0)
	intraFont.printShadowed(225 - intraFont.textW(font, ui.controls, 1) / 2 + 8, 5 + 14, ui.controls, Color.new(255, 255, 255, imgfade), Color.new(0, 0, 0, imgfade), font, 90, 1, 1, 0)
	intraFont.printShadowed(390, 75,  ui.cutscene_skip, Color.new(255, 255, 255, imgfade), Color.new(0, 0, 0, imgfade), font, 90, 1, 1, 0)
	intraFont.printShadowed(380, 135, ui.actions,       Color.new(255, 255, 255, imgfade), Color.new(0, 0, 0, imgfade), font, 90, 1, 1, 0)
	intraFont.printShadowed(360, 190, ui.pause_menu,    Color.new(255, 255, 255, imgfade), Color.new(0, 0, 0, imgfade), font, 90, 1, 1, 0)
	intraFont.printShadowed(280 - intraFont.textW(font, ui.pause_game, 1) / 2 + 8, 193 + 14, ui.pause_game, Color.new(255, 255, 255, imgfade), Color.new(0, 0, 0, imgfade), font, 90, 1, 1, 0)
	intraFont.printShadowed(3, 259, ui.art_by, Color.new(255, 255, 255, creditfade), Color.new(0, 0, 0, creditfade), font, 90, 1, 1, 0)
	debugoverlay.draw()
	screen.flip()

	if buttons.pressed(buttons.circle) and not isFadingOut then
		isFadingOut = true
		exitAfterFade = true
		fadeOutProgress = rectfade
	end
end
