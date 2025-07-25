local choosing = true
local square = Image.load("assets/icons/square.png")

PMP.setVolume(pmpvolume)
PMP.playEasy('assets/video/episode3/petra/choices/16/lukas.pmp', buttons.r, true, 'assets/video/episode3/petra/choices/16/lukas.srt', font, subssize, "#FFFFFF", "#000000/150", subs)

Image.draw(square, 224, 64)
intraFont.print(224 - intraFont.textW(font, "Button", 0.4) / 2 + 8, 64 + 14, "Button", Color.new(255,255,255), font, 0.4)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()

while choosing do
    buttons.read()

    if buttons.pressed(buttons.square) then
        Image.unload(square)
        choosing = false
        nextscene =  "assets/video/episode3/petra/choices/16/button_noaxel_noolivia_nolukas.lua"
    elseif buttons.pressed(buttons.l) then
        Image.unload(square)
        choosing = false
        nextscene =  "./mainmenu.lua"
    elseif buttons.pressed(buttons.start) then
        Image.unload(square)
        choosing = false
        SaveGame(3)
        nextscene =  "./mainmenu.lua"
    end

end

