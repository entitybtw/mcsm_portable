-- base made by dntrnk --

local in_interactive_zone = true
local choosing = true

local c_white = Color.new(255, 255, 255)

local bg = Image.load("assets/video/episode3/gabriel/choices/8/woolland.png")
local bg_levergabriel = Image.load("assets/video/episode3/gabriel/choices/8/woolland_levergabriel.png")


local square = Image.load("assets/icons/square.png")
local circle = Image.load("assets/icons/circle.png")
local cross = Image.load("assets/icons/cross.png")

local function playCutscene(videoPath, subtitlesPath)
    PMP.setVolume(pmpvolume)
    local result = PMP.playEasy(videoPath, buttons.r, true, subtitlesPath, font, subssize, "#FFFFFF", "#000000/150", subs)
    if result == 1 then
        choosing = false
        in_interactive_zone = false
        nextscene = "./mainmenu.lua"
    end
end

local fountain_used = false
local gabriel_talk = false
local reuben_talk = false
local leverreuben_used = false
local levergabriel_used = false

while in_interactive_zone do
    screen.clear()

    if not levergabriel_used then
        Image.draw(bg, 0, 0)
    elseif levergabriel_used then
        Image.draw(bg_levergabriel, 0, 0)
    end

    if not fountain_used then
        Image.draw(cross, 166, 131)
        intraFont.print(166 - intraFont.textW(font, "Fountain", 0.4) / 2 + 8, 131 + 14, "Fountain", Color.new(255,255,255), font, 0.4)
    end
    if not gabriel_talk then
        Image.draw(square, 394, 224)
        intraFont.print(394 - intraFont.textW(font, "Gabriel", 0.4) / 2 + 8, 224 + 14, "Gabriel", Color.new(255,255,255), font, 0.4)
    elseif gabriel_talk and not levergabriel_used then
        Image.draw(square, 394, 224)
        intraFont.print(394 - intraFont.textW(font, "Lever (Gabriel)", 0.4) / 2 + 8, 224 + 14, "Lever (Gabriel)", Color.new(255,255,255), font, 0.4)
    end
    if not reuben_talk then
        Image.draw(circle, 305, 135)
        intraFont.print(305 - intraFont.textW(font, "Reuben", 0.4) / 2 + 8, 135 + 14, "Reuben", Color.new(255,255,255), font, 0.4)
    elseif reuben_talk and not leverreuben_used then
        Image.draw(circle, 305, 135)
        intraFont.print(305 - intraFont.textW(font, "Lever (Reuben)", 0.4) / 2 + 8, 135 + 14, "Lever (Reuben)", Color.new(255,255,255), font, 0.4)
    end

    if levergabriel_used and leverreuben_used then
        Image.draw(circle, 126, 169)
        intraFont.print(126 - intraFont.textW(font, "Lukas", 0.4) / 2 + 8, 169 + 14, "Lukas", Color.new(255,255,255), font, 0.4)
    end


    intraFont.print(345 - 5 - intraFont.textW(font, "Press R to save", 0.63), 230, "Press R to save", Color.new(255,255,255, 150), font, 0.63)
    debugoverlay.draw(debugoverlay.loadSettings())

    screen.flip()

    choosing = true

    while choosing do
        buttons.read()

        if buttons.pressed(buttons.cross) then
            if not fountain_used then
                playCutscene("assets/video/episode3/gabriel/choices/8/fountain.pmp", "assets/video/episode3/gabriel/choices/8/fountain.srt")
                fountain_used = true
                choosing = false
            end
        elseif buttons.pressed(buttons.square) then
            if not gabriel_talk then
                playCutscene("assets/video/episode3/gabriel/choices/8/gabriel.pmp", "assets/video/episode3/gabriel/choices/8/gabriel.srt")
                gabriel_talk = true
                choosing = false
            elseif gabriel_talk and not levergabriel_used then
                playCutscene("assets/video/episode3/gabriel/choices/8/levergabriel.pmp", "assets/video/episode3/gabriel/choices/8/levergabriel.srt")
                levergabriel_used = true
                choosing = false
            end

        elseif buttons.pressed(buttons.circle) then
            if not reuben_talk then
                playCutscene("assets/video/episode3/gabriel/choices/8/reuben.pmp", "assets/video/episode3/gabriel/choices/8/reuben.srt")
                reuben_talk = true
                choosing = false
            elseif reuben_talk and not leverreuben_used then
                playCutscene("assets/video/episode3/gabriel/choices/8/leverreuben.pmp", "assets/video/episode3/gabriel/choices/8/leverreuben.srt")
                leverreuben_used = true
                choosing = false
            elseif leverreuben_used and levergabriel_used then
                nextscene = "assets/video/episode3/gabriel/choices/8/lukas.lua"
                in_interactive_zone = false
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

Image.unload(square)
Image.unload(circle)
Image.unload(cross)
Image.unload(bg)
Image.unload(bg_levergabriel)