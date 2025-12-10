local choosing = true
local square = Image.load("assets/icons/square.png")
local circle = Image.load("assets/icons/circle.png")

PMP.setVolume(pmpvolume)
local result = PMP.playEasy('assets/video/episode5/choices/no_mi/1/strange_wall.pmp', buttons.r, true, 'assets/video/episode5/choices/no_mi/1/strange_wall.srt', font, subssize, "#FFFFFF", "#000000/150", subs)
if result == 1 then
    nextscene = "./mainmenu.lua"
    return 1
end

Image.draw(square, 59, 160)
intraFont.print(59 - intraFont.textW(font, "Bookcase", 0.4) / 2 + 8, 160 + 14, "Bookcase", Color.new(255,255,255), font, 0.4)
Image.draw(circle, 397, 166)
intraFont.print(397 - intraFont.textW(font, "Lever Slot", 0.4) / 2 + 8, 166 + 14, "Lever Slot", Color.new(255,255,255), font, 0.4)
intraFont.print(345 - 5 - intraFont.textW(font, "Press R to save", 0.63), 230, "Press R to save", Color.new(255,255,255, 150), font, 0.63)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()

while choosing do
    buttons.read()

    if buttons.pressed(buttons.square) then
        Image.unload(square)
        Image.unload(circle)
        choosing = false
        nextscene = "assets/video/episode5/choices/no_mi/1/bookcase_nodoor_nocraftingtable.lua"
    elseif buttons.pressed(buttons.circle) then
        Image.unload(square)
        Image.unload(circle)
        choosing = false
        nextscene = "assets/video/episode5/choices/no_mi/1/lever_slot_2.lua"
    elseif buttons.pressed(buttons.triangle) then
        Image.unload(square)
        Image.unload(circle)
        choosing = false
        nextscene = "assets/video/episode5/choices/no_mi/1/cobblestone_nodoor_nocraftingtable.lua"
    elseif buttons.pressed(buttons.cross) then
        Image.unload(square)
        Image.unload(circle)
        choosing = false
        nextscene = "assets/video/episode5/choices/no_mi/1/drybush_nodoor_nocraftingtable.lua"
    elseif buttons.pressed(buttons.start) then
Image.unload(square)
Image.unload(circle)
choosing = false
local pause = dofile("assets/misc/pause.lua")
if pause == -1 then nextscene = "./mainmenu.lua" end
    elseif buttons.pressed(buttons.r) then
choosing = false
        SaveGame(5)
    end
end
