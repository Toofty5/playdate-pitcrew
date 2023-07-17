local gfx <const> = playdate.graphics
local f1_img = gfx.image.new("img/car_f1.png")

class("Car").extends(gfx.sprite)

function Car:init(num_nuts, car_type)
  self:setImage(f1_img)
  self:setCenter(.22, .64)
  self:add()
  self:setZIndex(-1)
  self:roll_in()
  self.num_nuts = num_nuts
  self.car_type = car_type
  self.wheel = Wheel(self, "mounted")
  self.rear_wheel = Wheel(self, "rear")
end

function Car:update()
  self:moveTo(self.a:currentValue())
end

function Car:roll_out()
  self.state = "rollout"
  self.wheel.state = "rollout"
    local duration = 1200
    local ls1 = playdate.geometry.lineSegment.new(200,140, -2000,140)
    local easing = playdate.easingFunctions.inQuint
    self.a = gfx.animator.new(duration, ls1, easing)
end

function Car:roll_in()
    local duration = 1000
    local ls1 = playdate.geometry.lineSegment.new(1500,140, 200,140)
    local easing = playdate.easingFunctions.outQuint
    self.a = gfx.animator.new(duration, ls1, easing)
end
