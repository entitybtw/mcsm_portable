local path = System.LoadData("assets/ui/saves_bg.png")
if path then
	PMP.setVolume(pmpvolume)
	PMP.playExt("assets/ui/loading.pmp")
	nextscene = path.data
	return 1
end

nextscene = "assets/video/episode5/episode5.lua"
return 1
