local choosing = true
local square = Image.load("assets/icons/square.png")
local cross = Image.load("assets/icons/cross.png")

PMP.setVolume(pmpvolume)
local result = PMP.playEasy('assets/video/episode5/choices/no_mi/1/cobblestone.pmp', buttons.r, true, 'assets/video/episode5/choices/no_mi/1/cobblestone.srt', font, subssize, "#FFFFFF", "#000000/150", subs)
if result == 1 then
    nextscene = "./mainmenu.lua"
    return 1
end

Image.draw(square, 59, 160)
intraFont.print(59 - intraFont.textW(font, "Bookcase", 0.4) / 2 + 8, 160 + 14, "Bookcase", Color.new(255,255,255), font, 0.4)
Image.draw(cross, 282, 207)
intraFont.print(282 - intraFont.textW(font, "Crafting Table", 0.4) / 2 + 8, 207 + 14, "Crafting Table", Color.new(255,255,255), font, 0.4)
intraFont.print(345 - 5 - intraFont.textW(font, "Press R to save", 0.63), 230, "Press R to save", Color.new(255,255,255, 150), font, 0.63)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()

while choosing do
    buttons.read()

    if buttons.pressed(buttons.square) then
        Image.unload(square)
        Image.unload(cross)
        choosing = false
        nextscene = "assets/video/episode5/choices/no_mi/1/bookcase_noleverslot_nodrybush_nocobblestone.lua"
    elseif buttons.pressed(buttons.cross) then
        Image.unload(square)
        Image.unload(cross)
        choosing = false
        nextscene = "assets/video/episode5/choices/no_mi/1/crafting_table_nodoor.lua"
    elseif buttons.pressed(buttons.start) then
Image.unload(square)
Image.unload(cross)
choosing = false
local pause = dofile("assets/misc/pause.lua")
if pause == -1 then nextscene = "./mainmenu.lua" end
    elseif buttons.pressed(buttons.r) then
choosing = false
        SaveGame(5)
    end
end
