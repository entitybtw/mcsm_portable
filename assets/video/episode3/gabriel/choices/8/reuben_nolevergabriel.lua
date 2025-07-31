local choosing = true
local circle = Image.load("assets/icons/circle.png")
local cross = Image.load("assets/icons/cross.png")
PMP.setVolume(pmpvolume)
local result = PMP.playEasy('assets/video/episode3/gabriel/choices/8/reuben.pmp', buttons.r, true, 'assets/video/episode3/gabriel/choices/8/reuben.srt', font, subssize, "#FFFFFF", "#000000/150", subs)
if result == 1 then
    nextscene = "./mainmenu.lua"
    return 1
end

Image.draw(cross, 166, 131)
intraFont.print(166 - intraFont.textW(font, "Fountain", 0.4) / 2 + 8, 131 + 14, "Fountain", Color.new(255,255,255), font, 0.4)
Image.draw(circle, 305, 135)
intraFont.print(305 - intraFont.textW(font, "Lever (Reuben)", 0.4) / 2 + 8, 135 + 14, "Lever (Reuben)", Color.new(255,255,255), font, 0.4)
intraFont.print(345 - 5 - intraFont.textW(font, "Press R to save", 0.63), 230, "Press R to save", Color.new(255,255,255, 150), font, 0.63)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()
while choosing do
    buttons.read()

    if buttons.pressed(buttons.circle) then
        Image.unload(circle)
        Image.unload(cross)
        choosing = false
        nextscene =  "assets/video/episode3/gabriel/choices/8/leverreuben_nolevergabriel.lua"
    elseif buttons.pressed(buttons.cross) then
        Image.unload(circle)
        Image.unload(cross)
        choosing = false
        nextscene =  "assets/video/episode3/gabriel/choices/8/fountain_nolevergabriel_noreuben.lua"
    elseif buttons.pressed(buttons.start) then
        Image.unload(circle)
        Image.unload(cross)
        choosing = false
dofile("assets/misc/pause.lua")
    elseif buttons.pressed(buttons.r) then
choosing = false
        SaveGame(3)
    end

end

