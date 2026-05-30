local img = Image.load("assets/ui/controls/psp.png")
debugoverlay.loadSettings()

function controls_drawBg()
	if PMP.getFrame(videoFrame) then
		Image.draw(videoFrame, 0, 0)
	end
end

dofile("assets/misc/controls_common.lua")
