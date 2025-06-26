local choosing = true
local img = Image.load('assets/video/episode1/choices/16/chicken_machine.png')
local cm_button = buttons.circle
local cm_script = "assets/video/episode1/choices/16/slime.lua"
if slime == "on" then
    img = Image.load('assets/video/episode1/choices/16/chicken_machine_slime.png')
    cm_button = buttons.cross
    cm_script = "assets/video/episode1/choices/16/lukas.lua"
end

PMP.setVolume(pmpvolume)
PMP.play('assets/video/episode1/choices/16/chicken_machine.pmp', buttons.r)

screen.clear()
Image.draw(img, 0, 0)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()


while choosing do
    buttons.read()

    if buttons.pressed(buttons.square) then
        Image.unload(img)
        choosing = false
        nextscene =  "assets/video/episode1/choices/16/chicken_machine_again.lua"
    elseif buttons.pressed(cm_button) then
        Image.unload(img)
        choosing = false
        nextscene = cm_script
    elseif slime == "on" and buttons.pressed(buttons.circle) then
        Image.unload(img)
        choosing = false
        nextscene =  "assets/video/episode1/choices/16/crafting_table.lua"
    elseif buttons.pressed(buttons.l) then
        Image.unload(img)
        choosing = false
        nextscene =  "./mainmenu.lua"
    elseif buttons.pressed(buttons.start) then
        Image.unload(img)
        choosing = false
        SaveGame(1)
        nextscene =  "./mainmenu.lua"
    end


end
