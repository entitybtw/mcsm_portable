wr("2_status", "restart")
PMP.setVolume(pmpvolume)
local result = PMP.playExt(
	"assets/video/episode2/gabriel/5/be_careful.pmp",
	buttons.r,
	true,
	"assets/subtitles/episode2/gabriel/5/be_careful.srt",
	font,
	subssize,
	"#FFFFFF",
	"#000000/150",
	subs
)
if result == 1 then
	nextscene = "./mainmenu.lua"
	return 1
end
PMP.setVolume(pmpvolume)
PMP.playExt("assets/video/credits/ep2.pmp", buttons.start)
nextscene = "./mainmenu.lua"
