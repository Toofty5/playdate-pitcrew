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

function playdate.update()
  playdate.timer.updateTimers()
  gfx.sprite.update()
  if wheel.state == "gone" then 
    wheel = Wheel(car, "fresh")
    car.wheel = wheel
    wheelgun:attach(wheel)
    wheelgun.mode = "tighten"
  end

end
