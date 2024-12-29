-- Загрузка начальной картинки
local choosing = true
local img = Image.load('assets/video/episode1/START.png')

-- Воспроизведение стартового видео
PMP.play('assets/video/episode1/START.pmp', buttons.r)

-- Отрисовка картинки после окончания видео
screen.clear()
Image.draw(img, 0, 0)
screen.flip()

-- Основной игровой цикл
while choosing do
    -- Считывание состояния кнопок
    buttons.read()

    -- Проверка нажатий
    if buttons.pressed(buttons.square) then
        -- Если нажата кнопка Square, воспроизводим 100 zombie-sized chickens
        Image.unload(img)
        choosing = false
        dofile("assets/video/episode1/100_chicken.lua")
    elseif buttons.pressed(buttons.circle) then
        -- Если нажата кнопка Circle, воспроизводим 10 chicken-sized zombies
        Image.unload(img)
        choosing = false
        dofile("assets/video/episode1/10_zombie.lua")
    elseif buttons.pressed(buttons.l) then
        Image.unload(img)
        choosing = false
	dofile("./mainmenu.lua")
    end

end
