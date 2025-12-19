local result = PMP.playEasy('assets/video/episode5/choices/35/lukas/you_could_travel.pmp', buttons.r, true, 'assets/video/episode5/choices/35/lukas/you_could_travel.srt', font, subssize, "#FFFFFF", "#000000/150", subs)
if result == 1 then
    nextscene = "./mainmenu.lua"
    return 1
end
PMP.play("assets/video/credits/ep5.pmp", buttons.start, false)