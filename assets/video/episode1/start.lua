local ep1 = "assets/video/episode1/"
local choices = {
    choice0 = {
        path = ep1 .. "start",
        leftchoice = "100 chicken-sized\n \n       zombie",
        rightchoice = "10 zombie-sized\n \n       chickens",
        leftchoicefilename = "100_chicken_sized",
        rightchoicefilename = "10_zombie_sized",
        leftchoicestate = nil,
        rightchoicestate = nil,
        nextchoice = "choice1"
    },
    
    choice1 = {
        path = ep1,
        leftchoice = "Cool Mask",
        rightchoice = "Not funny, Axel",
        leftchoicefilename = "cool_mask",
        rightchoicefilename = "not_funny_axel",
        leftchoicestate = nil,
        rightchoicestate = nil,
        nextchoice = "choice2"
    },
    
    choice2 = {
        path = ep1 .. "choices/",
        leftchoice = "Gabriel is awesome!",
        rightchoice = "No big deal",
        leftchoicefilename = "gabriel_is_awesome",
        rightchoicefilename = "no_big_deal",
        leftchoicestate = nil,
        rightchoicestate = nil,
        nextchoice = "choice3"
    },
    choice3 = {
        path = ep1 .. "choices/1/",
        leftchoice = "Build a Creeper!",
        rightchoice = "Build an Enderman!",
        leftchoicefilename = "build_a_creeper",
        rightchoicefilename = "build_a_enderman",
        leftchoicestate = nil,
        rightchoicestate = nil,
        nextchoice = "choice4"
    },
    choice4 = {
        path = ep1 .. "choices/2/",
        leftchoice = "We're Dead Enders",
        rightchoice = "We're the Nether Maniacs",
        middlechoice = "We're the Order Of The pig",
        leftchoicefilename = "dead_enders",
        rightchoicefilename = "nether_maniacs",
        middlechoicefilename = "order_of_pig",
        leftchoicestate = nil,
        rightchoicestate = nil,
        middlechoicestate = nil,
        nextchoice = "choice5"
    },
    choice5 = {
        path = ep1 .. "choices/3/",
        leftchoice = "May the best team win",
        rightchoice = "We're going to crush you",
        leftchoicefilename = "may_the_best_team_win",
        rightchoicefilename = "we_going_to_crush_you",
        leftchoicestate = nil,
        rightchoicestate = nil,
        nextchoice = nil   
    }
}

_G.build = nil
_G.lastChoiceFilename = nil

local currentchoice = choices.choice0
PMP.setVolume(pmpvolume)

while currentchoice do
    local choosing = true
    
    if currentchoice == choices.choice5 and currentchoice.path == nil then
        if _G.build then
            currentchoice.path = ep1 .. "choices/2/" .. _G.build .. "/"
        else
            currentchoice.path = ep1 .. "choices/2/"
        end
    end
    
    local videoPath = currentchoice.path
    if _G.lastChoiceFilename and string.sub(currentchoice.path, -1) == "/" then
        videoPath = currentchoice.path .. _G.lastChoiceFilename
    end
    
    local result = PMP.playEasy(videoPath .. '.pmp', buttons.r, true, 
                                videoPath .. ".srt", font, subssize, 
                                "#FFFFFF", "#000000/150", subs)
    if result == 1 then
        nextscene = "./mainmenu.lua"
        return 1
    end
    
    Image.draw(square, 25, 127)
    Image.draw(circle, 455, 127)
    
    if currentchoice.middlechoice then
        Image.draw(triangle, 140, 182)
    end
    
    intraFont.print(45, 127, currentchoice.leftchoice, Color.new(255,255,255), font, 0.4)
    intraFont.print(450 - intraFont.textW(font, currentchoice.rightchoice, 0.4), 127, 
                   currentchoice.rightchoice, Color.new(255,255,255), font, 0.4)
    
    if currentchoice.middlechoice then
        intraFont.print(140 + 15 + 5, 182, currentchoice.middlechoice, Color.new(255,255,255), font, 0.4)
    end
    
    intraFont.print(340 - intraFont.textW(font, "Press R to save", 0.63), 230, 
                   "Press R to save", Color.new(255,255,255, 150), font, 0.63)
    debugoverlay.draw(debugoverlay.loadSettings())
    screen.flip()
    
    while choosing do
        buttons.read()

        if buttons.pressed(buttons.square) then
            choosing = false
            currentchoice.leftchoicestate = "done"
            
            if currentchoice.leftchoicefilename == "build_a_creeper" then
                _G.build = "creeper/"
            end
            
            _G.lastChoiceFilename = currentchoice.leftchoicefilename
            
        elseif buttons.pressed(buttons.circle) then
            choosing = false
            currentchoice.rightchoicestate = "done"
            
            if currentchoice.rightchoicefilename == "build_a_enderman" then
                _G.build = ""
            end
            
            _G.lastChoiceFilename = currentchoice.rightchoicefilename
            
        elseif buttons.pressed(buttons.triangle) and currentchoice.middlechoice then
            choosing = false
            currentchoice.middlechoicestate = "done"
            
            if currentchoice.middlechoicefilename == "order_of_pig" then
                _G.build = "pig"
            end
            
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
        end
    end
    
    if currentchoice.nextchoice then
        currentchoice = choices[currentchoice.nextchoice]
    else
        currentchoice = nil
    end
end
