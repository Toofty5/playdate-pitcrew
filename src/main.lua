import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "wheel.lua"
import "wheelgun.lua"
import "nut.lua"
import "car.lua"

local gfx <const> = playdate.graphics

local wheel = Wheel(6, "mounted")
local wheelgun = Wheelgun()
local car = wheel.car
wheelgun:attach(wheel)
wheel:roll_in()

function playdate.update()
    playdate.timer.updateTimers()
    gfx.sprite.update()

    if wheel.state == "gone" then
      wheel = Wheel(6, "fresh")
      wheel.car = car
      car.wheel = wheel
      wheelgun:attach(wheel)
      wheelgun.mode = "tighten"
    elseif wheel.state == "ready" then
      wheel:roll_out()
    end

end
