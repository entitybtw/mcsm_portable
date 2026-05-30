local img = Image.load("assets/ui/controls/psp.png")
debugoverlay.loadSettings()

function controls_drawBg()
	Image.draw(pause_bg, 0, 0)
end

dofile("assets/misc/controls_common.lua")
