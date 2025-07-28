local choosing = true
local square = Image.load("assets/icons/square.png")

PMP.setVolume(pmpvolume)
PMP.playEasy('assets/video/episode3/petra/choices/8/petra.pmp', buttons.r, true, 'assets/video/episode3/petra/choices/8/petra.srt', font, subssize, "#FFFFFF", "#000000/150", subs)

Image.draw(square, 394, 224)
intraFont.print(394 - intraFont.textW(font, "Lever (Petra)", 0.4) / 2 + 8, 224 + 14, "Lever (Petra)", Color.new(255,255,255), font, 0.4)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()

while choosing do
    buttons.read()

    if buttons.pressed(buttons.square) then
        Image.unload(square)
        choosing = false
        nextscene =  "assets/video/episode3/petra/choices/8/leverpetra_noleverreuben.lua"
    elseif buttons.pressed(buttons.l) then
        Image.unload(square)
        choosing = false
        nextscene =  "./mainmenu.lua"
    elseif buttons.pressed(buttons.r) then
        Image.unload(square)
        choosing = false
        SaveGame(3)
        nextscene =  "./mainmenu.lua"
    end

end

