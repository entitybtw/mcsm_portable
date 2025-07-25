-- initialize variables
local fade = 255
local soundlevels = io.open("assets/saves/soundlevels.txt", "r")
local subtitles = io.open("assets/saves/subtitles.txt", "r")
font = intraFont.load("assets/minecraft.pgf")
require("easy")

-- check if the file exists; if not, create it with default values (10 for each setting)
if not soundlevels then
    soundlevels = io.open("assets/saves/soundlevels.txt", "w")
    soundlevels:write("10\n10\n10")
    soundlevels:close()
    soundlevels = io.open("assets/saves/soundlevels.txt", "r")
end
menumusic = tonumber(soundlevels:read("*l"))
pmpvideos = tonumber(soundlevels:read("*l")) 
uiLevel = tonumber(soundlevels:read("*l"))
if not subtitles then
    subtitles = io.open("assets/saves/subtitles.txt", "w")
    subtitles:write("true\n0.4")
    subtitles:close()
    subtitles = io.open("assets/saves/subtitles.txt", "r")
end
subs = tonumber(subtitles:read("*l"))
subssize = tonumber(subtitles:read("*l")) 

subtitles:close()

-- load images
local byentitybtw = Image.load("assets/mainmenu/byentitybtw.png")
local headphones = Image.load("assets/mainmenu/headphones.png")

-- load menumusic level
if menumusic and menumusic >= 0 and menumusic <= 10 then
    sound.volumeEasy(sound.MP3, menumusic * 10)
end

-- load pmp videos sound level
if pmpvideos and pmpvideos >= 0 and pmpvideos <= 10 then
    pmpvolume = pmpvideos * 10
end

-- load ui sounds level
if uiLevel and uiLevel >= 0 and uiLevel <= 10 then
    sound.volumeEasy(sound.WAV_1, uiLevel * 10)
end

soundlevels:close()

-- byentitybtw fade in
fade = 255
while fade > 0 do
    fade = fade - 8
    screen.clear()
    Image.draw(byentitybtw, 0, 0, 480, 272, nil, nil, nil, nil, nil, nil, 255 - fade)
    screen.flip()
    LUA.sleep(16)
end

LUA.sleep(2000)

-- byentitybtw fade out
fade = 0
while fade < 255 do
    fade = fade + 8
    screen.clear()
    Image.draw(byentitybtw, 0, 0, 480, 272, nil, nil, nil, nil, nil, nil, 255 - fade)
    screen.flip()
    LUA.sleep(16)
end

-- headphones fade in
fade = 255
while fade > 0 do
    fade = fade - 8
    screen.clear()
    Image.draw(headphones, 0, 0, 480, 272, nil, nil, nil, nil, nil, nil, 255 - fade)
    screen.flip()
    LUA.sleep(16)
end

LUA.sleep(1500)

-- headphones fade out
fade = 0
while fade < 255 do
    fade = fade + 8
    screen.clear()
    Image.draw(headphones, 0, 0, 480, 272, nil, nil, nil, nil, nil, nil, 255 - fade)
    screen.flip()
    LUA.sleep(16)
end

-- unload images
Image.unload(byentitybtw)
Image.unload(headphones)

PMP.setVolume(pmpvolume)
PMP.play('assets/mainmenu/mcsm_title.pmp', false, false, nil, buttons.start) -- play title video
PMP.play('assets/mainmenu/loading.pmp') -- play loading video

-- load functions
require("saves")
require("debugoverlay")
require("files")

-- start bg music
sound.playEasy("assets/sounds/bg.mp3", sound.MP3, true, false)

fade_enabled = 1 -- enable fade effect for mainmenu (1 = enabled, 0 = disabled)
nextscene = "./mainmenu.lua" -- open mainmenu

-- optimized dofile replacement, made by dntrnk, to prevent memory overload and PSP freezes
while true do
    System.PowerTick()
    dofile(nextscene)
    System.GC()
end
