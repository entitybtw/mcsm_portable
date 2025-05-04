checkFile("assets/saves/em.txt", "em")

if em == "ellegaard" then
    nextscene = "assets/video/episode2/ellegaard/start.lua"
    return 1
elseif em == "magnus" then
    nextscene = "assets/video/episode2/magnus/start.lua"
    return 1
else
    System.message("saves not found, do you want to rewind to this episode?", 1)
end
