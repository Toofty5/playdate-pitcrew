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

function Wheel:init(num_nuts, state)
  self.state = state
  self:setImage(wheel_img)
  self.nut_offset = 25
  self.nuts = {}
  self.init_rotation = math.random(360)
  self.rotation = self.init_rotation

  self:moveTo(200,140)
  self:setZIndex(0)

  if self.state == "mounted" then
    self.nuts_mounted = num_nuts
    for i = 1, num_nuts do table.insert(self.nuts, Nut(self, i, true)) end
    self:roll_in()

  elseif self.state == "fresh" then
    self.nuts_mounted = 0
    for i = 1, num_nuts do table.insert(self.nuts, Nut(self, i, false)) end
    self:slide_in()
  end

end


function Wheel:update()
    self.rotation = self.init_rotation + (self.x * 6/math.pi)
    self:moveTo(self.a:currentValue())

    if self.state == "loose" and 
      playdate.buttonJustPressed(playdate.kButtonDown) then
        self:unmount()
    elseif self.state == "unmounted" and
      self.a:ended() then
      self.state = "gone"
      self:remove()
    end

end

function Wheel:roll_in()
    self:add()
    local duration = 800
    local ls1 = playdate.geometry.lineSegment.new(480,140, 200,140)
    local easing = playdate.easingFunctions.outQuint
    self.a = gfx.animator.new(duration, ls1, easing)
end

function Wheel:slide_in()
    self:add()
    local duration = 400
    local ls1 = playdate.geometry.lineSegment.new(480,300, 200,140)
    local easing = playdate.easingFunctions.outQuint
    self.a = gfx.animator.new(duration, ls1, easing)
end

function Wheel:roll_out()
    local duration = 800
    local ls1 = playdate.geometry.lineSegment.new(200,140, -250,140)
    local easing = playdate.easingFunctions.inQuint
    self.a = gfx.animator.new(duration, ls1, easing)
end

function Wheel:unmount()
    local duration = 300
    local ls1 = playdate.geometry.lineSegment.new(200,140, 200,400)
    local easing = playdate.easingFunctions.easeInBack
    self.a = gfx.animator.new(duration, ls1, easing) 
    self.state = "unmounted"
end

function Wheel:remove_nut(index)
    self.nuts[index]:pop_off()
    self.nuts_mounted -= 1
    if self.nuts_mounted == 0 then 
      self.state = "loose"
    end
end
