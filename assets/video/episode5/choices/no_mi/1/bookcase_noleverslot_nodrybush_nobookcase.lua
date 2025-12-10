local choosing = true
local triangle = Image.load("assets/icons/triangle.png")

PMP.setVolume(pmpvolume)
local result = PMP.playEasy('assets/video/episode5/choices/no_mi/1/bookcase.pmp', buttons.r, true, 'assets/video/episode5/choices/no_mi/1/bookcase.srt', font, subssize, "#FFFFFF", "#000000/150", subs)
if result == 1 then
    nextscene = "./mainmenu.lua"
    return 1
end

Image.draw(triangle, 144, 203)
intraFont.print(144 - intraFont.textW(font, "Cobblestone", 0.4) / 2 + 8, 203 + 14, "Cobblestone", Color.new(255,255,255), font, 0.4)
intraFont.print(345 - 5 - intraFont.textW(font, "Press R to save", 0.63), 230, "Press R to save", Color.new(255,255,255, 150), font, 0.63)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()

while choosing do
    buttons.read()

    if buttons.pressed(buttons.triangle) then
        Image.unload(triangle)
        choosing = false
        nextscene = "assets/video/episode5/choices/no_mi/1/cobblestone_noleverslot_nodrybush_nobookcase.lua"
    elseif buttons.pressed(buttons.start) then
Image.unload(triangle)
choosing = false
local pause = dofile("assets/misc/pause.lua")
if pause == -1 then nextscene = "./mainmenu.lua" end
    elseif buttons.pressed(buttons.r) then
choosing = false
        SaveGame(5)
    end
end
