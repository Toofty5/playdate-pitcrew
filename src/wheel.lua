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

function Wheel:init(car, state)
  self.car = car
  self.num_nuts = car.num_nuts
  self.state = state
  self:setImage(wheel_img)
  self.nut_offset = 25
  self.nuts = {}
  self.init_rotation = math.random(360)
  self.rotation = self.init_rotation
  self:setZIndex(0)

end


function Wheel:update()
  self.rotation = self.init_rotation + (self.x * 6/math.pi)
end

class('OldWheel').extends(Wheel)
function OldWheel:init(car)
  Wheel.init(self, car, 'mounted')
  self.is_attached = true
  for i = 1, self.num_nuts do table.insert(self.nuts, Nut(self, i, true)) end
  self:add()
end

function OldWheel:update()
  Wheel.update(self)
  if self.state == "mounted" then
    local axle = self.car.a:currentValue()
    self:moveTo(axle.x, math.min(140, axle.y+30))
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
function NewWheel:init(car)
  Wheel.init(self,car,'fresh')
  for i = 1, self.num_nuts do table.insert(self.nuts, Nut(self, i, false)) end
  self:slide_in()
end

function NewWheel:update()
  Wheel.update(self)
  if self.state == "fresh" then
    self:moveTo(self.a:currentValue())
  elseif self.state == "ready" then
    local axle = self.car.a:currentValue()
    self:moveTo(axle.x, math.min(140, axle.y+30))
  end
end

class('RearWheel').extends(Wheel)
function RearWheel:init(car)
  Wheel.init(self,car,'rear')
  for i = 1, self.num_nuts do table.insert(self.nuts, Nut(self, i, true)) end
  self:add()
end

function RearWheel:update()
  Wheel.update(self)
  self:moveTo(self.car.a:currentValue():offsetBy(800,0))
end

function Wheel:remove()
  for i,nut in pairs(self.nuts) do
    nut:remove()
  end
  gfx.sprite.remove(self)
end

function Wheel:slide_in()
    local duration = 400
    local ls1 = playdate.geometry.lineSegment.new(480,300, 200,140)
    local easing = playdate.easingFunctions.outQuint
    self.a = gfx.animator.new(duration, ls1, easing)
    self:moveTo(self.a:currentValue())
    self:add()
end


function Wheel:unmount()
    local duration = 300
    local ls1 = playdate.geometry.lineSegment.new(200,140, 200,400)
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
    self.state = "ready"
    self.car:roll_out()
    self.a = self.car.a
  end
end

function Wheel:nuts_mounted()
  local count = 0
  for i, nut in pairs(self.nuts) do
    if nut.is_present then count += 1 end
  end
  return count
end


