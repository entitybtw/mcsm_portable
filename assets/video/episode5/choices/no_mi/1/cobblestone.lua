local choosing = true
local square = Image.load("assets/icons/square.png")
local circle = Image.load("assets/icons/circle.png")
local cross = Image.load("assets/icons/cross.png")
cobblestone = false

PMP.setVolume(pmpvolume)
local result = PMP.playEasy('assets/video/episode5/choices/no_mi/1/cobblestone.pmp', buttons.r, true, 'assets/video/episode5/choices/no_mi/1/cobblestone.srt', font, subssize, "#FFFFFF", "#000000/150", subs)
if result == 1 then
    nextscene = "./mainmenu.lua"
    return 1
end

if not bookcase then
Image.draw(square, 59, 160)
intraFont.print(59 - intraFont.textW(font, "Bookcase", 0.4) / 2 + 8, 160 + 14, "Bookcase", Color.new(255,255,255), font, 0.4)
end
if not supply then 
Image.draw(circle, 397, 166)
intraFont.print(397 - intraFont.textW(font, "Supply Door", 0.4) / 2 + 8, 166 + 14, "Supply Door", Color.new(255,255,255), font, 0.4)
else 
    Image.draw(circle, 397, 166)
    intraFont.print(397 - intraFont.textW(font, "Lever Slot", 0.4) / 2 + 8, 166 + 14, "Lever Slot", Color.new(255,255,255), font, 0.4)
end
if dry_bush then
Image.draw(cross, 282, 207)
intraFont.print(282 - intraFont.textW(font, "Crafting Table", 0.4) / 2 + 8, 207 + 14, "Crafting Table", Color.new(255,255,255), font, 0.4)
else
Image.draw(cross, 282, 207)
intraFont.print(282 - intraFont.textW(font, "Dry Bush", 0.4) / 2 + 8, 207 + 14, "Dry Bush", Color.new(255,255,255), font, 0.4)
end
intraFont.print(345 - 5 - intraFont.textW(font, "Press R to save", 0.63), 230, "Press R to save", Color.new(255,255,255, 150), font, 0.63)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()

while choosing do
    buttons.read()

if bookcase ~= false then 
    if buttons.pressed(buttons.square) then
        if bookcase == true then Image.unload(square) end
        Image.unload(circle)
        Image.unload(cross)
        choosing = false
        nextscene = "assets/video/episode5/choices/no_mi/1/bookcase.lua"
    end
    elseif buttons.pressed(buttons.circle) then
        if bookcase == true then Image.unload(square) end
        Image.unload(circle)
        Image.unload(cross)
        choosing = false
        nextscene = "assets/video/episode5/choices/no_mi/1/supply_door.lua"
    elseif buttons.pressed(buttons.triangle) then
        if bookcase == true then Image.unload(square) end
        Image.unload(circle)
        Image.unload(cross)
        choosing = false
        nextscene = "assets/video/episode5/choices/no_mi/1/cobblestone.lua"
    elseif buttons.pressed(buttons.cross) then
        if bookcase == true then Image.unload(square) end
        Image.unload(circle)
        Image.unload(cross)
        choosing = false
        if dry_bush == false then nextscene = "assets/video/episode5/choices/no_mi/1/crafting_table.lua" else nextscene = "assets/video/episode5/choices/no_mi/1/dry_bush.lua" end
    elseif buttons.pressed(buttons.start) then
if bookcase == true then Image.unload(square) end
Image.unload(circle)
Image.unload(cross)
choosing = false
local pause = dofile("assets/misc/pause.lua")
if pause == -1 then nextscene = "./mainmenu.lua" end
    elseif buttons.pressed(buttons.r) then
choosing = false
        SaveGame(5)
    end
end
