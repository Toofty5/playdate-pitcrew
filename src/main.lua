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

local gfx <const> = playdate.graphics


GAME.car = Car(math.random(2,8), "f1")
GAME.wheel = GAME.car.wheel
GAME.wheelgun = Wheelgun(GAME.wheel)
GAME.reticle = Reticle(GAME.wheelgun)
GAME.race_text = RaceText("Car incoming")
GAME.state = "init"



function playdate.update()
  if GAME.state == "waiting" then
    if playdate.buttonJustPressed(playdate.kButtonB) then
      car:roll_out()
    end


    if wheel.state == "gone" then 
    end

    if car.state =="rollout" and car.a:ended() then
      car:remove()
      car = Car(math.random(2,8),f1)
      wheel = car.wheel
      wheelgun:attach(wheel)
      wheelgun.mode = "loosen"
    end
  end

  playdate.timer.updateTimers()
  gfx.sprite.update()
end


