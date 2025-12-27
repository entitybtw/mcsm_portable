-- base made by dntrnk --

local in_interactive_zone = true
local choosing = true

local c_white = Color.new(255, 255, 255)

local bg = Image.load("assets/video/episode4/magnus_gabriel/choices/16/ivors_house.png")


local function goToMenu()
    nextscene = "./mainmenu.lua"
    in_interactive_zone = false
end

local function playCutscene(videoPath, subtitlesPath)
    PMP.setVolume(pmpvolume)
    local result = PMP.playEasy(videoPath, buttons.r, true, subtitlesPath, font, subssize, "#FFFFFF", "#000000/150", subs)
    if result == 1 then
        choosing = false
        in_interactive_zone = false
        nextscene = "./mainmenu.lua"
    end
end

local bookcase_used = false
local redstone_hole_used = false
local chest_used = false
local crafting_table_used = false
local put_lever = false
local petra_talk = false

while in_interactive_zone do
    screen.clear()

    Image.draw(bg, 0, 0)

    if not bookcase_used then
        Image.draw(circle, 126, 169)
        intraFont.print(126 - intraFont.textW(font, "Bookcase", 0.4) / 2 + 8, 169 + 14, "Bookcase", Color.new(255,255,255), font, 0.4)
    end

    if not chest_used then
        Image.draw(square, 272, 119)
        intraFont.print(272 - intraFont.textW(font, "Chest", 0.4) / 2 + 8, 119 + 14, "Chest", Color.new(255,255,255), font, 0.4)
    elseif chest_used and not crafting_table_used then
        Image.draw(square, 289, 119)
        intraFont.print(289 - intraFont.textW(font, "Crafting Table", 0.4) / 2 + 8, 119 + 14, "Crafting Table", Color.new(255,255,255), font, 0.4)
    end

    if not redstone_hole_used and not crafting_table_used then
        Image.draw(triangle, 397, 147)
        intraFont.print(397 - intraFont.textW(font, "Redstone Hole", 0.4) / 2 + 8, 147 + 14, "Redstone Hole", Color.new(255,255,255), font, 0.4)
    end

    if not petra_talk then
        Image.draw(cross, 210, 169)
        intraFont.print(210 - intraFont.textW(font, "Petra", 0.4) / 2 + 8, 169 + 14, "Petra", Color.new(255,255,255), font, 0.4)
    end
    
    if crafting_table_used and not put_lever then
        Image.draw(square, 393, 146)
        intraFont.print(393 - intraFont.textW(font, "Put lever", 0.4) / 2 + 8, 146 + 14, "Put lever", Color.new(255,255,255), font, 0.4)
    elseif put_lever then
        Image.draw(square, 393, 146)
        intraFont.print(393 - intraFont.textW(font, "Lever", 0.4) / 2 + 8, 146 + 14, "Lever", Color.new(255,255,255), font, 0.4)
    end

    intraFont.print(340 - intraFont.textW(font, "Press R to save", 0.63), 230, "Press R to save", Color.new(255,255,255, 150), font, 0.63)
    debugoverlay.draw(debugoverlay.loadSettings())

    screen.flip()

    choosing = true

    while choosing do
        buttons.read()

        if buttons.pressed(buttons.circle) then
            if not bookcase_used then
                playCutscene("assets/video/episode4/magnus_gabriel/choices/16/bookcase.pmp", "assets/video/episode4/magnus_gabriel/choices/16/bookcase.srt")
                bookcase_used = true
                choosing = false
            end
        elseif buttons.pressed(buttons.square) then
            if not chest_used then
                playCutscene("assets/video/episode4/magnus_gabriel/choices/16/chest.pmp", "assets/video/episode4/magnus_gabriel/choices/16/chest.srt")
                chest_used = true
                choosing = false
            elseif chest_used and not crafting_table_used then
                playCutscene("assets/video/episode4/magnus_gabriel/choices/16/crafting_table.pmp", "assets/video/episode4/magnus_gabriel/choices/16/crafting_table.srt")
                crafting_table_used = true
                choosing = false
            elseif crafting_table_used and not put_lever then
                playCutscene("assets/video/episode4/magnus_gabriel/choices/16/put_lever.pmp", "assets/video/episode4/magnus_gabriel/choices/16/put_lever.srt")
                put_lever = true
                choosing = false
            elseif put_lever then
                rm("ivors_house_variables")
                nextscene = "assets/video/episode4/magnus_gabriel/choices/16/lever.lua"
                in_interactive_zone = false
                choosing = false
            end            
        elseif buttons.pressed(buttons.triangle) then
            if not redstone_hole_used and not crafting_table_used then
                playCutscene("assets/video/episode4/magnus_gabriel/choices/16/redstone_hole.pmp", "assets/video/episode4/magnus_gabriel/choices/16/redstone_hole.srt")
                redstone_hole_used = true
                choosing = false
            end
        elseif buttons.pressed(buttons.cross) then
            if not petra_talk then
                petra_talk = true
                choosing = false
                local petraExitCode = dofile("assets/video/episode4/magnus_gabriel/choices/16/petra.lua")
                if petraExitCode == 1 then
                    goToMenu()
                end
            end
        elseif buttons.pressed(buttons.start) then
            local pause = dofile("assets/misc/pause.lua")
            choosing = false
            if pause == -1 then
                goToMenu()
            end
        elseif buttons.pressed(buttons.r) then
            choosing = false
            SaveGame(5)
        end
    end
end

Image.unload(bg)
