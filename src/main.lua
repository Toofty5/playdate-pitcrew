import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "wheel.lua"
import "wheelgun.lua"
import "nut.lua"


local gfx <const> = playdate.graphics

local wheel = Wheel(2)
local wheelgun = Wheelgun()
wheelgun:attach(wheel)

function playdate.update()
    playdate.timer.updateTimers()
    gfx.sprite.update()
end
