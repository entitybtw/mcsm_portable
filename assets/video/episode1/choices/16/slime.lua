local choosing = true
slime = "on"
local square = Image.load("assets/icons/square.png")
local cross = Image.load("assets/icons/cross.png")
local circle = Image.load("assets/icons/circle.png")
PMP.setVolume(pmpvolume)
PMP.playEasy('assets/video/episode1/choices/16/slime.pmp', buttons.r, true, 'assets/video/episode1/choices/16/slime.srt', font, subssize, "#FFFFFF", "#000000/150", subs)

Image.draw(circle, 334, 153)
intraFont.print(334 - intraFont.textW(font, "Crafting Table", 0.4) / 2 + 8, 153 + 14, "Crafting Table", Color.new(255,255,255), font, 0.4)
Image.draw(cross, 141, 139)
intraFont.print(141 - intraFont.textW(font, "Lukas", 0.4) / 2 + 8, 139 + 14, "Lukas", Color.new(255,255,255), font, 0.4)
Image.draw(square, 221, 122)
intraFont.print(221 - intraFont.textW(font, "Chicken Machine", 0.4) / 2 + 8, 122 + 14, "Chicken Machine", Color.new(255,255,255), font, 0.4)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()


while choosing do
    buttons.read()

    if buttons.pressed(buttons.square) then
        Image.unload(square)
        Image.unload(cross)
        Image.unload(circle)
        choosing = false
        nextscene =  "assets/video/episode1/choices/16/chicken_machine_again.lua"
    elseif buttons.pressed(buttons.cross) then
        Image.unload(square)
        Image.unload(cross)
        Image.unload(circle)
        choosing = false
        nextscene = "assets/video/episode1/choices/16/lukas.lua"
    elseif buttons.pressed(buttons.circle) then
        Image.unload(square)
        Image.unload(cross)
        Image.unload(circle)
        choosing = false
        nextscene =  "assets/video/episode1/choices/16/crafting_table.lua"
    elseif buttons.pressed(buttons.l) then
        Image.unload(square)
        Image.unload(cross)
        Image.unload(circle)
        choosing = false
        nextscene =  "./mainmenu.lua"
    elseif buttons.pressed(buttons.start) then
        Image.unload(square)
        Image.unload(cross)
        Image.unload(circle)
        choosing = false
        SaveGame(1)
        nextscene =  "./mainmenu.lua"
    end


end
