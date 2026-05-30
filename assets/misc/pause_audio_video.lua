subs = true
subssize = 0.4
debugoverlay.loadSettings()

av_offsetX    = 153
av_sliderY    = 13
av_titleX     = 230 - intraFont.textW(font, ui.audiovideotext, 1) / 2 + 14
av_titleY     = 25
av_hintX      = 238 - intraFont.textW(font, "", 1) / 2 + 8
av_hintY      = 234
av_toggleStep = 33

function av_drawBg()
	Image.draw(pause_bg, 0, 0)
	Image.draw(spritesheet, 240 - intraFont.textW(font, ui.previous_menu, 1) / 2 - 2, 233 + 13, 14, 14, nil, 384, 0, 15, 15)
	intraFont.printShadowed(240 - intraFont.textW(font, ui.previous_menu, 1) / 2 + 14, 233 + 14, ui.previous_menu, Color.new(255, 255, 255), Color.new(0, 0, 0), font, 90, 1, 1, 0)
end

function av_drawHint() end

function av_onExit()
	ui_enabled = false
	screen.flip()
	LUA.sleep(165)
	ui_enabled = true
end

dofile("assets/misc/av_common.lua")
