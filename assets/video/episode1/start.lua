local save = LoadGame(1)
if save then
  PMP.play('assets/mainmenu/loading.pmp')
  dofile(save) 
end
local choosing = true
local img = Image.load('assets/video/episode1/START.png')

PMP.play('assets/mainmenu/lsave.pmp')
PMP.play('assets/video/episode1/START.pmp', buttons.r)

screen.clear()
Image.draw(img, 0, 0)
screen.flip()

while choosing do
    buttons.read()

    if buttons.pressed(buttons.square) then
        Image.unload(img)
        choosing = false
        dofile("assets/video/episode1/100_chicken_sized.lua")
    elseif buttons.pressed(buttons.circle) then
        Image.unload(img)
        choosing = false
        dofile("assets/video/episode1/10_zombie_sized.lua")
    elseif buttons.pressed(buttons.l) then
        Image.unload(img)
        choosing = false
	dofile("./mainmenu.lua")
    end

end
