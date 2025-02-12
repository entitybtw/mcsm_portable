local choosing = true
local img = Image.load('assets/video/episode1/choices/6/pigs.png')
local cross_choice = "assets/video/episode1/choices/6/smoke_trail.lua" 
if tall_grass == "off" then
    img = Image.load('assets/video/episode1/choices/6/pigs.png')
    cross_choice = "assets/video/episode1/choices/6/smoke_trail.lua"
elseif tall_grass == "on" then
    img = Image.load('assets/video/episode1/choices/6/pigs_tall_grass.png')
    cross_choice = "assets/video/episode1/choices/6/tall_grass.lua"
end

PMP.play('assets/video/episode1/choices/6/pigs.pmp', buttons.r)

screen.clear()
Image.draw(img, 0, 0)
screen.flip()

while choosing do
    buttons.read()
    if buttons.pressed(buttons.square) then
        Image.unload(img)
        choosing = false
	nextscene =  "assets/video/episode1/choices/6/bush.lua"
    elseif buttons.pressed(buttons.circle) then
        Image.unload(img)
        choosing = false
	nextscene =  "assets/video/episode1/choices/6/water_well.lua"
    elseif buttons.pressed(buttons.cross) then
        Image.unload(img)
        choosing = false
	nextscene = cross_choice
    elseif buttons.pressed(buttons.triangle) then
        Image.unload(img)
        choosing = false
	nextscene =  "assets/video/episode1/choices/6/pigs.lua"
    elseif buttons.pressed(buttons.l) then
        Image.unload(img)
        choosing = false
        nextscene =  "./mainmenu.lua"
    elseif buttons.pressed(buttons.start) then
        Image.unload(img)
        choosing = false
        SaveGame(1)
        nextscene =  "./mainmenu.lua"
    end


end








