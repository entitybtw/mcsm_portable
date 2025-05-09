local bg = Image.load('assets/mainmenu/saves_menu.png')
local noSavesImage = Image.load('assets/mainmenu/no_saves_found.png')

local buttonsList = {}

-- List of save files for the first episode
local saveFiles = {
    "2_save.txt",
}

-- Preload imgs for submenus
local submenuImages = {
    EDIT_STATIC = Image.load("assets/buttons/EDIT_ENG_STATIC.png"),
    EDIT_SELECTED = Image.load("assets/buttons/EDIT_ENG_SELECTED.png"),
    REMOVE_STATIC = Image.load("assets/buttons/REMOVE_ENG_STATIC.png"),
    REMOVE_SELECTED = Image.load("assets/buttons/REMOVE_ENG_SELECTED.png"),
    BACK_STATIC = Image.load("assets/buttons/BACK_ENG_STATIC.png"),
    BACK_SELECTED = Image.load("assets/buttons/BACK_ENG_SELECTED.png")
}

-- Function for loading save files
local function loadsavefiles()
    buttonsList = {}
    for _, fileName in ipairs(saveFiles) do
        local modifiedFileName = fileName:gsub("%.txt$", "_txt")
        local filePath = string.format("assets/saves/%s", fileName)

        local file = io.open(filePath, "rb")
        if file then
            file:close()

            local button = {
                normalImage = Image.load(string.format("assets/buttons/%s_static.png", modifiedFileName)),
                selectedImage = Image.load(string.format("assets/buttons/%s_selected.png", modifiedFileName)),
                fileName = fileName
            }
            table.insert(buttonsList, button)
        end
    end
end

loadsavefiles()

local selectedButton = 1
local submenuActive = false
local mainMenuActive = true
local submenuOptions = { "EDIT", "REMOVE", "BACK" }
local selectedSubmenuOption = 1

local function drawButtons()
    for i, button in ipairs(buttonsList) do
        local x = 25
        local y = 35 + (i - 1) * 60

        if mainMenuActive and i == selectedButton then
            Image.draw(button.selectedImage, x, y, 200, 50)
        else
            Image.draw(button.normalImage, x, y, 200, 50)
        end
    end
end

local function drawSubmenu()
    for i, option in ipairs(submenuOptions) do
        local x = 260
        local y = 35 + (i - 1) * 30

        if submenuActive and i == selectedSubmenuOption then
            Image.draw(submenuImages[option .. "_SELECTED"], x, y)
        else
            Image.draw(submenuImages[option .. "_STATIC"], x, y)
        end
    end
end

local function unloadResources()
    for _, button in ipairs(buttonsList) do
        Image.unload(button.normalImage)
        Image.unload(button.selectedImage)
    end

    for _, image in pairs(submenuImages) do
        Image.unload(image)
    end

    Image.unload(bg)
    Image.unload(noSavesImage)
end

while true do
    screen.clear()
    buttons.read()

    Image.draw(bg, 0, 0)

    if #buttonsList == 0 then
        -- If no saves found, show no saves image and START button
        Image.draw(noSavesImage, 0, 0)
        
        if buttons.pressed(buttons.start) then
            break
        end
    else
        if submenuActive then
            if buttons.pressed(buttons.up) and selectedSubmenuOption > 1 then
                selectedSubmenuOption = selectedSubmenuOption - 1
            end

            if buttons.pressed(buttons.l) then
                submenuActive = false
            end

            if buttons.pressed(buttons.down) and selectedSubmenuOption < #submenuOptions then
                selectedSubmenuOption = selectedSubmenuOption + 1
            end

            if buttons.pressed(buttons.cross) then
                local selectedOption = submenuOptions[selectedSubmenuOption]
                local fileName = buttonsList[selectedButton].fileName

                if selectedOption == "EDIT" then
                    local filePath = "assets/saves/" .. fileName
                    local currentContent = ""

                    local file = io.open(filePath, "r")
                    if file then
                        currentContent = file:read("*all")
                        file:close()
                    end

                    local newContent = System.OSK(currentContent, "Edit content of the file: " .. fileName)
                    if newContent and newContent ~= "" then
                        wr(fileName:gsub("%.txt$", ""), newContent)
                        print("File edited successfully: " .. fileName)
                    else
                        print("Editing cancelled or no input provided.")
                    end
                elseif selectedOption == "REMOVE" then
                    rm(fileName:gsub("%.txt$", ""))
                    loadsavefiles()
                    submenuActive = false
                elseif selectedOption == "BACK" then
                    submenuActive = false
                    unloadResources()
                    break
                end
            end

            drawButtons()
            drawSubmenu()
        else
            if buttons.pressed(buttons.up) and selectedButton > 1 then
                selectedButton = selectedButton - 1
            end

            if buttons.pressed(buttons.down) and selectedButton < #buttonsList then
                selectedButton = selectedButton + 1
            end

            if buttons.pressed(buttons.cross) or buttons.pressed(buttons.r) then
                submenuActive = true
                selectedSubmenuOption = 1
            end

            drawButtons()
            drawSubmenu()
        end
    end

debugoverlay.draw(debugoverlay.loadSettings())
    screen.flip()
end
