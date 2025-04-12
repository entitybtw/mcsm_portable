local img = Image.load("assets/mainmenu/byentitybtw.png")
local filed = io.open("assets/saves/pmpvideos.txt", "r")
if filed then
    local savedd = tonumber(filed:read("*l"))
    if savedd and savedd >= 0 and savedd <= 10 then
        pmpvolume = savedd * 10
    end
    filed:close()
end
screen.clear()
Image.draw(img, 0, 0)
screen.flip()
LUA.sleep(400)
Image.unload(img)
PMP.setVolume(pmpvolume)
PMP.play('assets/mainmenu/mcsm_title.pmp', buttons.start)
PMP.play('assets/mainmenu/loading.pmp')
require("saves")
require("files")
sound.play("assets/sounds/bg.mp3", sound.MP3, false, true)
fade_enabled = 1

nextscene =  "./mainmenu.lua"

while true do
    dofile(nextscene)
    System.GC()
end
