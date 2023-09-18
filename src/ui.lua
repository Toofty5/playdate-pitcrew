local gfx <const> = playdate.graphics

class("Reticle").extends(gfx.sprite)

function Reticle:init(wheelgun)
    local reticle_img = gfx.image.new(50,50)
    self:setImage(reticle_img)
    gfx.pushContext(reticle_img)
        gfx.fillCircleAtPoint(25,25,15)
        gfx.setColor(gfx.kColorClear)
        gfx.fillCircleAtPoint(25,25,13)
        gfx.setColor(gfx.kColorBlack)
    gfx.popContext()

    self.wheelgun = wheelgun
    self:setZIndex(100)
    self:add()
end

function Reticle:update()
    local x,y = self.wheelgun.wheel:getPosition()
    local rotation = math.rad(self.wheelgun.rotation)
    local dx = self.wheelgun.wheel.nut_offset * math.cos(rotation)
    local dy = self.wheelgun.wheel.nut_offset * math.sin(rotation)
    self:moveTo(x+dx,y+dy)
end

class("PitTimer").extends(gfx.sprite)

function PitTimer:init()
  self:moveTo(1,1)
  self:setImage(gfx.image.new(100, 30))
  self:add()
  self:setCenter(0,0)
  self:setZIndex(30)
  self.start_time = playdate.getCurrentTimeMilliseconds()
end

function PitTimer:update()
  gfx.pushContext(self:getImage())
  gfx.clear(gfx.kColorClear)
    local elapsed = playdate.getCurrentTimeMilliseconds() - self.start_time 

    -- local seconds = string.format("%5d", elapsed//1000)
    -- local millis = string.format("%03d", elapsed % 1000)
    -- gfx.drawText(seconds.."."..millis, 1,1)

    gfx.drawText(elapsed/1000, 1,1)
  gfx.popContext()
end

function PitTimer:getTime()
  return playdate.getCurrentTimeMilliseconds() - self.start_time 
end

class("RaceText").extends(gfx.sprite)

function RaceText:init(content, x, y)
  self:setCenter(0,0)
  self:setZIndex(400)
  self.content = {}
  -- self:setImage(gfx.image.new(400,20))
  self:add()
  self:moveTo(0,50)
  local spacing = 15 
  for i = 1, #content do
    local path = playdate.geometry.lineSegment.new(400,0, (i-1) * spacing, 0)
    local duration = 500
    local easing = playdate.easingFunctions.outBack
    local delay = i * 20
    local img = gfx.image.new(10,10)
    gfx.pushContext(img)
      gfx.drawText(content:sub(i,i), 0,0)
    gfx.popContext()

    local spr = gfx.sprite.new(img)
    spr:add()
    self.content[i] = {spr, gfx.animator.new(duration, path, easing, delay)}
  end
end

function RaceText:ended()
  return self.content[#self.content][2]:ended()
end

function RaceText:update()
  if not self:ended() then
    --gfx.pushContext(self:getImage())
     -- gfx.clear(gfx.kColorClear)
      for i, v in pairs(self.content) do
        local c, a = table.unpack(v) 
        local point = a:currentValue()
        -- gfx.drawText(c, point.x, point.y)
        c:moveTo(a:currentValue())
      end
    --gfx.popContext()
  end
end
