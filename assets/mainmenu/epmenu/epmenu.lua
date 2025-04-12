local animType = "r"
local curEp = 1 -- currentEpisode
local tostring = tostring

-- Функция для получения самого большого номера эпизода с сохранением
local function getHighestSavedEpisode()
    local highestEp = 1
    local path = "assets/saves/"

    for i = 1, 8 do -- Предположим, что у нас максимум 8 эпизодов
        local saveFile = path .. tostring(i) .. "_save.txt"
        local file = io.open(saveFile, "r")
        if file then
            highestEp = i
            file:close()
        end
    end

    return highestEp
end

-- Устанавливаем текущий эпизод на основе сохранений
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
        if curEp < 2 then
            stop_sound(sound.MP3)
            fade_enabled = 1
            nextscene = "assets/video/episode" .. tostring(curEp) .. "/start.lua"
            return 1
        else
            dofile("assets/misc/not_yet.lua")
            animType = "r"
            curEp = 1
PMP.setVolume(pmpvolume)
            PMP.play("assets/mainmenu/epmenu/ep" .. tostring(curEp) .. "_" .. animType .. ".pmp")
        end
    elseif buttons.pressed(buttons["square"]) then
        if curEp < 2 then
            dofile("assets/misc/saves_ep" .. tostring(curEp) .. ".lua")
            animType = "r"
            curEp = 1
PMP.setVolume(pmpvolume)
            PMP.play("assets/mainmenu/epmenu/ep" .. tostring(curEp) .. ".pmp")
        else
            dofile("assets/misc/not_yet.lua")
            animType = "r"
            curEp = 1
PMP.setVolume(pmpvolume)
            PMP.play("assets/mainmenu/epmenu/ep" .. tostring(curEp) .. ".pmp")
        end
    elseif buttons.pressed(buttons["circle"]) then
        return 0
    end
end
