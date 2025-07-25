local choosing = true
local square = Image.load("assets/icons/square.png")
local circle = Image.load("assets/icons/circle.png")
local cross = Image.load("assets/icons/cross.png")

PMP.setVolume(pmpvolume)
PMP.playEasy('assets/video/episode2/ellegaard/choices/1/youre_just_as_good.pmp', buttons.r, true, 'assets/video/episode2/ellegaard/choices/1/youre_just_as_good.srt', font, subssize, "#FFFFFF", "#000000/150", subs)

Image.draw(cross, 125, 216)
intraFont.print(125 - intraFont.textW(font, "Autofarm", 0.4) / 2 + 8, 216 + 14, "Autofarm", Color.new(255,255,255), font, 0.4)
Image.draw(square, 160, 173)
intraFont.print(160 - intraFont.textW(font, "Chest", 0.4) / 2 + 8, 173 + 14, "Chest", Color.new(255,255,255), font, 0.4)
Image.draw(circle, 344, 167)
intraFont.print(344 - intraFont.textW(font, "Intellectual", 0.4) / 2 + 8, 167 + 14, "Intellectual", Color.new(255,255,255), font, 0.4)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()

while choosing do
    buttons.read()

    if buttons.pressed(buttons.square) then
        Image.unload(square)
        Image.unload(circle)
        Image.unload(cross)
        choosing = false
        nextscene =  "assets/video/episode2/ellegaard/choices/2/chest.lua"
    elseif buttons.pressed(buttons.circle) then
        Image.unload(square)
        Image.unload(circle)
        Image.unload(cross)
        choosing = false
        nextscene =  "assets/video/episode2/ellegaard/choices/2/intellectual.lua"
    elseif buttons.pressed(buttons.cross) then
	Image.unload(square)
        Image.unload(circle)
        Image.unload(cross)
	choosing = false
	nextscene =  "assets/video/episode2/ellegaard/choices/2/autofarm.lua"
    elseif buttons.pressed(buttons.l) then
        Image.unload(square)
        Image.unload(circle)
        Image.unload(cross)
        choosing = false
        nextscene =  "./mainmenu.lua"
    elseif buttons.pressed(buttons.start) then
        Image.unload(square)
        Image.unload(circle)
        Image.unload(cross)
        choosing = false
        SaveGame(2)
        nextscene =  "./mainmenu.lua"
    end

end
