import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "wheel.lua"
import "wheelgun.lua"
import "nut.lua"


local gfx <const> = playdate.graphics

local wheel = Wheel(6, "mounted")
local wheelgun = Wheelgun()
wheelgun:attach(wheel)

function playdate.update()
    playdate.timer.updateTimers()
    gfx.sprite.update()

    if wheel.state == "gone" then
      wheel = Wheel(6, "fresh")
    end

end
