local save = LoadGame(1)
if save then
PMP.setVolume(pmpvolume)
  PMP.play('assets/mainmenu/loading.pmp')
  LoadGame(1)
end

local img = Image.load('assets/video/episode1/START.png')

PMP.setVolume(pmpvolume)
PMP.play('assets/mainmenu/lsave.pmp')
PMP.setVolume(pmpvolume)
PMP.play('assets/video/episode1/START.pmp', buttons.r)

screen.clear()
Image.draw(img, 0, 0)
screen.flip()

while true do
    buttons.read()

    if buttons.pressed(buttons.square) then
        Image.unload(img)
        nextscene =  "assets/video/episode1/100_chicken_sized.lua"
        break
    elseif buttons.pressed(buttons.circle) then
        Image.unload(img)
        nextscene =  "assets/video/episode1/10_zombie_sized.lua"
        break
    elseif buttons.pressed(buttons.l) then
        Image.unload(img)
	    nextscene =  "./mainmenu.lua"
        break
    end

end
