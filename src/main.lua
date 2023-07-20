import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "wheel.lua"
import "wheelgun.lua"
import "nut.lua"
import "car.lua"

local gfx <const> = playdate.graphics

local wheelgun = Wheelgun()
local car = Car(6, "f1")
local wheel = car.wheel
wheelgun:attach(wheel)
local timer_started = false

function playdate.update()
  if car.state == "new" and car.a:ended() then
    car.state = "waiting"
    playdate.resetElapsedTime()
    timer_started = true
  end

  if wheel.state == "ready" and timer_started then
    print(playdate.getElapsedTime())
    timer_started = false
  end

  if wheel.state == "gone" then 
    wheel = Wheel(car, "fresh")
    car.wheel = wheel
    wheelgun:attach(wheel)
    wheelgun.mode = "tighten"
  end

  if car.state =="rollout" and car.a:ended() then
    car = Car(6,f1)
    wheel = car.wheel
    wheelgun:attach(wheel)
  end

  playdate.timer.updateTimers()
  gfx.sprite.update()
end
