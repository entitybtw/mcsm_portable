sound.playEasy("assets/sounds/extras.wav", 17, false, false)
sound.volumeEasy(sound.WAV_1, uiLevel * 10)
sound.volumeEasy(5, 0)
local img = Image.load("assets/ui/extras.png") -- load image
local cloudtips = Image.load("assets/ui/qrcodes/cloudtips.png")
local extras_img = Image.load("assets/ui/qrcodes/extras.png")
local github = Image.load("assets/ui/qrcodes/github.png")
local entbtwgit = Image.load("assets/ui/qrcodes/entbtwgit.png")
local codeberg = Image.load("assets/ui/qrcodes/codeberg.png")
local gitlab = Image.load("assets/ui/qrcodes/gitlab.png")
local mirrors = false
local extras = false

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
if not extras and not mirrors then
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
end
if extras then
	intraFont.printShadowed(
	250,
	30,
	ui.extras_support,
	Color.new(255, 255, 153),
	Color.new(0, 0, 0),
	font,
	90,
	1,
	0.35,
	0
	)
	drawButtons()
	Image.draw(cloudtips, 350, 50, 70, 70)
	Image.draw(extras_img, 250, 50, 70, 70)

	intraFont.printShadowed(
		270 - intraFont.textW(font, ui.extras, 0.3) / 2 + 14,
		123,
		ui.extras,
		Color.new(255, 255, 255),
		Color.new(0, 0, 0),
		font,
		90,
		1,
		0.35,
		0
	)

	intraFont.printShadowed(
		370 - intraFont.textW(font, ui.support, 0.3) / 2 + 14,
		123,
		ui.support,
		Color.new(255, 255, 255),
		Color.new(0, 0, 0),
		font,
		90,
		1,
		0.35,
		0
	)
end
if mirrors then
	intraFont.printShadowed(
	220,
	45,
	ui.repos,
	Color.new(255, 255, 153),
	Color.new(0, 0, 0),
	font,
	90,
	1,
	0.35,
	0
	)
	drawButtons()
	Image.draw(entbtwgit, 220, 60, 60, 60)
	Image.draw(github, 285, 60, 60, 60)
	Image.draw(codeberg, 350, 60, 60, 60)
	Image.draw(gitlab, 415, 60, 60, 60)

	intraFont.printShadowed(
		240 - intraFont.textW(font, ui.entbtwgit, 0.3) / 2 + 14,
		120,
		ui.entbtwgit,
		Color.new(255, 255, 255),
		Color.new(0, 0, 0),
		font,
		90,
		1,
		0.25,
		0
	)

	intraFont.printShadowed(
		305 - intraFont.textW(font, ui.github, 0.3) / 2 + 14,
		120,
		ui.github,
		Color.new(255, 255, 255),
		Color.new(0, 0, 0),
		font,
		90,
		1,
		0.25,
		0
	)

	intraFont.printShadowed(
		370 - intraFont.textW(font, ui.codeberg, 0.3) / 2 + 14,
		120,
		ui.codeberg,
		Color.new(255, 255, 255),
		Color.new(0, 0, 0),
		font,
		90,
		1,
		0.25,
		0
	)

	intraFont.printShadowed(
		435 - intraFont.textW(font, ui.gitlab, 0.3) / 2 + 14,
		120,
		ui.gitlab,
		Color.new(255, 255, 255),
		Color.new(0, 0, 0),
		font,
		90,
		1,
		0.25,
		0
	)
end
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
			extras = false
			mirrors = true
		elseif selectedButton == 2 then
			sound.playEasy("assets/sounds/click.wav", sound.WAV_1, false, false)
			sound.volumeEasy(sound.WAV_1, uiLevel * 10)
			ui_enabled = false
			screen.flip()
			LUA.sleep(165)
			ui_enabled = true
			mirrors = false
			extras = true
		elseif selectedButton == 3 then
		Image.unload(img)
		
		Image.unload(cloudtips)
		Image.unload(extras_img)

		Image.unload(github)
		Image.unload(entbtwgit)
		Image.unload(codeberg)
		Image.unload(gitlab)
		sound.playEasy("assets/sounds/skeleton_1.wav", sound.WAV_1, false, false)
		sound.volumeEasy(sound.WAV_1, uiLevel * 10)
		fade_enabled = 1
		sound.volumeEasy(5, menumusic * 10)
		break
		end
	end

end
