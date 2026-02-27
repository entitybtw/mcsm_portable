-- initialize variables
local fade = 255
local voidfade = 0
local textfade = 0
local rectfade = 0

local soundlevels = io.open("assets/saves/soundlevels.txt", "r")
local subtitles = io.open("assets/saves/subtitles.txt", "r")
font = intraFont.load("assets/minecraft.pgf")
spritesheet = Image.load("assets/ui/menu-spritesheet.png")
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

-- load volumes
if menumusic and menumusic >= 0 and menumusic <= 10 then
    sound.volumeEasy(sound.MP3, menumusic * 10)
end
if pmpvideos and pmpvideos >= 0 and pmpvideos <= 10 then
    pmpvolume = pmpvideos * 10
end
if uiLevel and uiLevel >= 0 and uiLevel <= 10 then
    sound.volumeEasy(sound.WAV_1, uiLevel * 10)
end
soundlevels:close()

local byentitybtw = Image.load("assets/ui/byentitybtw.png")
local headphones = Image.load("assets/ui/headphones.png")

-- byentitybtw fade in/out
fade = 255
while fade > 0 do
    fade = fade - 8
    screen.clear()
    Image.draw(byentitybtw, 0, 0, 480, 272, nil, nil, nil, nil, nil, nil, 255 - fade)
    screen.flip()
    LUA.sleep(16)
end
LUA.sleep(2000)
fade = 0
while fade < 255 do
    fade = fade + 8
    screen.clear()
    Image.draw(byentitybtw, 0, 0, 480, 272, nil, nil, nil, nil, nil, nil, 255 - fade)
    screen.flip()
    LUA.sleep(16)
end

-- headphones fade in/out
fade = 255
while fade > 0 do
    fade = fade - 8
    screen.clear()
    Image.draw(headphones, 0, 0, 480, 272, nil, nil, nil, nil, nil, nil, 255 - fade)
    screen.flip()
    LUA.sleep(16)
end
LUA.sleep(1500)
fade = 0
while fade < 255 do
    fade = fade + 8
    screen.clear()
    Image.draw(headphones, 0, 0, 480, 272, nil, nil, nil, nil, nil, nil, 255 - fade)
    screen.flip()
    LUA.sleep(16)
end

Image.unload(byentitybtw)
Image.unload(headphones)

PMP.setVolume(pmpvolume)
local pointer = PMP.play("assets/ui/mcsm_title.pmp", true, true)

local loadingFrames = {}
local frameX = {0, 48, 96, 144, 192, 240, 288, 336}
for i = 0, 7 do
    loadingFrames[i] = { x = frameX[i+1] }
end

local startPressed = false
local loadingStartTime = 0
local frameIndex = 0
local frameTimer = 0
local currentStep = 1
local stepTimer = 0

local videoStartTime = os.clock()
local loadingSequence = {
    { text = "Initializing functions...", duration = 1.5 },
    { text = "Reading settings...",       duration = 0.7 },
    { text = "Reading save data...",      duration = 1.4 },
    { text = "Checking episodes...",      duration = 0.4 },
    { text = "Finishing up...",           duration = 2.0 },
}

while PMP.getFrame(pointer) do
    screen.clear()
    Image.draw(pointer, 0, 0)
    buttons.read()

    local currentVideoTime = os.clock() - videoStartTime
    if not startPressed and currentVideoTime >= 12 and buttons.pressed(buttons.start) then
        -- reset fades
        voidfade = 0
        textfade = 0
        rectfade = 0
        frameIndex = 0
        currentStep = 1
        
        startPressed = true
        loadingStartTime = os.clock()
        frameTimer = os.clock()
        stepTimer = os.clock()
    end

    if startPressed then
        if voidfade < 255 then
            voidfade = math.min(voidfade + 5, 255)
        end
        Image.draw(spritesheet, 177, 189, 124, 14, nil, 210, 48, 124, 14, nil, voidfade)

        local timeSinceStart = os.clock() - loadingStartTime

        if timeSinceStart >= 1 and timeSinceStart < 8 then
            if os.clock() - frameTimer >= 0.2 then
                frameIndex = (frameIndex + 1) % 8
                frameTimer = os.clock()
            end

            if textfade < 255 then
                textfade = math.min(textfade + 5, 255)
            end

            intraFont.print(235 - intraFont.textW(font, "LOADING", 0.4) / 2 + 8, 195 + 14, "LOADING",
                Color.new(255, 255, 255, textfade), font, 0.4)

            local frame = loadingFrames[frameIndex]
            if frame then
                Image.draw(spritesheet, 
                    250 - 24, 200 - 24,
                    30, 30,
                    nil,
                    frame.x, 0,
                    48, 48,
                    nil, nil, textfade)
            end

            if currentStep <= #loadingSequence then
                local step = loadingSequence[currentStep]
                intraFont.print(235 - intraFont.textW(font, step.text, 0.3) / 2 + 8, 222, step.text,
                    Color.new(255, 255, 255, textfade), font, 0.3)

                if os.clock() - stepTimer >= step.duration then
                    currentStep = currentStep + 1
                    stepTimer = os.clock()
                end
            end
        end

        if timeSinceStart >= 6 and textfade > 0 then
            textfade = math.max(textfade - 8, 0)
        end

        if timeSinceStart >= 8 then
            rectfade = math.min(rectfade + 3, 255)
            screen.filledRect(0, 0, 480, 272, Color.new(0, 0, 0), nil, rectfade)
        end

        if timeSinceStart >= 10 then
            PMP.stop(pointer)
            break
        end
    end

    screen.flip()
end

PMP.play("assets/ui/loading.pmp")

require("saves")
require("debugoverlay")
require("files")
sound.playEasy("assets/sounds/bg.at3", 5, true, false)

fade_enabled = 1
nextscene = "./mainmenu.lua"

while true do
    System.PowerTick()
    dofile(nextscene)
    System.GC()
end