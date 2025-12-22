local choosing = true
local square = Image.load("assets/icons/square.png")
local circle = Image.load("assets/icons/circle.png")
local cross = Image.load("assets/icons/cross.png")
local triangle = Image.load("assets/icons/triangle.png")

PMP.setVolume(pmpvolume)
local result = PMP.playEasy('assets/video/episode5/choices/23/look_before_you_punch.pmp', buttons.r, true, 'assets/video/episode5/choices/23/look_before_you_punch.srt', font, subssize, "#FFFFFF", "#000000/150", subs)
if result == 1 then
    nextscene = "./mainmenu.lua"
    return 1
end

-- Throne Room Interactive Zone --
-- Starts Here! --

nextscene = "assets/video/episode5/choices/no_mi/1/throne_room_zone.lua"
