-- initialize variables
local animType = "r"
local curEp = 1

curEp = 1
PMP.setVolume(pmpvolume) -- setting video volume based on the volume set in the game settings
PMP.play("assets/mainmenu/epmenu/ep" .. curEp .. ".pmp") -- playing a video based on the current episode

while true do
    buttons.read()

    if buttons.pressed(buttons["l"]) then -- if you click L, move to the previous episode
        animType = "l"
        if curEp ~= 1 then
            PMP.setVolume(pmpvolume)
            PMP.play("assets/mainmenu/epmenu/ep" .. curEp .. "_" .. animType .. ".pmp") -- playing a video based on the current episode and the current animation
            curEp = curEp - 1
        end
    end

    if buttons.pressed(buttons["r"]) then -- if you click R, move to the next episode
        animType = "r"
        if curEp ~= 8 then
            PMP.setVolume(pmpvolume)
            PMP.play("assets/mainmenu/epmenu/ep" .. curEp .. "_" .. animType .. ".pmp")
            curEp = curEp + 1
        end
    end

    if buttons.pressed(buttons["cross"]) then -- if you click cross, episode starts
        local epPath = "assets/video/episode" .. curEp .. "/start.lua"
        local file = io.open(epPath, "r")
        if file then
            file:close()
            stop_sound(sound.MP3)
            fade_enabled = 1
            nextscene = epPath
            return 1
        else
            dofile("assets/misc/not_yet.lua")
            PMP.setVolume(pmpvolume)
            PMP.play("assets/mainmenu/epmenu/ep" .. curEp .. ".pmp")
        end
    elseif buttons.pressed(buttons["square"]) then
            if curEp == 1 then -- if the 1st episode is selected and the square button is pressed, a question appears about deleting key saves or regular saves
            System.message("Do you want to delete the save files for episode 1, or just the key save files? Save files - Yes, Key save files - No", 1) -- if you clicking yes, opens usual saves management menu, if you click no, all key saves are being deleted, if you click back it returns to episode menu
            local answer = System.buttonPressed()
            if answer == "Yes" then
	            System.DeleteData("assets/mainmenu/saves_bg.png")
                PMP.setVolume(pmpvolume)
                PMP.play("assets/mainmenu/epmenu/ep" .. curEp .. ".pmp")
            elseif answer == "No" then
                rm("bf", "gp", "em")
                PMP.setVolume(pmpvolume)
                PMP.play("assets/mainmenu/epmenu/ep" .. curEp .. ".pmp")
            elseif answer == "Back" then
                PMP.setVolume(pmpvolume)
                PMP.play("assets/mainmenu/epmenu/ep" .. curEp .. ".pmp")
            end
            if curEp ~= 1 then -- if an episode that is not the 1st is selected, the usual save management menu opens
                System.DeleteData("assets/mainmenu/saves_bg.png")
                PMP.setVolume(pmpvolume)
                PMP.play("assets/mainmenu/epmenu/ep" .. curEp .. ".pmp")
            end
    end
    elseif buttons.pressed(buttons["circle"]) then
        return 0
    end
end
