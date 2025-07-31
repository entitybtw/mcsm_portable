local file = io.open("assets/saves/em.txt", "r")
if file then
    em = file:read("*l")
    file:close()
else
    em = nil
end
file = io.open("assets/saves/gp.txt", "r")
if file then
    gp = file:read("*l")
    file:close()
else
    gp = nil
end
file = io.open("assets/saves/bf.txt", "r")
if file then
    bf = file:read("*l")
    file:close()
else
    bf = nil
end
if em and gp and bf then
    if em == "ellegaard" then
        nextscene = "assets/video/episode2/ellegaard/start.lua"
        return 1
    elseif em == "magnus" then
        nextscene = "assets/video/episode2/magnus/start.lua"
        return 1
    end
local path = System.LoadData("assets/mainmenu/saves_bg.png")
if path and em and gp and bf then
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
        System.message("Key data for episode 1 not found, do you want to start episode choice setup?", 1)
        local episodeChoiceResponse = System.buttonPressed()
        local bfexists = fileExists("assets/saves/bf.txt")
        local emexists = fileExists("assets/saves/em.txt")
        local gpexists = fileExists("assets/saves/gp.txt")
        if episodeChoiceResponse == "Yes" then
            local step = 1
            local gp, bf, em
            while true do
                screen.clear()

                if step == 1 then
                    if not gpexists then
                    System.message("What would you like to save? Gabriel = Yes, Petra = No", 1)
                    local input = System.buttonPressed()
                    if input == "Back" then
                    break
                    else
                        gp = (input == "Yes") and "gabriel" or "petra"
                        step = 2
                    end
                else
                    step = 2
                end

                elseif step == 2 then
                    if not bfexists then
                    System.message("What would you like to craft? Fishing Pole = Yes, Bow = No", 1)
                    local input = System.buttonPressed()
                    if input == "Back" then
                        step = 1
                    else
                        bf = (input == "Yes") and "fishing_pole" or "bow"
                        step = 3
                    end
                else
                    step = 3
                end

                elseif step == 3 then
                    if not emexists then
                    System.message("Go for Magnus = Yes, Go for Ellegaard = No", 1)
                    local input = System.buttonPressed()
                    if input == "Back" then
                        step = 2
                    else
                        em = (input == "Yes") and "magnus" or "ellegaard"
                        if not gpexists then wr("gp", gp) end
                        if not bfexists then wr("bf", bf) end
                        if not emexists then wr("em", em) end
                        screen.flip()
                        return 1
                    end
                else

                        if not gpexists then wr("gp", gp) end
                        if not bfexists then wr("bf", bf) end
                        if not emexists then wr("em", em) end

                        screen.flip()
                        return 1
                    end
                end
                screen.flip()
            end

        elseif episodeChoiceResponse == "No" or episodeChoiceResponse == "Back" then
dofile("assets/misc/pause.lua")
            screen.flip()
            break
        end

        screen.flip()
    end
end
