local choosing = true
local triangle = Image.load("assets/icons/triangle.png")
local cross = Image.load("assets/icons/cross.png")

PMP.setVolume(pmpvolume)
local result = PMP.playEasy('assets/video/episode5/choices/14/build_site.pmp', buttons.r, true, 'assets/video/episode5/choices/14/build_site.srt', font, subssize, "#FFFFFF", "#000000/150", subs)
if result == 1 then
    nextscene = "./mainmenu.lua"
    return 1
end

Image.draw(cross, 115, 145)
intraFont.print(115 - intraFont.textW(font, "Innkeeper", 0.4) / 2 + 8, 145 + 14, "Innkeeper", Color.new(255,255,255), font, 0.4)
Image.draw(triangle, 330, 140)
intraFont.print(330 - intraFont.textW(font, "Townspeople", 0.4) / 2 + 8, 140 + 14, "Townspeople", Color.new(255,255,255), font, 0.4)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()

while choosing do
    buttons.read()

    if buttons.pressed(buttons.cross) then
        Image.unload(cross)
        Image.unload(triangle)
        choosing = false
        nextscene =  "assets/video/episode5/choices/14/innkeeper.lua"
    elseif buttons.pressed(buttons.triangle) then
        Image.unload(cross)
        Image.unload(triangle)
        choosing = false
        nextscene =  "assets/video/episode5/choices/14/townspeople.lua"
    elseif buttons.pressed(buttons.l) then
        choosing = false
        nextscene = "./mainmenu.lua"
    elseif buttons.pressed(buttons.start) then
        choosing = false
        SaveGame(5)
        nextscene = "./mainmenu.lua"
    end
end
