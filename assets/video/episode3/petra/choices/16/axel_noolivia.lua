local choosing = true
PMP.setVolume(pmpvolume)
local result = PMP.playExt('assets/video/episode3/petra/choices/16/axel_button.pmp', buttons.r, true, 'assets/subtitles/episode3/petra/choices/16/axel_button.srt', font, subssize, "#FFFFFF", "#000000/150", subs)
if result == 1 then
    nextscene = "./mainmenu.lua"
    return 1
end

Image.draw(spritesheet, 277, 80, 15, 15, nil, 399, 0, 15, 15)
intraFont.print(277 - intraFont.textW(font, "Lukas", 0.4) / 2 + 8, 80 + 14, "Lukas", Color.new(255,255,255), font, 0.4)
Image.draw(spritesheet, 224, 64, 15, 15, nil, 414, 0, 15, 15)
intraFont.print(224 - intraFont.textW(font, "Button", 0.4) / 2 + 8, 64 + 14, "Button", Color.new(255,255,255), font, 0.4)
intraFont.print(340 - intraFont.textW(font, "Press R to save", 0.63), 230, "Press R to save", Color.new(255,255,255, 150), font, 0.63)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()
while choosing do
    buttons.read()

    if buttons.pressed(buttons.cross) then
        choosing = false
        nextscene =  "assets/video/episode3/petra/choices/16/lukas_noaxel_noolivia.lua"
    elseif buttons.pressed(buttons.square) then
        choosing = false
        nextscene =  "assets/video/episode3/petra/choices/16/button_noaxel_noolivia.lua"
    elseif buttons.pressed(buttons.start) then
choosing = false
local pause = dofile("assets/misc/pause.lua")
if pause == -1 then nextscene = "./mainmenu.lua" end
    elseif buttons.pressed(buttons.r) then
choosing = false
        SaveGame(3)
    end

end

