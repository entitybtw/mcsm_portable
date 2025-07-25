wr("1_status", "restart")
PMP.setVolume(pmpvolume)
PMP.playEasy('assets/video/episode1/choices/37/go_for_magnus.pmp', buttons.r, true, 'assets/video/episode1/choices/37/go_for_magnus.srt', font, subssize, "#FFFFFF", "#000000/150", subs)
PMP.setVolume(pmpvolume)
PMP.playEasy('assets/video/credits/ep1.pmp', buttons.start, true, 'assets/video/credits/ep1.srt', font, subssize, "#FFFFFF", "#000000/150", subs)
nextscene =  "./mainmenu.lua"
