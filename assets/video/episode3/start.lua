local file = io.open("assets/saves/gp.txt", "r")
if file then
    gp = file:read("*l")
    file:close()
else
    gp = nil
end
if gp then
    local path = System.LoadData("assets/mainmenu/saves_bg.png")
    if path and gp then
        PMP.setVolume(pmpvolume)
        PMP.playEasy("assets/mainmenu/loading.pmp")
        nextscene = path.data
        return 1
    end
    if gp == "petra" then
        nextscene = "assets/video/episode3/petra/start.lua"
        return 1
    elseif gp == "gabriel" then
        nextscene = "assets/video/episode3/gabriel/start.lua"
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
                    else
                        gp = (input == "Yes") and "gabriel" or "petra"
                    end

                        if not gpexists then wr("gp", gp) end

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
