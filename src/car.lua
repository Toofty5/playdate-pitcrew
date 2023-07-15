local gfx <const> = playdate.graphics
local f1_img = gfx.image.new("img/car_f1.png")

class("Car").extends(gfx.sprite)

function Car:init(wheel)
  self.wheel = wheel
  self.rear_wheel = Wheel(wheel.num_nuts, "rear")
  self:setImage(f1_img)
  self:setCenter(.22, .64)
  self:add()
  self:setZIndex(-1)
end

function Car:update()
  local wheel_state = self.wheel.state

  if wheel_state =="mounted" or wheel_state == "rollout" then
    self:moveTo(self.wheel:getPosition())
  end

  self.rear_wheel:moveTo(self.x+800, self.y)

  if playdate.buttonJustPressed(playdate.kButtonA) then
    print("rollout!")
    self:roll_out()
  end
end

function Car:roll_out()
  self.state = "rollout"
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
