-- base made by dntrnk --

local in_interactive_zone = true
local choosing = true

local c_white = Color.new(255, 255, 255)

local bg = Image.load("assets/video/episode2/ellegaard/choices/2/redstonia_bg.png")
local bg_fight = Image.load("assets/video/episode2/ellegaard/choices/2/redstonia_bg_fight.png")

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

local chest_used = false
local autofarm_used = false
local fight = false
local intellectual_talk = false
local redstonia_bg = "redstonia"


while in_interactive_zone do
    screen.clear()

    if redstonia_bg == "redstonia" then Image.draw(bg, 0, 0) elseif redstonia_bg == "redstonia_fight" then Image.draw(bg_fight, 0, 0) end

    if not autofarm_used then
        Image.draw(cross, 125, 216)
        intraFont.print(125 - intraFont.textW(font, "Autofarm", 0.4) / 2 + 8, 216 + 14, "Autofarm", Color.new(255,255,255), font, 0.4)
    end

    if not intellectual_talk then
        Image.draw(circle, 344, 167)
        intraFont.print(344 - intraFont.textW(font, "Intellectual", 0.4) / 2 + 8, 167 + 14, "Intellectual", Color.new(255,255,255), font, 0.4)
    elseif not fight then
        Image.draw(circle, 383, 197)
        intraFont.print(383 - intraFont.textW(font, "School Boy", 0.4) / 2 + 8, 197 + 14, "School Boy", Color.new(255,255,255), font, 0.4)
    elseif fight then
        Image.draw(circle, 404, 161)
        intraFont.print(404 - intraFont.textW(font, "Steal Repeater", 0.4) / 2 + 8, 161 + 14, "Steal Repeater", Color.new(255,255,255), font, 0.4)
    end

    if not chest_used then
        Image.draw(square, 160, 173)
        intraFont.print(160 - intraFont.textW(font, "Chest", 0.4) / 2 + 8, 173 + 14, "Chest", Color.new(255,255,255), font, 0.4)
    elseif autofarm_used and chest_used then
        Image.draw(square, 241, 210)
        intraFont.print(241 - intraFont.textW(font, "Crafting Table", 0.4) / 2 + 8, 210 + 14, "Crafting Table", Color.new(255,255,255), font, 0.4)
    end

    intraFont.print(345 - 5 - intraFont.textW(font, "Press R to save", 0.63), 230, "Press R to save", Color.new(255,255,255, 150), font, 0.63)
    debugoverlay.draw(debugoverlay.loadSettings())

    screen.flip()

    choosing = true

    while choosing do
        buttons.read()

        if buttons.pressed(buttons.cross) then
            if not autofarm_used then
                playCutscene("assets/video/episode2/ellegaard/choices/2/autofarm.pmp", "assets/video/episode2/ellegaard/choices/2/autofarm.srt")
                autofarm_used = true
                choosing = false
            elseif not autofarm_used and intellectual_talk then
                playCutscene("assets/video/episode2/ellegaard/choices/2/autofarm_fight.pmp", "assets/video/episode2/ellegaard/choices/2/autofarm_fight.srt")
                autofarm_used = true
                choosing = false
            end
        elseif buttons.pressed(buttons.square) then
            if not chest_used then
                playCutscene("assets/video/episode2/ellegaard/choices/2/chest.pmp", "assets/video/episode2/ellegaard/choices/2/chest.srt")
                chest_used = true
                choosing = false
            elseif not chest_used and intellectual_talk then
                playCutscene("assets/video/episode2/ellegaard/choices/2/chest_fight.pmp", "assets/video/episode2/ellegaard/choices/2/chest_fight.srt")
                chest_used = true
                choosing = false
            elseif autofarm_used and chest_used then
                nextscene = "assets/video/episode2/ellegaard/choices/2/crafting_table.lua"
                in_interactive_zone = false
                choosing = false
            end

        elseif buttons.pressed(buttons.circle) then
            if not intellectual_talk then
                playCutscene("assets/video/episode2/ellegaard/choices/2/Intellectual.pmp", "assets/video/episode2/ellegaard/choices/2/Intellectual.srt")
                intellectual_talk = true
                choosing = false
            elseif not fight then
                playCutscene("assets/video/episode2/ellegaard/choices/2/schoolboy.pmp", "assets/video/episode2/ellegaard/choices/2/schoolboy.srt")
                fight = true
                redstonia_bg = "redstonia_fight"
                choosing = false
            elseif fight then
                nextscene = "assets/video/episode2/ellegaard/choices/2/steal_repeater.lua"
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
Image.unload(triangle)
Image.unload(cross)
Image.unload(bg)
Image.unload(bg_fight)