-- made by dntrnk --
-- p.s dntrnk реально молодец (от entitybtw) --

local in_interactive_zone = true
local choosing = true

local c_white = Color.new(255, 255, 255)

local bg = Image.load("assets/video/episode5/choices/no_mi/1/throne_room_bg.png")

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

local bookcase_used = false
local cobblestone_collected = false
local dry_bush_collected = false
local strange_wall_used = false
local crafting_table_used = false

while in_interactive_zone do
    screen.clear()

    Image.draw(bg, 0, 0)

    if not bookcase_used then
        Image.draw(square, 59, 160)
        intraFont.print(59 - intraFont.textW(font, "Bookcase", 0.4) / 2 + 8, 160 + 14, "Bookcase", c_white, font, 0.4)
    end

    Image.draw(circle, 397, 166)
    if not strange_wall_used then
        if mi == "milo" then intraFont.print(397 - intraFont.textW(font, "Strange Wall", 0.4) / 2 + 8, 166 + 14, "Strange Wall", c_white, font, 0.4) elseif mi == "ivor" then intraFont.print(397 - intraFont.textW(font, "Supply Door", 0.4) / 2 + 8, 166 + 14, "Supply Door", c_white, font, 0.4) end
    else
        intraFont.print(397 - intraFont.textW(font, "Lever Slot", 0.4) / 2 + 8, 166 + 14, "Lever Slot", c_white, font, 0.4)
    end

    if not cobblestone_collected then
        Image.draw(triangle, 144, 203)
        intraFont.print(144 - intraFont.textW(font, "Cobblestone", 0.4) / 2 + 8, 203 + 14, "Cobblestone", c_white, font, 0.4)
    end

    if not dry_bush_collected then
        Image.draw(cross, 282, 207)
        intraFont.print(282 - intraFont.textW(font, "Dry Bush", 0.4) / 2 + 8, 207 + 14, "Dry Bush", c_white, font, 0.4)
    elseif cobblestone_collected and not crafting_table_used then
        Image.draw(cross, 282, 207)
        intraFont.print(282 - intraFont.textW(font, "Crafting Table", 0.4) / 2 + 8, 207 + 14, "Crafting Table", Color.new(255,255,255), font, 0.4)
    end

    intraFont.print(345 - 5 - intraFont.textW(font, "Press R to save", 0.63), 230, "Press R to save", Color.new(255,255,255, 150), font, 0.63)
    debugoverlay.draw(debugoverlay.loadSettings())

    screen.flip()

    choosing = true

    while choosing do
        buttons.read()

        if buttons.pressed(buttons.square) then
            if not bookcase_used then
                playCutscene("assets/video/episode5/choices/no_mi/1/bookcase.pmp", "assets/video/episode5/choices/no_mi/1/bookcase.srt")
                bookcase_used = true
                choosing = false
            end
        elseif buttons.pressed(buttons.circle) then
            if not strange_wall_used then
                if mi == "milo" then playCutscene("assets/video/episode5/choices/no_mi/1/strange_wall.pmp", "assets/video/episode5/choices/no_mi/1/strange_wall.srt") elseif mi == "ivor" then playCutscene("assets/video/episode5/choices/no_mi/1/supply_door.pmp", "assets/video/episode5/choices/no_mi/1/supply_door.srt") end
                strange_wall_used = true
                choosing = false
            elseif crafting_table_used then
                nextscene = "assets/video/episode5/choices/no_mi/1/lever_slot_2.lua"
                in_interactive_zone = false
                choosing = false
            else
                playCutscene("assets/video/episode5/choices/no_mi/1/lever_slot_1.pmp", "assets/video/episode5/choices/no_mi/1/lever_slot_1.srt")
                choosing = false
            end

        elseif buttons.pressed(buttons.triangle) then
            if not cobblestone_collected then
                playCutscene("assets/video/episode5/choices/no_mi/1/cobblestone.pmp", "assets/video/episode5/choices/no_mi/1/cobblestone.srt")
                cobblestone_collected = true
                choosing = false
            end
        elseif buttons.pressed(buttons.cross) then
            if not dry_bush_collected then
                playCutscene("assets/video/episode5/choices/no_mi/1/dry_bush.pmp", "assets/video/episode5/choices/no_mi/1/dry_bush.srt")
                dry_bush_collected = true
                choosing = false
            elseif cobblestone_collected and dry_bush_collected and not crafting_table_used then
                playCutscene("assets/video/episode5/choices/no_mi/1/crafting_table.pmp", "assets/video/episode5/choices/no_mi/1/crafting_table.srt")
                crafting_table_used = true
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
