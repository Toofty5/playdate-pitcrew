import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "wheel.lua"
import "wheelgun.lua"
import "nut.lua"
import "car.lua"
import "ui.lua"
import "game.lua"
import "decorations.lua"

local gfx <const> = playdate.graphics


game.car = Car(math.random(2,6), "f1")
game.wheel = game.car.wheel
game.wheelgun = Wheelgun(game.wheel)
game.state = "init"


local asphalt = Asphalt()
for i = 1,50 do 
  playdate.timer.performAfterDelay(i*5, function() Spark(100, 10) end)
end

function playdate.update()
    if playdate.buttonJustPressed(playdate.kButtonB) then
      game.car:roll_out()
    end
  
  if game.state == "waiting" then

    if game.car.state =="rollout" and game.car.a:ended() then
      game.car:remove()
      game.car = Car(math.random(2,8),f1)
      game.wheel = game.car.wheel
      game.wheelgun:attach(game.wheel)
      game.wheelgun.mode = "loosen"
    end
  end

  playdate.timer.updateTimers()
  gfx.sprite.update()
  gfx.animation.blinker.updateAll()




end


