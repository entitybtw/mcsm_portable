PMP.setVolume(pmpvolume)
local result = PMP.playExt(
	"assets/video/episode4/ellegaard_petra/choices/16/petra/youll_be_fine.pmp",
	buttons.r,
	true,
	"assets/subtitles/episode4/ellegaard_petra/choices/16/petra/youll_be_fine.srt",
	subs_font,
	subssize,
	"#FFFFFF",
	"#000000/110",
	subs
)
if result == 1 then
	-- Go To Menu
	return 1
end
