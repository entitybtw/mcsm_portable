local path = System.LoadData("assets/mainmenu/saves_bg.png")
-- local font = intraFont.load('assets/minecraft.pgf')
if path then
    PMP.setVolume(pmpvolume)
    PMP.playEasy("assets/mainmenu/loading.pmp")
    nextscene = path.data

    local variablesFile = io.open("assets/saves/1_variables.txt", "r")
    if variablesFile then
        for line in variablesFile:lines() do
            local key, value = line:match("^(%w+) = \"([^\"]+)\"$")
            if key and value then
                _G[key] = value
            end
        end
        variablesFile:close()
    end
    return 1
end

local square = Image.load('assets/icons/square.png')
local circle = Image.load('assets/icons/circle.png')
PMP.setVolume(pmpvolume)
PMP.playEasy('assets/mainmenu/lsave.pmp')
PMP.setVolume(pmpvolume)
PMP.playEasy('assets/video/episode1/START.pmp', buttons.r, true, "assets/video/episode1/start.srt", font, subssize, "#FFFFFF", "#000000/150", subs)

Image.draw(square, 25, 127)
Image.draw(circle, 455, 127)
intraFont.print(25 + 15 + 5, 127, "100 chicken-sized\n \n       zombies", Color.new(255,255,255), font, 0.4)
intraFont.print(455 - 5 - intraFont.textW(font, "10 zombie-sized\n \n       chickens", 0.4), 127, "10 zombie-sized\n \n       chickens", Color.new(255,255,255), font, 0.4)
intraFont.print(345 - 5 - intraFont.textW(font, "Press R to save", 0.63), 230, "Press R to save", Color.new(255,255,255, 150), font, 0.63)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()

while true do
    buttons.read()
    if buttons.pressed(buttons.square) then
        Image.unload(square)
        Image.unload(circle)
        nextscene =  "assets/video/episode1/100_chicken_sized.lua"
        break
    elseif buttons.pressed(buttons.circle) then
        Image.unload(square)
        Image.unload(circle)
        nextscene =  "assets/video/episode1/10_zombie_sized.lua"
        break
    elseif buttons.pressed(buttons.start) then
        Image.unload(square)
        Image.unload(circle)
dofile("assets/misc/pause.lua")
        break
    end

end
