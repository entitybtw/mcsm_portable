local animType = "r"
local curEp = 1
local tostring = tostring

local function getHighestSavedEpisode()
    local highestEp = 1
    local path = "assets/saves/"

    for i = 1, 8 do
        local saveFile = path .. tostring(i) .. "_save.txt"
        local file = io.open(saveFile, "r")
        if file then
            highestEp = i
            file:close()
        end
    end

    return highestEp
end

curEp = getHighestSavedEpisode()
PMP.setVolume(pmpvolume)
PMP.play("assets/mainmenu/epmenu/ep" .. tostring(curEp) .. ".pmp")

while true do
    buttons.read()

    if buttons.pressed(buttons["l"]) then
        animType = "l"
        if curEp ~= 1 then
            PMP.setVolume(pmpvolume)
            PMP.play("assets/mainmenu/epmenu/ep" .. tostring(curEp) .. "_" .. animType .. ".pmp")
            curEp = curEp - 1
        end
    end

    if buttons.pressed(buttons["r"]) then
        animType = "r"
        if curEp ~= 8 then
            PMP.setVolume(pmpvolume)
            PMP.play("assets/mainmenu/epmenu/ep" .. tostring(curEp) .. "_" .. animType .. ".pmp")
            curEp = curEp + 1
        end
    end

    if buttons.pressed(buttons["cross"]) then
        local epPath = "assets/video/episode" .. tostring(curEp) .. "/start.lua"
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
            PMP.play("assets/mainmenu/epmenu/ep" .. tostring(curEp) .. ".pmp")
        end
    elseif buttons.pressed(buttons["square"]) then
        local savePath = "assets/misc/saves_ep" .. tostring(curEp) .. ".lua"
        local file = io.open(savePath, "r")
        if file then
            file:close()
            dofile(savePath)
            PMP.setVolume(pmpvolume)
            PMP.play("assets/mainmenu/epmenu/ep" .. tostring(curEp) .. ".pmp")
        else
            dofile("assets/misc/not_yet.lua")
            PMP.setVolume(pmpvolume)
            PMP.play("assets/mainmenu/epmenu/ep" .. tostring(curEp) .. ".pmp")
        end
    elseif buttons.pressed(buttons["circle"]) then
        return 0
    end
end
