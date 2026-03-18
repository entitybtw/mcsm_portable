-- Endercon Interactive Zone --
-- Starts Here! --
sword = ""
PMP.setVolume(pmpvolume)
local result = PMP.playExt(
	"assets/video/episode1/choices/15/offer_sword_" .. reuben .. ".pmp",
	buttons.r,
	true,
	"assets/subtitles/episode1/choices/15/offer_sword_" .. reuben .. ".srt",
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
nextscene = "assets/video/episode1/choices/16/endercon_zone.lua"
