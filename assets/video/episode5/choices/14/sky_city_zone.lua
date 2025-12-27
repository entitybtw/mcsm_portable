-- base made by dntrnk --

local in_interactive_zone = true
local choosing = true

local c_white = Color.new(255, 255, 255)

local bg_1 = Image.load("assets/video/episode5/choices/14/sky_city_exploration_1.png")
local bg_2 = Image.load("assets/video/episode5/choices/14/sky_city_exploration_2.png")
local bg_3 = Image.load("assets/video/episode5/choices/14/sky_city_exploration_3.png")


local function playCutscene(videoPath, subtitlesPath)
    PMP.setVolume(pmpvolume)
    local result = PMP.playEasy(videoPath, buttons.r, true, subtitlesPath, font, subssize, "#FFFFFF", "#000000/150", subs)
    if result == 1 then
        choosing = false
        in_interactive_zone = false
        nextscene = "./mainmenu.lua"
    end
end

local sky_city_1_explored = false
local castle_guard_talk = false
local sky_city_2_explored = false
local townspeople_talk = false


while in_interactive_zone do
    screen.clear()

    if not sky_city_1_explored then
        Image.draw(bg_1, 0, 0)
    elseif sky_city_1_explored and not sky_city_2_explored then
        Image.draw(bg_2, 0, 0)
    elseif sky_city_2_explored and sky_city_1_explored then
        Image.draw(bg_3, 0, 0)
    end

    if not sky_city_1_explored then
        Image.draw(cross, 140, 134)
        intraFont.print(140 - intraFont.textW(font, "Crafting Table", 0.4) / 2 + 8, 134 + 14, "Crafting Table", Color.new(255,255,255), font, 0.4)
        Image.draw(triangle, 417, 145)
        intraFont.print(417 - intraFont.textW(font, "Garden", 0.4) / 2 + 8, 145 + 14, "Garden", Color.new(255,255,255), font, 0.4)
    end

    if sky_city_1_explored and not castle_guard_talk then
        Image.draw(cross, 100, 70)
        intraFont.print(100 - intraFont.textW(font, "Castle Guard", 0.4) / 2 + 8, 70 + 14, "Castle Guard", Color.new(255,255,255), font, 0.4)
    end
    if not sky_city_2_explored and sky_city_1_explored then
        Image.draw(triangle, 417, 60)
        intraFont.print(417 - intraFont.textW(font, "Build site", 0.4) / 2 + 8, 60 + 14, "Build Site", Color.new(255,255,255), font, 0.4)
    end

    if sky_city_2_explored and not townspeople_talk then
        Image.draw(triangle, 330, 140)
        intraFont.print(330 - intraFont.textW(font, "Townspeople", 0.4) / 2 + 8, 140 + 14, "Townspeople", Color.new(255,255,255), font, 0.4)
    end

    if sky_city_2_explored then
        Image.draw(cross, 115, 145)
        intraFont.print(115 - intraFont.textW(font, "Innkeeper", 0.4) / 2 + 8, 145 + 14, "Innkeeper", Color.new(255,255,255), font, 0.4)
    end


    intraFont.print(340 - intraFont.textW(font, "Press R to save", 0.63), 230, "Press R to save", Color.new(255,255,255, 150), font, 0.63)
    debugoverlay.draw(debugoverlay.loadSettings())

    screen.flip()

    choosing = true

    while choosing do
        buttons.read()

        if buttons.pressed(buttons.cross) then
            if not sky_city_1_explored then
                playCutscene("assets/video/episode5/choices/14/crafting_table.pmp", "assets/video/episode5/choices/14/crafting_table.srt")
                sky_city_1_explored = true
                choosing = false
            elseif sky_city_1_explored and not castle_guard_talk then
                playCutscene("assets/video/episode5/choices/14/castle_guard.pmp", "assets/video/episode5/choices/14/castle_guard.srt")
                castle_guard_talk = true
                choosing = false
            elseif sky_city_2_explored then
                nextscene = "assets/video/episode5/choices/14/innkeeper.lua"
                in_interactive_zone = false
                choosing = false
            end

        elseif buttons.pressed(buttons.triangle) then
            if not sky_city_1_explored then
                playCutscene("assets/video/episode5/choices/14/garden.pmp", "assets/video/episode5/choices/14/garden.srt")
                sky_city_1_explored = true
                choosing = false
            elseif sky_city_2_explored and not townspeople_talk then
                playCutscene("assets/video/episode5/choices/14/townspeople.pmp", "assets/video/episode5/choices/14/townspeople.srt")
                townspeople_talk = true
                choosing = false
            elseif not sky_city_2_explored and sky_city_1_explored then
                playCutscene("assets/video/episode5/choices/14/build_site.pmp", "assets/video/episode5/choices/14/build_site.srt")
                sky_city_2_explored = true
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

Image.unload(bg_1)
Image.unload(bg_2)
Image.unload(bg_3)