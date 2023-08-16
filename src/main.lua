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

game_state = init

local gfx <const> = playdate.graphics

local car = Car(math.random(2,8), "f1")
local wheel = car.wheel
local wheelgun = Wheelgun(wheel)
local reticle = Reticle(wheelgun)
local race_text = RaceText("Car incoming")

function playdate.update()
  if playdate.buttonJustPressed(playdate.kButtonB) then
    car:roll_out()
  end


  if wheel.state == "gone" then 
    wheel:remove()
    wheel = NewWheel(car)
    car.wheel = wheel
    wheelgun:attach(wheel)
    wheelgun.mode = "tighten"
  end

  if car.state =="rollout" and car.a:ended() then
    car:remove()
    car = Car(math.random(2,8),f1)
    wheel = car.wheel
    wheelgun:attach(wheel)
    wheelgun.mode = "loosen"
  end

  playdate.timer.updateTimers()
  gfx.sprite.update()
end


