local choosing = true
PMP.setVolume(pmpvolume)
local result = PMP.playExt('assets/video/episode1/choices/14/your_machine_was_cool_' .. reuben .. '.pmp', buttons.r, true, 'assets/subtitles/episode1/choices/14/your_machine_was_cool_' .. reuben .. '.srt', font, subssize, "#FFFFFF", "#000000/150", subs)
if result == 1 then
    nextscene = "./mainmenu.lua"
    return 1
end

Image.draw(spritesheet, 25, 127, 15, 15, nil, 414, 0, 15, 15)
Image.draw(spritesheet, 455, 127, 15, 15, nil, 384, 0, 15, 15)
intraFont.print(45, 127, choices_one.offer_sword, Color.new(255,255,255), font, 0.4)
intraFont.print(450 - intraFont.textW(font, choices_one.threaten, 0.4), 127, choices_one.threaten, Color.new(255,255,255), font, 0.4)
intraFont.print(340 - intraFont.textW(font, ui.save, 0.63), 230, ui.save, Color.new(255,255,255, 150), font, 0.63)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()

while choosing do
    buttons.read()
    if buttons.pressed(buttons.square) then
        choosing = false
        nextscene =  "assets/video/episode1/choices/15/offer_sword.lua"
    elseif buttons.pressed(buttons.circle) then
        choosing = false
        nextscene =  "assets/video/episode1/choices/15/threaten.lua"
    elseif buttons.pressed(buttons.start) then
choosing = false
local pause = dofile("assets/misc/pause.lua")
if pause == -1 then nextscene = "./mainmenu.lua" end
    end

end
