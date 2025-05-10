local fade = require("fade")

local byentitybtw = Image.load("assets/mainmenu/byentitybtw.png")
local headphones = Image.load("assets/mainmenu/headphones.png")
local pmpfile = io.open("assets/saves/soundlevels.txt", "r")
if not pmpfile then
    pmpfile = io.open("assets/saves/soundlevels.txt", "w")
    pmpfile:write("10\n10\n10")
    pmpfile:close()
    pmpfile = io.open("assets/saves/soundlevels.txt", "r")
end
local pmpSaved = tonumber(pmpfile:read("*l")) 

if pmpSaved and pmpSaved >= 0 and pmpSaved <= 10 then
    pmpvolume = pmpSaved * 10
end
pmpfile:close()

screen.clear()
fade.fadeIn(byentitybtw, 0, 0, 480, 272, nil, 2000, nil, nil, nil, nil, nil, 255, nil)
LUA.sleep(2000)
fade.fadeOut(byentitybtw, 0, 0, 480, 272, nil, 2000, nil, nil, nil, nil, nil, 255, nil)

screen.clear()
fade.fadeIn(headphones, 0, 0, 480, 272, nil, 1500, nil, nil, nil, nil, nil, 255, nil)
LUA.sleep(1500)
fade.fadeOut(headphones, 0, 0, 480, 272, nil, 1500, nil, nil, nil, nil, nil, 255, nil)

Image.unload(byentitybtw)
Image.unload(headphones)
PMP.setVolume(pmpvolume)
PMP.play('assets/mainmenu/mcsm_title.pmp', buttons.start)
PMP.play('assets/mainmenu/loading.pmp')
require("saves")
require("debugoverlay")
require("files")
sound.play("assets/sounds/bg.mp3", sound.MP3, false, true)

nextscene =  "./mainmenu.lua"

while true do
    dofile(nextscene)
    System.GC()
end
