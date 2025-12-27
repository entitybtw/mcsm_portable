-- base made by dntrnk --

local in_interactive_zone = true
local choosing = true

local c_white = Color.new(255, 255, 255)

local bg = Image.load("assets/video/episode1/choices/6/the_woods_zone.png")

local square = Image.load("assets/icons/square.png")
local circle = Image.load("assets/icons/circle.png")
local cross = Image.load("assets/icons/cross.png")
local triangle = Image.load("assets/icons/triangle.png")

local function playCutscene(videoPath, subtitlesPath)
    PMP.setVolume(pmpvolume)
    local result = PMP.playEasy(videoPath, buttons.r, true, subtitlesPath, font, subssize, "#FFFFFF", "#000000/150", subs)
    if result == 1 then
        choosing = false
        in_interactive_zone = false
        nextscene = "./mainmenu.lua"
    end
end

local bush_used = false
local pigs_used = false
local water_well_used = false
local smoke_trail_used = false


while in_interactive_zone do
    screen.clear()

    Image.draw(bg, 0, 0)

    if not smoke_trail_used then
        Image.draw(cross, 257, 136)
        intraFont.print(257 - intraFont.textW(font, "Smoke Trail", 0.4) / 2 + 8, 136 + 14, "Smoke Trail", Color.new(255,255,255), font, 0.4)
    elseif smoke_trail_used then
        Image.draw(cross, 201, 130)
        intraFont.print(201 - intraFont.textW(font, "Tall Grass", 0.4) / 2 + 8, 130 + 14, "Tall Grass", Color.new(255,255,255), font, 0.4)
    end

    if not pigs_used then
        Image.draw(triangle, 389, 193)
        intraFont.print(389 - intraFont.textW(font, "Pigs", 0.4) / 2 + 8, 193 + 14, "Pigs", Color.new(255,255,255), font, 0.4)
    end
    if not bush_used then
        Image.draw(square, 88, 63)
        intraFont.print(88 - intraFont.textW(font, "Bush", 0.4) / 2 + 8, 63 + 14, "Bush", Color.new(255,255,255), font, 0.4)
    end
    if not water_well_used then
        Image.draw(circle, 95, 167)
        intraFont.print(95 - intraFont.textW(font, "Water Well", 0.4) / 2 + 8, 167 + 14, "Water Well", Color.new(255,255,255), font, 0.4)
    end


    intraFont.print(340 - intraFont.textW(font, "Press R to save", 0.63), 230, "Press R to save", Color.new(255,255,255, 150), font, 0.63)
    debugoverlay.draw(debugoverlay.loadSettings())

    screen.flip()

    choosing = true

    while choosing do
        buttons.read()

        if buttons.pressed(buttons.cross) then
            if not smoke_trail_used then
                playCutscene("assets/video/episode1/choices/6/smoke_trail.pmp", "assets/video/episode1/choices/6/smoke_trail.srt")
                smoke_trail_used = true
                choosing = false
            elseif smoke_trail_used then
                nextscene = "assets/video/episode1/choices/6/tall_grass.lua"
                in_interactive_zone = false
                choosing = false
            end
        elseif buttons.pressed(buttons.square) then
            if not bush_used then
                playCutscene("assets/video/episode1/choices/6/bush.pmp", "assets/video/episode1/choices/6/bush.srt")
                bush_used = true
                choosing = false
            end

        elseif buttons.pressed(buttons.circle) then
            if not water_well_used then
                playCutscene("assets/video/episode1/choices/6/water_well.pmp", "assets/video/episode1/choices/6/water_well.srt")
                water_well_used = true
                choosing = false
            end

        elseif buttons.pressed(buttons.triangle) then
            if not pigs_used then
                playCutscene("assets/video/episode1/choices/6/pigs.pmp", "assets/video/episode1/choices/6/pigs.srt")
                pigs_used = true
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
Image.unload(triangle)
Image.unload(cross)
Image.unload(bg)