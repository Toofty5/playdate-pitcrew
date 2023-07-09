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

function Wheel:init(num_nuts)
    self.state = "mounted"
    self.nuts_mounted = num_nuts
    self:setImage(wheel_img)
    self.nuts = {}
    self.init_rotation = math.random(360)
    self.rotation = self.init_rotation
    self.nut_offset = 25
    for i = 1, num_nuts do table.insert(self.nuts, Nut(self, i)) end
    self:moveTo(200,140)
    self:setZIndex(0)
    self:roll_in()
end


function Wheel:update()
    self.rotation = self.init_rotation + (self.x * 6/math.pi)
    self:moveTo(self.a:currentValue())

    if self.state == "loose" then
      if playdate.buttonJustPressed(playdate.kButtonDown) then
        self:unmount()
      end
    end
end

function Wheel:roll_in_segmented()
    self:add()
    local durations = {400,300}
    local ls1 = playdate.geometry.lineSegment.new(480,140, 250,140)
    local ls2 = playdate.geometry.lineSegment.new(250,140, 200,140)
    local easings = {playdate.easingFunctions.linear, playdate.easingFunctions.outQuint}
    self.a = gfx.animator.new(durations, {ls1,ls2}, easings)
end

function Wheel:roll_in()
    self:add()
    local duration = 800
    local ls1 = playdate.geometry.lineSegment.new(480,140, 200,140)
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
end

function Wheel:remove_nut(index)
    self.nuts[index]:pop_off()
    self.nuts_mounted -= 1
    if self.nuts_mounted == 0 then 
      self.state = "loose"
    end
end
