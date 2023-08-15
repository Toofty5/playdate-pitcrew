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
  self.wheel = OldWheel(self)
  self.rear_wheel = Wheel(self, "rear")
end

function Car:update()
  self:moveTo(self.a:currentValue())

  if self.state == "new" and self.a:ended() then
    self.state = "waiting"
  end

end

function Car:roll_out()
  self.state = "rollout"
    local durations = {100, 1200}
    local ls1 = playdate.geometry.lineSegment.new(200,100, 200,140)
    local ls2 = playdate.geometry.lineSegment.new(200,140, -2000, 140)
    local easings = {playdate.easingFunctions.linear, playdate.easingFunctions.inQuint}
    self.a = gfx.animator.new(durations, {ls1, ls2}, easings)
end

function Car:roll_in()
  self.state = "new"
    local durations = {800, 100}
    local ls1 = playdate.geometry.lineSegment.new(1500,140, 200,140)
    local ls2 = playdate.geometry.lineSegment.new(200,140, 200, 100)
    local easings = {playdate.easingFunctions.outQuint, playdate.easingFunctions.linear}
    self.a = gfx.animator.new(durations, {ls1, ls2}, easings)
end

function Car:remove()
  self.rear_wheel:remove()
  self.wheel:remove()
  gfx.sprite.remove(self)
end
