local choosing = true
local square = Image.load("assets/icons/square.png")
local cross = Image.load("assets/icons/cross.png")

PMP.setVolume(pmpvolume)
PMP.playEasy('assets/video/episode3/petra/choices/16/axel_button.pmp', buttons.r, true, 'assets/video/episode3/petra/choices/16/axel_button.srt', font, subssize, "#FFFFFF", "#000000/150", subs)

Image.draw(cross, 277, 80)
intraFont.print(277 - intraFont.textW(font, "Lukas", 0.4) / 2 + 8, 80 + 14, "Lukas", Color.new(255,255,255), font, 0.4)
Image.draw(square, 321, 131)
intraFont.print(321 - intraFont.textW(font, "Chest", 0.4) / 2 + 8, 131 + 14, "Chest", Color.new(255,255,255), font, 0.4)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()

while choosing do
    buttons.read()

    if buttons.pressed(buttons.cross) then
        Image.unload(square)
        Image.unload(cross)
        choosing = false
        nextscene =  "assets/video/episode3/petra/choices/16/lukas2_noolivia_noaxel.lua"
    elseif buttons.pressed(buttons.square) then
        Image.unload(square)
        Image.unload(cross)
        choosing = false
        nextscene =   "assets/video/episode3/petra/choices/16/chest.lua"
    elseif buttons.pressed(buttons.l) then
        Image.unload(square)
        Image.unload(cross)
        choosing = false
        nextscene =  "./mainmenu.lua"
    elseif buttons.pressed(buttons.r) then
        Image.unload(square)
        Image.unload(cross)
        choosing = false
        SaveGame(3)
        nextscene =  "./mainmenu.lua"
    end

end

