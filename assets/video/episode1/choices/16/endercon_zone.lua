-- base made by dntrnk --

local in_interactive_zone = true
local choosing = true

local c_white = Color.new(255, 255, 255)

local bg = Image.load("assets/video/episode1/choices/16/endercon_zone.png")

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

local slime_used = false
local chicken_machine_used = false
local crafting_table_used = false


while in_interactive_zone do
    screen.clear()

    Image.draw(bg, 0, 0)

    if not slime_used then
        Image.draw(circle, 141, 139)
        intraFont.print(141 - intraFont.textW(font, "Slime", 0.4) / 2 + 8, 139 + 14, "Slime", Color.new(255,255,255), font, 0.4)
    end
    if not chicken_machine_used then
        Image.draw(square, 221, 122)
        intraFont.print(221 - intraFont.textW(font, "Chicken Machine", 0.4) / 2 + 8, 122 + 14, "Chicken Machine", Color.new(255,255,255), font, 0.4)
    elseif chicken_machine_used then
        Image.draw(square, 221, 122)
        intraFont.print(221 - intraFont.textW(font, "Chicken Machine 2", 0.4) / 2 + 8, 122 + 14, "Chicken Machine 2", Color.new(255,255,255), font, 0.4)
    end

    if slime_used and not crafting_table_used then
        Image.draw(circle, 334, 153)
        intraFont.print(334 - intraFont.textW(font, "Crafting Table", 0.4) / 2 + 8, 153 + 14, "Crafting Table", Color.new(255,255,255), font, 0.4)
    end
    if slime_used then
        Image.draw(cross, 141, 139)
        intraFont.print(141 - intraFont.textW(font, "Lukas", 0.4) / 2 + 8, 139 + 14, "Lukas", Color.new(255,255,255), font, 0.4)
    end


    intraFont.print(340 - intraFont.textW(font, "Press R to save", 0.63), 230, "Press R to save", Color.new(255,255,255, 150), font, 0.63)
    debugoverlay.draw(debugoverlay.loadSettings())

    screen.flip()

    choosing = true

    while choosing do
        buttons.read()

        if buttons.pressed(buttons.cross) then
            if slime_used then
                nextscene = "assets/video/episode1/choices/16/lukas.lua"
                in_interactive_zone = false
                choosing = false
            end
        elseif buttons.pressed(buttons.square) then
            if not chicken_machine_used then
                playCutscene("assets/video/episode1/choices/16/chicken_machine.pmp", "assets/video/episode1/choices/16/chicken_machine.srt")
                chicken_machine_used = true
                choosing = false
            elseif chicken_machine_used then
                playCutscene("assets/video/episode1/choices/16/chicken_machine_2.pmp", "assets/video/episode1/choices/16/chicken_machine_2.srt")
                choosing = false
            end

        elseif buttons.pressed(buttons.circle) then
            if not slime_used then
                playCutscene("assets/video/episode1/choices/16/slime.pmp", "assets/video/episode1/choices/16/slime.srt")
                slime_used = true
                choosing = false
            elseif slime_used and not crafting_table_used then
                playCutscene("assets/video/episode1/choices/16/crafting_table.pmp", "assets/video/episode1/choices/16/crafting_table.srt")
                crafting_table_used = true
                choosing = false
            end

        elseif buttons.pressed(buttons.triangle) then
            if not pigs_used then
                playCutscene("assets/video/episode1/choices/16/pigs.pmp", "assets/video/episode1/choices/16/pigs.srt")
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