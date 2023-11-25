local gfx <const> = playdate.graphics
local WHEEL_RADIUS <const> = 80
local width, height = 200,200
local wheel_img = gfx.image.new(width,height)
local unmount


gfx.pushContext(wheel_img)
    gfx.setColor(gfx.kColorBlack)
    gfx.fillCircleAtPoint(width/2, height/2, WHEEL_RADIUS)
    gfx.setColor(gfx.kColorWhite)
    gfx.fillCircleAtPoint(width/2, height/2, WHEEL_RADIUS-30)
gfx.popContext()

class('Wheel').extends(gfx.sprite)

function Wheel:init(car, rotation, state)
  self.car = car
  self.num_nuts = car.num_nuts
  self.state = state
  self:setImage(wheel_img)
  if self.num_nuts == 1 then
    self.nut_offset = 0
  else
    self.nut_offset = 25
  end
  
  self.nuts = {}
  self.init_rotation = rotation
  self.rotation = self.init_rotation
  self:setZIndex(0)
end


function Wheel:update()
  self.rotation = self.init_rotation + (self.x * 6/math.pi)
end

class('OldWheel').extends(Wheel)
function OldWheel:init(car, rotation)
  Wheel.init(self, car, rotation, 'mounted')
  self.is_attached = true
  for i = 1, self.num_nuts do table.insert(self.nuts, Nut(self, i, true)) end
  self:add()
end

function OldWheel:update()
  Wheel.update(self)
  if self.state == "mounted" then
    self:moveTo(self.car:get_axle())
  elseif self.state == "loose" and playdate.buttonJustPressed(playdate.kButtonDown) then
    self:unmount()
  elseif self.state == "leaving" then
    self:moveTo(self.a:currentValue())
    if self.a:ended() then
      self.state = "gone"
      self:remove()
    end
  end
end

class('NewWheel').extends(Wheel)
function NewWheel:init(car, rotation)
  Wheel.init(self,car, rotation,'fresh')
  for i = 1, self.num_nuts do table.insert(self.nuts, Nut(self, i, false)) end
  self:slide_in()
end

function NewWheel:update()
  Wheel.update(self)
  if self.state == "fresh" then
    self:moveTo(self.a:currentValue())
    if self.a:ended() then
      self.state = "waiting"
    end

  elseif self.state == "ready" then
    self:moveTo(self.car:get_axle())
  end
end

class('RearWheel').extends(Wheel)
function RearWheel:init(car)
  Wheel.init(self,car, math.random(360),'rear')
  for i = 1, self.num_nuts do table.insert(self.nuts, Nut(self, i, true)) end
  self:add()
end

function RearWheel:update()
  Wheel.update(self)
  self:moveTo(self.car.x + 800, self.car.y)
end

function Wheel:remove()
  for i,nut in pairs(self.nuts) do
    nut:remove()
  end
  gfx.sprite.remove(self)
end

function Wheel:slide_in()
    local duration = 400
    local axle = self.car:get_axle()
    local ls1 = playdate.geometry.lineSegment.new(480,300, axle.x, axle.y)
    local easing = playdate.easingFunctions.outQuint
    self.a = gfx.animator.new(duration, ls1, easing)
    self:moveTo(self.a:currentValue())
    self:add()
end


function Wheel:unmount()
    local duration = 300
    local axle = self.car:get_axle()
    local ls1 = playdate.geometry.lineSegment.new(axle.x, axle.y, 200,400)
    local easing = playdate.easingFunctions.easeInBack
    self.a = gfx.animator.new(duration, ls1, easing) 
    self.state = "leaving"
end

function Wheel:remove_nut(index)
    self.nuts[index]:pop_off()
    if self:nuts_mounted() == 0 then 
      self.state = "loose"
    end
end

function Wheel:add_nut(index)
  self.nuts[index]:put_on()
  if self:nuts_mounted() == self.num_nuts then 
    -- self.a = self.car.a
    self.state = "ready"
  end
end

function Wheel:nuts_mounted()
  local count = 0
  for i, nut in pairs(self.nuts) do
    if nut.is_present then count += 1 end
  end
  return count
end


