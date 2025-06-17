-- initialize variables
local animType = "r"
curEp = 1
local latestContinue = 0

if not fileExists("assets/saves/lastep.txt") then
    wr("lastep", 1)
else
    lastEp = tonumber(cnt("assets/saves/lastep.txt"))
    curEp = lastEp
end

function hasStart(ep)
    local f = io.open("assets/video/episode" .. ep .. "/start.lua", "r")
    if f then f:close() return true else return false end
end

local function getStatus(animType, curEp)
    local epIndex = animType == "l" and curEp - 1 or curEp + 1
    local statusVar = _G["status_" .. epIndex]
    if statusVar ~= nil then
        return "_" .. statusVar
    else
        return hasStart(epIndex) and "_start" or "_soon"
    end
end

function getStatusForEpisode(ep)
    local statusVar = _G["status_" .. ep]
    if statusVar ~= nil then
        return "_" .. statusVar
    else
        return hasStart(ep) and "_start" or "_soon"
    end
end

for i = 1, 5 do
    _G["status_" .. i] = nil
end

for i = 1, 5 do
    if hasStart(i) then
        local s = cnt("assets/saves/" .. i .. "_status.txt")
        if s == "continue" or s == "restart" or s == "start" then
            _G["status_" .. i] = s
        else
            _G["status_" .. i] = "start"
        end
    else
        _G["status_" .. i] = "soon"
    end
end

for i = 1, 5 do
    if _G["status_" .. i] == "continue" then
        latestContinue = i
    end
end

for i = 1, latestContinue - 1 do
    _G["status_" .. i] = "restart"
    wr(i .. "_status", "restart")
end

PMP.setVolume(pmpvolume) -- setting video volume based on the volume set in the game settings
PMP.play("assets/mainmenu/epmenu/ep" .. curEp .. getStatusForEpisode(curEp) .. ".pmp") -- playing a video based on the current episode
while true do
    buttons.read()

    if buttons.pressed(buttons["l"]) then -- if you click L, move to the previous episode
        animType = "l"
        if curEp ~= 1 then
            status = getStatus(animType, curEp)
            PMP.setVolume(pmpvolume)
            PMP.play("assets/mainmenu/epmenu/ep" .. curEp .. "_" .. animType .. status .. ".pmp") -- playing a video based on the current episode and the current animation
            curEp = curEp - 1
        end
    end

    if buttons.pressed(buttons["r"]) then -- if you click R, move to the next episode
        animType = "r"
        if curEp ~= 5 then
            status = getStatus(animType, curEp)
            PMP.setVolume(pmpvolume)
            PMP.play("assets/mainmenu/epmenu/ep" .. curEp .. "_" .. animType .. status .. ".pmp")
            curEp = curEp + 1
        end
    end

    if buttons.pressed(buttons["cross"]) then -- if you click cross, episode starts
        if hasStart(curEp) then
            local epPath = "assets/video/episode" .. curEp .. "/start.lua"
            stop_sound(sound.MP3)
            fade_enabled = 1
            wr("lastep", tostring(curEp))
            nextscene = epPath
            return 1
        end
    end

    if buttons.pressed(buttons["square"]) then
        if curEp ~= 1 then
            System.DeleteData("assets/mainmenu/saves_bg.png")
            rm(curEp .. "_status")
            _G["status_" .. curEp] = "start"
            wr(curEp .. "_status", "start")
            PMP.setVolume(pmpvolume)
            PMP.play("assets/mainmenu/epmenu/ep" .. curEp .. getStatusForEpisode(curEp) .. ".pmp")
        end
        if curEp == 1 then -- if the 1st episode is selected and the square button is pressed, a question appears about deleting key saves or regular saves
            System.message("Do you want to delete the save files for episode 1, or just the key save files? Save files - Yes, Key save files - No", 1) -- if you clicking yes, opens usual saves management menu, if you click no, all key saves are being deleted, if you click back it returns to episode menu
            local answer = System.buttonPressed()
            if answer == "Yes" then
                System.DeleteData("assets/mainmenu/saves_bg.png")
                rm("1_status")
                rm("1_variables")
                status_1 = "start"
                PMP.setVolume(pmpvolume)
                PMP.play("assets/mainmenu/epmenu/ep1_start.pmp")
            elseif answer == "No" then
                rm("bf", "gp", "em")
                PMP.setVolume(pmpvolume)
                PMP.play("assets/mainmenu/epmenu/ep1_start.pmp")
            elseif answer == "Back" then
                PMP.setVolume(pmpvolume)
                PMP.play("assets/mainmenu/epmenu/ep1_start.pmp")
            end
        end
    end

    if buttons.pressed(buttons["circle"]) then
        wr("lastep", tostring(curEp))
        return 0
    end
end
