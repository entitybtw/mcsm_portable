local result = PMP.playExt(
	"assets/video/episode5/choices/35/founder/you_could_travel.pmp",
	buttons.r,
	true,
	"assets/subtitles/episode5/choices/35/founder/you_could_travel.srt",
	subs_font,
	subssize,
	"#FFFFFF",
	"#000000/110",
	subs
)
if result == 1 then
	nextscene = "./mainmenu.lua"
	return 1
end
PMP.play("assets/video/credits/ep5.pmp", buttons.start, false)
