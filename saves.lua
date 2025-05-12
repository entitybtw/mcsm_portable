function SaveGame(episodeNumber)
    System.SaveData(nextscene, episodeNumber .. " episode save", "Minecraft Story Mode Save", "EBOOT.PBP", "EBOOT.PBP", "assets/mainmenu/saves_bg.png")
    PMP.play('assets/mainmenu/lsave.pmp')
end

function checkFile(filePath, globalVarName)
    local file = io.open(filePath, "r")
    if not file then return false end
    local content = file:read("*l")
    file:close()
    _G[globalVarName] = content
    return true
end
