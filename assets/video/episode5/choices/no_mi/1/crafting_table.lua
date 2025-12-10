local choosing = true
local circle = Image.load("assets/icons/circle.png")
local square = Image.load("assets/icons/square.png")

PMP.setVolume(pmpvolume)
local result = PMP.playEasy('assets/video/episode5/choices/no_mi/1/crafting_table.pmp', buttons.r, true, 'assets/video/episode5/choices/no_mi/1/crafting_table.srt', font, subssize, "#FFFFFF", "#000000/150", subs)
if result == 1 then
    nextscene = "./mainmenu.lua"
    return 1
end

Image.draw(square, 59, 160)
intraFont.print(59 - intraFont.textW(font, "Bookcase", 0.4) / 2 + 8, 160 + 14, "Bookcase", Color.new(255,255,255), font, 0.4)
if no_mi == "ivor" then
Image.draw(circle, 397, 166)
intraFont.print(397 - intraFont.textW(font, "Supply Door", 0.4) / 2 + 8, 166 + 14, "Supply Door", Color.new(255,255,255), font, 0.4)
else 
Image.draw(circle, 397, 166)
intraFont.print(397 - intraFont.textW(font, "Strange Wall", 0.4) / 2 + 8, 166 + 14, "Strange Wall", Color.new(255,255,255), font, 0.4)
end
intraFont.print(345 - 5 - intraFont.textW(font, "Press R to save", 0.63), 230, "Press R to save", Color.new(255,255,255, 150), font, 0.63)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()

while choosing do
    buttons.read()

    if buttons.pressed(buttons.circle) then
        Image.unload(circle)
        Image.unload(square)
        choosing = false
        if no_mi == "ivor" then nextscene = "assets/video/episode5/choices/no_mi/1/supply_door_nocraftingtable.lua" else nextscene = "assets/video/episode5/choices/no_mi/1/strange_wall_nocraftingble.lua"  end
    elseif buttons.pressed(buttons.square) then
        Image.unload(circle)
        Image.unload(square)
        choosing = false
        nextscene = "assets/video/episode5/choices/no_mi/1/bookcase_nocraftingtable.lua"
    elseif buttons.pressed(buttons.start) then
Image.unload(circle)
Image.unload(square)
choosing = false
local pause = dofile("assets/misc/pause.lua")
if pause == -1 then nextscene = "./mainmenu.lua" end
    elseif buttons.pressed(buttons.r) then
choosing = false
        SaveGame(5)
    end
end
