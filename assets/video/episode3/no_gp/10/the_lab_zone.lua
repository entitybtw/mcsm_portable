-- base made by dntrnk --

local in_interactive_zone = true
local choosing = true

local c_white = Color.new(255, 255, 255)

local bg = Image.load("assets/video/episode3/no_gp/10/the_lab.png")

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

local exit1_used = false
local olivia_talk = false
local chest_used = false
local area_1_search = false
local upstairs_search = false
local area_2_search = false


while in_interactive_zone do
    screen.clear()

    Image.draw(bg, 0, 0)

    if not exit1_used and not chest_used or area_1_search and area_2_search and upstairs_search then
        Image.draw(cross, 445, 179)
        intraFont.print(445 - intraFont.textW(font, "Exit", 0.4) / 2 + 8, 179 + 14, "Exit", Color.new(255,255,255), font, 0.4)
    elseif chest_used and not upstairs_search then
        Image.draw(cross, 344, 31)
        intraFont.print(344 - intraFont.textW(font, "Search upstairs", 0.4) / 2 + 8, 31 + 14, "Search upstairs", Color.new(255,255,255), font, 0.4)
    end

    if not area_1_search and chest_used then
        Image.draw(square, 144, 170)
        intraFont.print(144 - intraFont.textW(font, "Search Area 1", 0.4) / 2 + 8, 170 + 14, "Search Area 1", Color.new(255,255,255), font, 0.4)
    elseif not olivia_talk then
        Image.draw(square, 62, 203)
        intraFont.print(62 - intraFont.textW(font, "Olivia", 0.4) / 2 + 8, 203 + 14, "Olivia", Color.new(255,255,255), font, 0.4)
    end

    if not area_2_search and chest_used then
        Image.draw(circle, 310, 177)
        intraFont.print(310 - intraFont.textW(font, "Search Area 2", 0.4) / 2 + 8, 177 + 14, "Search Area 2", Color.new(255,255,255), font, 0.4)
    elseif not chest_used then
        Image.draw(circle, 155, 171)
        intraFont.print(155 - intraFont.textW(font, "Chest", 0.4) / 2 + 8, 171 + 14, "Chest", Color.new(255,255,255), font, 0.4)
    end


    intraFont.print(340 - intraFont.textW(font, "Press R to save", 0.63), 230, "Press R to save", Color.new(255,255,255, 150), font, 0.63)
    debugoverlay.draw(debugoverlay.loadSettings())

    screen.flip()

    choosing = true

    while choosing do
        buttons.read()

        if buttons.pressed(buttons.cross) then
            if not exit1_used and not chest_used then
                playCutscene("assets/video/episode3/no_gp/10/exit.pmp", "assets/video/episode3/no_gp/10/exit.srt")
                exit1_used = true
                choosing = false
            elseif area_1_search and area_2_search and upstairs_search then
                nextscene = "assets/video/episode3/no_gp/10/exit2.lua"
                in_interactive_zone = false
                choosing = false
            elseif not upstairs_search and chest_used then
                playCutscene("assets/video/episode3/no_gp/10/search_upstairs.pmp", "assets/video/episode3/no_gp/10/search_upstairs.srt")
                upstairs_search = true
                choosing = false
            end
        elseif buttons.pressed(buttons.square) then
            if not area_1_search and chest_used then
                playCutscene("assets/video/episode3/no_gp/10/search_area1.pmp", "assets/video/episode3/no_gp/10/search_area1.srt")
                area_1_search = true
                choosing = false
            elseif not olivia_talk then
                playCutscene("assets/video/episode3/no_gp/10/olivia.pmp", "assets/video/episode3/no_gp/10/olivia.srt")
                olivia_talk = true
                choosing = false
            end

        elseif buttons.pressed(buttons.circle) then
            if not area_2_search and chest_used then
                playCutscene("assets/video/episode3/no_gp/10/search_area2.pmp", "assets/video/episode3/no_gp/10/search_area2.srt")
                area_2_search = true
                choosing = false
            elseif not chest_used then
                playCutscene("assets/video/episode3/no_gp/10/chest.pmp", "assets/video/episode3/no_gp/10/chest.srt")
                chest_used = true
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