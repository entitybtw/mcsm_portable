-- base made by dntrnk --

local in_interactive_zone = true
local choosing = true

local c_white = Color.new(255, 255, 255)

local bg = Image.load("assets/video/episode3/gabriel/choices/16/loot_room_zone.png")
local bg_button = Image.load("assets/video/episode3/gabriel/choices/16/loot_room_zone_button.png")


local function playCutscene(videoPath, subtitlesPath)
    PMP.setVolume(pmpvolume)
    local result = PMP.playExt(videoPath, buttons.r, true, subtitlesPath, font, subssize, "#FFFFFF", "#000000/150", subs)
    if result == 1 then
        choosing = false
        in_interactive_zone = false
        nextscene = "./mainmenu.lua"
    end
end

local button_used = false
local lukas_talk = false
local olivia_talk = false
local axel_talk = false


while in_interactive_zone do
    screen.clear()

    if not button_used then
        Image.draw(bg, 0, 0)
    elseif button_used then
        Image.draw(bg_button, 0, 0)
    end

    if not button_used then
        Image.draw(spritesheet, 224, 64, 15, 15, nil, 414, 0, 15, 15)
        intraFont.print(224 - intraFont.textW(font, choices_three.button, 0.4) / 2 + 8, 64 + 14, choices_three.button, Color.new(255,255,255), font, 0.4)
    elseif button_used then
        Image.draw(spritesheet, 321, 131, 15, 15, nil, 414, 0, 15, 15)
        intraFont.print(321 - intraFont.textW(font, choices_three.chest, 0.4) / 2 + 8, 131 + 14, choices_three.chest, Color.new(255,255,255), font, 0.4)
    end

    if not olivia_talk then
        Image.draw(spritesheet, 171, 132, 15, 15, nil, 430, 0, 15, 15)
        intraFont.print(171 - intraFont.textW(font, choices_three.olivia, 0.4) / 2 + 8, 132 + 14, choices_three.olivia, Color.new(255,255,255), font, 0.4)
    end
    if not lukas_talk then
        Image.draw(spritesheet, 277, 80, 15, 15, nil, 399, 0, 15, 15)
        intraFont.print(277 - intraFont.textW(font, choices_three.lukas, 0.4) / 2 + 8, 80 + 14, choices_three.lukas, Color.new(255,255,255), font, 0.4)
    end
    if not axel_talk then
        Image.draw(spritesheet, 341, 195, 15, 15, nil, 384, 0, 15, 15)
        intraFont.print(341 - intraFont.textW(font, choices_three.axel, 0.4) / 2 + 8, 195 + 14, choices_three.axel, Color.new(255,255,255), font, 0.4)
    end


    intraFont.print(345 - 5 - intraFont.textW(font, "Press R to save", 0.63), 230, "Press R to save", Color.new(255,255,255, 150), font, 0.63)
    debugoverlay.draw(debugoverlay.loadSettings())

    screen.flip()

    choosing = true

    while choosing do
        buttons.read()

        if buttons.pressed(buttons.square) then
            if not button_used then
                playCutscene("assets/video/episode3/gabriel/choices/16/button.pmp", "assets/subtitles/episode3/gabriel/choices/16/button.srt")
                button_used = true
                choosing = false
            elseif button_used then
                nextscene = "assets/video/episode3/gabriel/choices/16/chest.lua"
                in_interactive_zone = false
                choosing = false
            end
        elseif buttons.pressed(buttons.cross) then
            if not lukas_talk then
                if not button_used then playCutscene("assets/video/episode3/gabriel/choices/16/lukas.pmp", "assets/subtitles/episode3/gabriel/choices/16/lukas.srt") elseif button_used then playCutscene("assets/video/episode3/gabriel/choices/16/lukas_button.pmp", "assets/subtitles/episode3/gabriel/choices/16/lukas_button.srt") end
                lukas_talk = true
                choosing = false
            end

        elseif buttons.pressed(buttons.circle) then
            if not axel_talk then
                if not button_used then playCutscene("assets/video/episode3/gabriel/choices/16/axel.pmp", "assets/subtitles/episode3/gabriel/choices/16/axel.srt") elseif button_used then playCutscene("assets/video/episode3/gabriel/choices/16/axel_button.pmp", "assets/subtitles/episode3/gabriel/choices/16/axel_button.srt") end
                axel_talk = true
                choosing = false
            end

        elseif buttons.pressed(buttons.triangle) then
            if not olivia_talk then
                if not button_used then playCutscene("assets/video/episode3/gabriel/choices/16/olivia.pmp", "assets/subtitles/episode3/gabriel/choices/16/olivia.srt") elseif button_used then playCutscene("assets/video/episode3/gabriel/choices/16/olivia_button.pmp", "assets/subtitles/episode3/gabriel/choices/16/olivia_button.srt") end
                olivia_talk = true
                choosing = false
            end

        elseif buttons.pressed(buttons.start) then
            local pause = dofile("assets/misc/pause.lua")
            choosing = false
            if pause == -1 then
                nextscene = "./mainmenu.lua"
                in_interactive_zone = false
            end
        elseif buttons.pressed(buttons.r) then
            choosing = false
            SaveGame(5)
        end
    end
end

Image.unload(bg)
Image.unload(bg_button)
