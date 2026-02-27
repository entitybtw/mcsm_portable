local ep1 = "assets/subtitles/episode1/"
local choices = {
    {
        id = "choice0",
        path = ep1 .. "start",
        leftchoice = "100 chicken-sized\n \n       zombie",
        rightchoice = "10 zombie-sized\n \n       chickens",
        leftchoicefilename = "100_chicken_sized",
        rightchoicefilename = "10_zombie_sized",
        nextchoice = "choice1"
    },
    
    {
        id = "choice1",
        path = ep1,
        leftchoice = "Cool Mask",
        rightchoice = "Not funny, Axel",
        leftchoicefilename = "cool_mask",
        rightchoicefilename = "not_funny_axel",
        nextchoice = "choice2"
    },
    
    {
        id = "choice2",
        path = ep1 .. "choices/",
        leftchoice = "Gabriel is awesome!",
        rightchoice = "No big deal",
        leftchoicefilename = "gabriel_is_awesome",
        rightchoicefilename = "no_big_deal",
        nextchoice = "choice3"
    },
    
    {
        id = "choice3",
        path = ep1 .. "choices/1/",
        leftchoice = "Build a Creeper!",
        rightchoice = "Build an Enderman!",
        leftchoicefilename = "build_a_creeper",
        rightchoicefilename = "build_a_enderman",
        nextchoice = "choice4"
    },
    
    {
        id = "choice4",
        path = ep1 .. "choices/2/",
        leftchoice = "We're Dead Enders",
        rightchoice = "We're the Nether Maniacs",
        middlechoice = "We're the Order Of The pig",
        leftchoicefilename = "dead_enders",
        rightchoicefilename = "nether_maniacs",
        middlechoicefilename = "order_of_the_pig",
        nextchoice = "choice5"
    },
    
    {
        id = "choice5",
        path = ep1 .. "choices/3/",
        leftchoice = "May the best team win",
        rightchoice = "We're going to crush you",
        leftchoicefilename = "may_the_best_team_win",
        rightchoicefilename = "we_going_to_crush_you",
        nextchoice = "choice6"   
    },
    
    {
        id = "choice6",
        path = ep1 .. "choices/4/",
        leftchoice = "Redstone Rap!",
        rightchoice = "Warrior Whip!",
        leftchoicefilename = "redstone_rap",
        rightchoicefilename = "warrior_whip",
        nextchoice = "choice7"
    },
    
    {
        id = "choice7",
        path = ep1 .. "choices/5/",
        leftchoice = "Run, I'll distract them!",
        rightchoice = "Stay close, I'll protect you",
        leftchoicefilename = "run_i_distract_them",
        rightchoicefilename = "stay_close_i_protect_you",
        zone = "the_woods"
    },

    {
        id = "choice8",
        path = ep1 .. "choices/7/",
        leftchoice = "Run, I'll distract them!",
        rightchoice = "Stay close, I'll protect you",
        leftchoicefilename = "run_i_distract_them",
        rightchoicefilename = "stay_close_i_protect_you",
        nextchoice = "choice9"
    },
}

local choicesMap = {}
for _, choice in ipairs(choices) do
    choicesMap[choice.id] = choice
end

_G.build = nil
_G.lastChoiceFilename = nil

local currentchoice = choicesMap.choice0

PMP.setVolume(pmpvolume)

while currentchoice do
    local choosing = true
    
    if currentchoice.id == "choice5" and (not currentchoice.path or currentchoice.path == "") then
        if _G.build then
            currentchoice.path = ep1 .. "choices/2/" .. _G.build .. "/"
        else
            currentchoice.path = ep1 .. "choices/2/"
        end
    end
    
    local videoPath = currentchoice.path or ""
    if _G.lastChoiceFilename and videoPath ~= "" and string.sub(videoPath, -1) == "/" then
        videoPath = videoPath .. _G.lastChoiceFilename
    end

    if currentchoice.zone == "the_woods" then
        local result = PMP.playEasy(videoPath .. '.pmp', buttons.r, true, 
                                    videoPath .. ".srt", font, subssize, 
                                    "#FFFFFF", "#000000/150", subs)
        if result == 1 then
            nextscene = "./mainmenu.lua"
            return 1
        end
        
        dofile(ep1 .. "choices/6/the_woods_zone.lua")
    end
    
    if videoPath ~= "" then
        local result = PMP.playEasy(videoPath .. '.pmp', buttons.r, true, 
                                    videoPath .. ".srt", font, subssize, 
                                    "#FFFFFF", "#000000/150", subs)
        if result == 1 then
            nextscene = "./mainmenu.lua"
            return 1
        end
    end
    
    if currentchoice.leftchoice or currentchoice.rightchoice or currentchoice.middlechoice then
        Image.draw(spritesheet, 25, 127, 15, 15, nil, 414, 0, 15, 15)
        Image.draw(spritesheet, 455, 127, 15, 15, nil, 384, 0, 15, 15)
        
        if currentchoice.middlechoice then
            Image.draw(spritesheet, 140, 182, 15, 15, nil, 430, 0, 15, 15)
        end
        
        if currentchoice.leftchoice then
            intraFont.print(45, 127, currentchoice.leftchoice, Color.new(255,255,255), font, 0.4)
        end
        
        if currentchoice.rightchoice then
            intraFont.print(450 - intraFont.textW(font, currentchoice.rightchoice, 0.4), 127, 
                           currentchoice.rightchoice, Color.new(255,255,255), font, 0.4)
        end

        if currentchoice.middlechoice then
            intraFont.print(140 + 15 + 5, 182, currentchoice.middlechoice, Color.new(255,255,255), font, 0.4)
        end
        
        intraFont.print(340 - intraFont.textW(font, "Press R to save", 0.63), 230, 
                       "Press R to save", Color.new(255,255,255, 150), font, 0.63)
        debugoverlay.draw(debugoverlay.loadSettings())
        screen.flip()
    end
    
    while choosing do
        buttons.read()

        
        if buttons.pressed(buttons.square) and currentchoice.leftchoice then
            choosing = false
            _G.lastChoiceFilename = currentchoice.leftchoicefilename
            
            if currentchoice.leftchoicefilename == "build_a_creeper" then
                _G.build = "creeper/"
            end
            
        elseif buttons.pressed(buttons.circle) and currentchoice.rightchoice then
            choosing = false
            _G.lastChoiceFilename = currentchoice.rightchoicefilename
            
            if currentchoice.rightchoicefilename == "build_a_enderman" then
                _G.build = ""
            end
            
        elseif buttons.pressed(buttons.triangle) and currentchoice.middlechoice then
            choosing = false
            _G.lastChoiceFilename = currentchoice.middlechoicefilename
            
            
        elseif buttons.pressed(buttons.start) then
            choosing = false
            local pause = dofile("assets/misc/pause.lua")
            if pause == -1 then 
                nextscene = "./mainmenu.lua" 
                return
            end
            choosing = true
            
        elseif buttons.pressed(buttons.r) then
            choosing = false
            SaveGame(1)
            choosing = true
            
        elseif currentchoice.id == "choice7" then
            choosing = false
        end
    end
    
    if currentchoice.nextscene then
        nextscene = currentchoice.nextscene
        zone = "the_woods"
        break
    elseif currentchoice.nextchoice then
        currentchoice = choicesMap[currentchoice.nextchoice]
    else
        currentchoice = nil
    end
end