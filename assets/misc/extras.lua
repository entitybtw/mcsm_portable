sound.playEasy("assets/sounds/extras.wav", 17, false, false, uiLevel * 10)
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
local fade = 255
local c_black = Color.new(0, 0, 0)

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

local buttonGlobalScaleX = 0.9
local buttonGlobalScaleY = 0.9

-- Настройки позиции текста для разных кнопок
local textOffset = {
    firstButton = {
        x = 0,
        y = -5
    },
    otherButtons = {
        x = 0,
        y = -5
    }
}

local function drawButtons()
    local startX, startY, gap = 250, 180, 3
    for i, button in ipairs(buttonsList) do
        local sprite = (i == selectedButton) and buttonSprites.selected or buttonSprites.static
        
        local finalScaleX = buttonGlobalScaleX
        local finalScaleY = buttonGlobalScaleY
        
        if i == 1 then
            finalScaleY = finalScaleY * 1.4
        end
        
        local buttonHeight = sprite.srch * finalScaleY
        local buttonWidth = sprite.srcw * finalScaleX
        
        local y = startY + (i - 1) * (buttonHeight + gap)
        
        if i == 1 then
            y = startY - 10
        end
        
        Image.draw(
            spritesheet,
            startX, y,
            buttonWidth, buttonHeight,
            nil,
            sprite.srcx, sprite.srcy,
            sprite.srcw, sprite.srch
        )
        
        local textScaleX = 0.3 * buttonGlobalScaleX
        local textScaleY = 0.3 * finalScaleY
        
        local textColor = (i == selectedButton) and Color.new(255, 255, 153) or Color.new(255, 255, 255)
        local textWidth = intraFont.textW(font, button.text, textScaleX)
        local textHeight = intraFont.textH(font) * textScaleY
        
        local baseTextX = startX + (buttonWidth - textWidth) / 2
        local baseTextY = y + (buttonHeight - textHeight) / 2
        
        local textX, textY
        if i == 1 then
            textX = baseTextX + textOffset.firstButton.x
            textY = baseTextY + textOffset.firstButton.y
        else
            textX = baseTextX + textOffset.otherButtons.x
            textY = baseTextY + textOffset.otherButtons.y
        end
        
        intraFont.printShadowed(
            textX, textY,
            button.text,
            textColor,
            Color.new(0, 0, 0),
            font, 90, 1,
            textScaleX, textScaleY
        )
    end
end

-- Fade in эффект при входе
screen.clear()
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()

-- Fade in анимация
fade = 255
while fade > 0 do
    screen.clear()
    Image.draw(img, 0, 0)
    if not extras and not mirrors then
        intraFont.printShadowed(
            250, 30, ui.header,
            Color.new(255, 255, 153),
            Color.new(0, 0, 0),
            font, 90, 1, 0.35, 0
        )
        intraFont.printShadowed(
            250, 50, ui.description,
            Color.new(255, 255, 255),
            Color.new(0, 0, 0),
            font, 90, 1, 0.35, 0
        )
        drawButtons()
    end
    screen.filledRect(0, 0, 480, 272, c_black, 0, fade)
    screen.flip()
    fade = fade - 8
end

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
	sound.playEasy("assets/sounds/select.wav", sound.WAV_1, false, false, uiLevel * 10)
	end
	if buttons.pressed(buttons.down) and selectedButton < #buttonsList then
		selectedButton = selectedButton + 1
	sound.playEasy("assets/sounds/select.wav", sound.WAV_1, false, false, uiLevel * 10)
	end

	if buttons.pressed(buttons.cross) then
		if selectedButton == 1 then
			sound.playEasy("assets/sounds/click.wav", sound.WAV_1, false, false, uiLevel * 10)
			extras = false
			mirrors = true
		elseif selectedButton == 2 then
			sound.playEasy("assets/sounds/click.wav", sound.WAV_1, false, false, uiLevel * 10)
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
		sound.playEasy("assets/sounds/skeleton_1.wav", sound.WAV_1, false, false, uiLevel * 10)
		fade_enabled = 1
		sound.volumeEasy(5, menumusic * 10)
		videoFrame = PMP.play("assets/ui/mcsm_mainmenu.pmp", true, nil, nil, 29.97)
		break
		end
	end

end