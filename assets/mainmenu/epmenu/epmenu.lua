local loop = true
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
PMP.play("assets/mainmenu/epmenu/ep" .. tostring(curEp) .. ".pmp")

while loop do
    buttons.read()

    if buttons.pressed(buttons.l) then
        animType = "l"
        if curEp ~= 1 then
            PMP.play("assets/mainmenu/epmenu/ep" .. tostring(curEp) .. "_" .. animType .. ".pmp")
            curEp = curEp - 1
        end
    end

    if buttons.pressed(buttons.r) then
        animType = "r"
        if curEp ~= 8 then
            PMP.play("assets/mainmenu/epmenu/ep" .. tostring(curEp) .. "_" .. animType .. ".pmp")
            curEp = curEp + 1
        end
    end

    if buttons.pressed(buttons.cross) then
        loop = false
        screen.clear()
        if curEp < 2 then
            stop_sound(sound.MP3)
            fade_enabled = 1
            dofile("assets/video/episode" .. tostring(curEp) .. "/start.lua")
        else
            dofile("assets/misc/not_yet.lua")
        end
    end

    if buttons.pressed(buttons.square) then
        screen.clear()
        loop = false
        if curEp < 2 then
            dofile("assets/misc/saves_ep" .. tostring(curEp) .. ".lua")
        else
            dofile("assets/misc/not_yet.lua")
        end
    end

    if buttons.pressed(buttons.circle) then
        loop = false
        dofile("./mainmenu.lua")
    end
end
