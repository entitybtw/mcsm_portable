sound.playEasy("assets/sounds/stuff.wav", sound.WAV_1, false, false)
sound.volumeEasy(sound.WAV_1, uiLevel * 10)
sound.volumeEasy(5, 0)
local img = Image.load("assets/ui/support.png") -- load image

local buttonsList = {
	{ text = "repo mirrors" },
	{ text = "extras / support me" },
	{ text = "close"}
}

local selectedButton = 1
local buttonSprites = {
	selected = { srcx = 0, srcy = 164, srcw = 183, srch = 25 },
	static = { srcx = 184, srcy = 165, srcw = 183, srch = 25 },
}

local function drawButtons()
    local startX, startY, gap = 250, 180, 3
    for i, button in ipairs(buttonsList) do
        local sprite = (i == selectedButton) and buttonSprites.selected or buttonSprites.static
        
        -- Параметры растяжения для первой кнопки
        local scaleY = 1
        local y = startY + (i - 1) * (sprite.srch + gap)
        
        if i == 1 then
            scaleY = 1.4  -- растягиваем первую кнопку по высоте
            y = startY - 10  -- поднимаем её выше (Y меньше)
        end
        
        -- Отрисовка спрайта с учетом растяжения
        Image.draw(
            spritesheet,
            startX,
            y,
            sprite.srcw,           -- ширина без изменений
            sprite.srch * scaleY,  -- высота растянута
            nil,
            sprite.srcx,
            sprite.srcy,
            sprite.srcw,
            sprite.srch,
            nil,
            nil,
            nil
        )
        
        -- Текст с учетом растяжения
        local scale = 0.3
        local textScale = (i == 1) and (scale * scaleY) or scale  -- текст тоже растягиваем немного
        local textColor = (i == selectedButton) and Color.new(255, 255, 153) or Color.new(255, 255, 255)
        local textWidth = intraFont.textW(font, button.text, textScale)
        local textHeight = intraFont.textH(font) * textScale
        
        intraFont.printShadowed(
            startX + (sprite.srcw - textWidth) / 2,
            y + (sprite.srch * scaleY - textHeight) / 4,
            button.text,
            textColor,
            Color.new(0, 0, 0),
            font,
            90,
            1,
            textScale,
            0
        )
    end
end

screen.clear()
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()

while true do
Image.draw(img, 0, 0) -- draw image
intraFont.printShadowed(
	250,
	30,
	ui.header,
	Color.new(255, 255, 153),
	Color.new(0, 0, 0),
	font,
	90,
	1,
	0.35,
	0
	)
intraFont.printShadowed(
	250,
	50,
	ui.description,
	Color.new(255, 255, 255),
	Color.new(0, 0, 0),
	font,
	90,
	1,
	0.35,
	0
	)
	drawButtons()
	screen.flip()
	buttons.read()

	if buttons.pressed(buttons.up) and selectedButton > 1 then
		selectedButton = selectedButton - 1
		sound.playEasy("assets/sounds/select.wav", sound.WAV_1, false, false)
		sound.volumeEasy(sound.WAV_1, uiLevel * 10)
	end
	if buttons.pressed(buttons.down) and selectedButton < #buttonsList then
		selectedButton = selectedButton + 1
		sound.playEasy("assets/sounds/select.wav", sound.WAV_1, false, false)
		sound.volumeEasy(sound.WAV_1, uiLevel * 10)
	end

	if buttons.pressed(buttons.cross) then
		if selectedButton == 1 then
			sound.playEasy("assets/sounds/click.wav", sound.WAV_1, false, false)
			sound.volumeEasy(sound.WAV_1, uiLevel * 10)
			ui_enabled = false
			screen.flip()
			LUA.sleep(165)
			ui_enabled = true
			dofile("assets/misc/pause_controls.lua")
		elseif selectedButton == 2 then
			sound.playEasy("assets/sounds/click.wav", sound.WAV_1, false, false)
			sound.volumeEasy(sound.WAV_1, uiLevel * 10)
			ui_enabled = false
			screen.flip()
			LUA.sleep(165)
			ui_enabled = true
			dofile("assets/misc/pause_audio_video.lua")
		elseif selectedButton == 3 then
		Image.unload(img)
		sound.playEasy("assets/sounds/skeleton_1.wav", sound.WAV_1, false, false)
		sound.volumeEasy(sound.WAV_1, uiLevel * 10)
		fade_enabled = 1
		sound.volumeEasy(5, menumusic * 10)
		break
		end
	end

end
