checkFile("assets/saves/gp.txt", "gp")
local choosing = true
local square = Image.load("assets/icons/square.png")
local circle = Image.load("assets/icons/circle.png")

PMP.setVolume(pmpvolume)
PMP.playEasy('assets/video/episode2/magnus/choices/7/pink_wool/1/youre_going_down.pmp', buttons.r, true, 'assets/video/episode2/magnus/choices/7/pink_wool/1/youre_going_down.srt', font, subssize, "#FFFFFF", "#000000/150", subs)

Image.draw(square, 25, 127)
Image.draw(circle, 455, 127)
intraFont.print(25 + 15 + 5, 127, "Hello Boom Town", Color.new(255,255,255), font, 0.4)
intraFont.print(455 - 5 - intraFont.textW(font, "Who likes explosions?", 0.4), 127, "Who likes explosions?", Color.new(255,255,255), font, 0.4)
debugoverlay.draw(debugoverlay.loadSettings())
screen.flip()

while choosing do
    buttons.read()

    if buttons.pressed(buttons.square) then
Image.unload(square)
Image.unload(circle)
        choosing = false
        if gp == "gabriel" then
            nextscene =  "assets/video/episode2/magnus/choices/7/pink_wool/2/hello_boom_town.lua"
        elseif gp == "petra" then
            nextscene = "assets/video/episode2/magnus_petra/pink_wool/hello_boom_town.lua"
        end
    elseif buttons.pressed(buttons.circle) then
Image.unload(square)
Image.unload(circle)
        choosing = false
        if gp == "gabriel" then
            nextscene =  "assets/video/episode2/magnus/choices/7/pink_wool/2/who_likes_explosions.lua"
        elseif gp == "petra" then
            nextscene = "assets/video/episode2/magnus_petra/pink_wool/who_likes_explosions.lua"
        end
    elseif buttons.pressed(buttons.l) then
Image.unload(square)
Image.unload(circle)
        choosing = false
        nextscene =  "./mainmenu.lua"
    elseif buttons.pressed(buttons.start) then
Image.unload(square)
Image.unload(circle)
        choosing = false
        SaveGame(2)
        nextscene =  "./mainmenu.lua"
    end

end
