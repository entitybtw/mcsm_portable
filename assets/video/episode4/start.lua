local file = io.open("assets/saves/ema.txt", "r")
if file then
    ema = file:read("*l")
    file:close()
else
    ema = nil
end
file = io.open("assets/saves/gp.txt", "r")
if file then
    gp = file:read("*l")
    file:close()
else
    gp = nil
end

if ema and gp then
    if ema == "ellegaard" then
        nextscene = "assets/video/episode4/ellegaard_" .. gp .. "/start.lua"
        return 1
    elseif ema == "magnus" then
        nextscene = "assets/video/episode4/magnus_" .. gp .. "/start.lua"
        return 1
    end
local path = System.LoadData("assets/mainmenu/saves_bg.png")
if path and ema and gp then
    PMP.setVolume(pmpvolume)
local result =     PMP.playEasy("assets/mainmenu/loading.pmp")
if result == 1 then
    nextscene = "./mainmenu.lua"
    return 1
end
    nextscene = path.data
    return 1
end
else
    while true do
        screen.clear()
        System.message("Key data not found, do you want to start episode choice setup?", 1)
        local episodeChoiceResponse = System.buttonPressed()
        local emaexists = fileExists("assets/saves/ema.txt")
        local gpexists = fileExists("assets/saves/gp.txt")
        if episodeChoiceResponse == "Yes" then
            local step = 1
            local gp, ema
            while true do
                screen.clear()

                if step == 1 then
                    if not gpexists then
                    System.message("What would you like to save? Gabriel = Yes, Petra = No", 1)
                    local input = System.buttonPressed()
                    if input == "Back" then
                    else
                        gp = (input == "Yes") and "gabriel" or "petra"
                        step = 2
                    end
                else
                    step = 2
                end

                elseif step == 2 then
                    if not emaexists then
                    System.message("Take Ellegaard`s armor = Yes, Take Magnus` armor = No", 1)
                    local input = System.buttonPressed()
                    if input == "Back" then
                        step = 1
                    else
                        ema = (input == "Yes") and "ellegaard" or "magnus"
                        if not gpexists then wr("gp", gp) end
                        if not emaexists then wr("ema", ema) end
                        screen.flip()
                        return 1
                    end
                else
                        if not gpexists then wr("gp", gp) end
                        if not emaexists then wr("ema", em) end

                        screen.flip()
                        return 1
                    end
                end
                screen.flip()
            end

        elseif episodeChoiceResponse == "No" or episodeChoiceResponse == "Back" then
dofile("./mainmenu.lua")
            screen.flip()
        end

        screen.flip()
    end
end
