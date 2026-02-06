local ep1 = "assets/video/episode1/"
local choices = {
    choice0 = {
        path = ep1 .. "start",
        leftchoice = "100 chicken-sized\n \n       zombie",
        rightchoice = "10 zombie-sized\n \n       chickens",
        leftchoicefilename = "100_chicken_sized",
        rightchoicefilename = "10_zombie_sized",
        leftchoicestate = nil,
        rightchoicestate = nil,
        nextchoice = "choice1"
    },
    
    choice1 = {
        path = ep1 .. "choices/",
        leftchoice = "Cool Mask",
        rightchoice = "Not funny, Axel",
        leftchoicefilename = "cool_mask",
        rightchoicefilename = "not_funny_axel",
        leftchoicestate = nil,
        rightchoicestate = nil,
        nextchoice = "choice2"
    },
    
    choice2 = {
        path = ep1 .. "choices/1",
        leftchoice = "Build a Creeper!",
        rightchoice = "Build an Enderman!",
        leftchoicefilename = "build_a_creeper",
        rightchoicefilename = "build_a_enderman",
        leftchoicestate = nil,
        rightchoicestate = nil,
        nextchoice = nil
    }
}

-- Глобальные переменные для сборки
_G.build = nil

-- Начинаем с первого выбора
local currentchoice = choices.choice0
PMP.setVolume(pmpvolume)

-- ГЛАВНЫЙ ЦИКЛ ВЫБОРОВ
while currentchoice do
    local choosing = true
    
    -- 1. Играем видео текущего выбора
    local result = PMP.playEasy(currentchoice.path .. '.pmp', buttons.r, true, 
                                currentchoice.path .. ".srt", font, subssize, 
                                "#FFFFFF", "#000000/150", subs)
    if result == 1 then
        nextscene = "./mainmenu.lua"
        return 1
    end
    
    -- 2. Показываем варианты выбора для ЭТОГО видео
    Image.draw(square, 25, 127)
    Image.draw(circle, 455, 127)
    intraFont.print(45, 127, currentchoice.leftchoice, Color.new(255,255,255), font, 0.4)
    intraFont.print(450 - intraFont.textW(font, currentchoice.rightchoice, 0.4), 127, 
                   currentchoice.rightchoice, Color.new(255,255,255), font, 0.4)
    intraFont.print(340 - intraFont.textW(font, "Press R to save", 0.63), 230, 
                   "Press R to save", Color.new(255,255,255, 150), font, 0.63)
    debugoverlay.draw(debugoverlay.loadSettings())
    screen.flip()
    
    -- 3. Ожидаем выбора игрока
    while choosing do
        buttons.read()

        if buttons.pressed(buttons.square) then
            choosing = false
            currentchoice.leftchoicestate = "done"
            
            -- Проверяем специальные условия
            if currentchoice.leftchoicefilename == "build_a_creeper" then
                _G.build = "creeper"
            end
            
            -- Сохраняем выбранный путь для следующего воспроизведения
            _G.lastChoicePath = ep1 .. currentchoice.leftchoicefilename
            
        elseif buttons.pressed(buttons.circle) then
            choosing = false
            currentchoice.rightchoicestate = "done"
            
            if currentchoice.rightchoicefilename == "build_a_enderman" then
                _G.build = "enderman"
            end
            
            _G.lastChoicePath = ep1 .. currentchoice.rightchoicefilename
            
        elseif buttons.pressed(buttons.start) then
            choosing = false
            local pause = dofile("assets/misc/pause.lua")
            if pause == -1 then 
                nextscene = "./mainmenu.lua" 
                return
            end
            choosing = true
            
        elseif buttons.pressed(buttons.r) then
            choosing = false
            SaveGame(1)
            choosing = true
        end
    end
    
    -- 4. Переходим к следующему выбору (если есть)
    if currentchoice.nextchoice then
        currentchoice = choices[currentchoice.nextchoice]
        -- Если есть сохраненный путь от предыдущего выбора, используем его
        if _G.lastChoicePath then
            currentchoice.path = _G.lastChoicePath
            _G.lastChoicePath = nil  -- очищаем после использования
        end
    else
        -- Конец ветки
        currentchoice = nil
    end
end

print("Ветка завершена!")
if _G.build then
    print("Игрок собрал: " .. _G.build)
end