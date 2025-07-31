local choosing = true
local square = Image.load("assets/icons/square.png")
local cross = nil
local circle = nil
local cm_button = buttons.circle
local cm_script = "assets/video/episode1/choices/16/slime.lua"
PMP.setVolume(pmpvolume)
local result = PMP.playEasy('assets/video/episode1/choices/16/chicken_machine.pmp', buttons.r, true, 'assets/video/episode1/choices/16/chicken_machine.srt', font, subssize, "#FFFFFF", "#000000/150", subs)
if result == 1 then
    nextscene = "./mainmenu.lua"
    return 1
end

if slime == "on" then
    cross = Image.load("assets/icons/cross.png")
    circle = Image.load("assets/icons/circle.png")
    Image.draw(circle, 334, 153)
    intraFont.print(334 - intraFont.textW(font, "Crafting Table", 0.4) / 2 + 8, 153 + 14, "Crafting Table", Color.new(255,255,255), font, 0.4)
    Image.draw(cross, 141, 139)
    intraFont.print(141 - intraFont.textW(font, "Lukas", 0.4) / 2 + 8, 139 + 14, "Lukas", Color.new(255,255,255), font, 0.4)
    cm_button = buttons.cross
    cm_script = "assets/video/episode1/choices/16/lukas.lua"
elseif slime == "off" then
    circle = Image.load("assets/icons/circle.png")
    Image.draw(circle, 141, 139)
    intraFont.print(141 - intraFont.textW(font, "Slime", 0.4) / 2 + 8, 139 + 14, "Slime", Color.new(255,255,255), font, 0.4)
end
Image.draw(square, 221, 122)
intraFont.print(221 - intraFont.textW(font, "Chicken Machine 2", 0.4) / 2 + 8, 122 + 14, "Chicken Machine 2", Color.new(255,255,255), font, 0.4)
intraFont.print(345 - 5 - intraFont.textW(font, "Press R to save", 0.63), 230, "Press R to save", Color.new(255,255,255, 150), font, 0.63)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()

while choosing do
    buttons.read()
    if buttons.pressed(buttons.square) then
        Image.unload(square)
        if slime == "on" then Image.unload(cross) Image.unload(circle) elseif slime == "off" then Image.unload(circle) end
        choosing = false
        nextscene =  "assets/video/episode1/choices/16/chicken_machine_again.lua"
    elseif buttons.pressed(cm_button) then
        Image.unload(square)
        if slime == "on" then Image.unload(cross) Image.unload(circle) elseif slime == "off" then Image.unload(circle) end
        choosing = false
        nextscene = cm_script
    elseif slime == "on" and buttons.pressed(buttons.circle) then
        Image.unload(square)
        if slime == "on" then Image.unload(cross) Image.unload(circle) elseif slime == "off" then Image.unload(circle) end
        choosing = false
        nextscene =  "assets/video/episode1/choices/16/crafting_table.lua"
    elseif buttons.pressed(buttons.start) then
        Image.unload(square)
        if slime == "on" then Image.unload(cross) Image.unload(circle) elseif slime == "off" then Image.unload(circle) end
        choosing = false
dofile("assets/misc/pause.lua")
    elseif buttons.pressed(buttons.r) then
choosing = false
        SaveGame(1)
    end

end
