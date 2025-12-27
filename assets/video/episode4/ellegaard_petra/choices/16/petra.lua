local choosing = true
local petra = true
PMP.setVolume(pmpvolume)
local result = PMP.playEasy('assets/video/episode4/ellegaard_petra/choices/16/petra.pmp', buttons.r, true, 'assets/video/episode4/ellegaard_petra/choices/16/petra.srt', font, subssize, "#FFFFFF", "#000000/150", subs)
if result == 1 then
    -- Go To Menu
    return 1
end

Image.draw(square, 25, 127)
Image.draw(circle, 455, 127)
intraFont.print(45, 127, "You'll be fine", Color.new(255,255,255), font, 0.4)
intraFont.print(450 - intraFont.textW(font, "I won't lie to you", 0.4), 127, "I won't lie to you", Color.new(255,255,255), font, 0.4)
intraFont.print(340 - intraFont.textW(font, "Press R to save", 0.63), 230, "Press R to save", Color.new(255,255,255, 150), font, 0.63)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()

while choosing do
    buttons.read()

    if buttons.pressed(buttons.square) then
        choosing = false
        return dofile("assets/video/episode4/ellegaard_petra/choices/16/petra/youll_be_fine.lua")
    elseif buttons.pressed(buttons.circle) then
        choosing = false
        return dofile("assets/video/episode4/ellegaard_petra/choices/16/petra/i_wont_lie_to_you.lua")
    elseif buttons.pressed(buttons.start) then
        choosing = false
        local pause = dofile("assets/misc/pause.lua")
        if pause == -1 then
            -- Go To Menu
            return 1
        end
    elseif buttons.pressed(buttons.r) then
        choosing = false
        SaveGame(4)
    elseif not petra then
        choosing = false
        break
    end
end
