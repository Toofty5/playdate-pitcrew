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
wheelgun:attach(car.wheel)

function playdate.update()
    playdate.timer.updateTimers()
    gfx.sprite.update()
end
