local img = Image.load("assets/mainmenu/byentitybtw.png")
local pmpfile = io.open("assets/saves/sound_levels/pmpvideos.txt", "r")
if not pmpfile then
    pmpfile = io.open("assets/saves/sound_levels/pmpvideos.txt", "w")
    pmpfile:write("10")
    pmpfile:close()
    pmpfile = io.open("assets/saves/sound_levels/pmpvideos.txt", "r")
end

local pmpSaved = tonumber(pmpfile:read("*l"))
if pmpSaved and pmpSaved >= 0 and pmpSaved <= 10 then
    pmpvolume = pmpSaved * 10
end
pmpfile:close()
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
