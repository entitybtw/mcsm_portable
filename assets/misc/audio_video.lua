subs = true
subssize = 0.4
debugoverlay.loadSettings()

av_offsetX   = 38
av_sliderY   = 27
av_titleX    = 40
av_titleY    = 35
av_hintX     = 43
av_hintY     = 220
av_toggleStep = 36

function av_drawBg()
	if PMP.getFrame(videoFrame) then
		Image.draw(videoFrame, 0, 0)
	end
	Image.draw(spritesheet, 40, 233, 14, 14, nil, 384, 0, 15, 15)
	intraFont.printShadowed(57, 234, ui.previous_menu, Color.new(255, 255, 255), Color.new(0, 0, 0), font, 90, 1, 1, 0)
end

function av_drawHint() end

function av_onExit()
	ui_enabled = false
	screen.flip()
	menuTransition(11)
	ui_enabled = true
end

dofile("assets/misc/av_common.lua")
