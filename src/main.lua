import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "wheel.lua"
import "wheelgun.lua"
import "nut.lua"
import "car.lua"
import "ui.lua"

local gfx <const> = playdate.graphics

local wheelgun = Wheelgun()
local car = Car(math.random(2,8), "f1")
local wheel = car.wheel
wheelgun:attach(wheel)
local reticle = Reticle(wheelgun)
local pit_time
local timer_started = false
local race_text = RaceText("Car incoming")

function playdate.update()
  if playdate.buttonJustPressed(playdate.kButtonB) then
    car:roll_out()
  end
  if car.state == "waiting" and not timer_started then
    pit_time = PitTimer()
    timer_started = true
  end

  if wheel.state == "ready" and timer_started then
    print(pit_time:getTime()/1000)
    pit_time:remove()
    timer_started = false
  end

  if wheel.state == "gone" then 
    wheel:remove()
    wheel = Wheel(car, "fresh")
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


