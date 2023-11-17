import "CoreLibs/animation"
local gfx <const> = playdate.graphics

class("Notify").extends(gfx.sprite)
function Notify:init(text, x,y)
  Notify.super.init(self)
  local img = gfx.imageWithText(text, 100,100)
  self.blinker = gfx.animation.blinker.new(100,100,false, 10, false)
  self.blinker:start()
  self:setCenter(0,0)

  self:setImage(img)
  self:add()
  self:moveTo(x,y)
end

function Notify:update()
  self:setVisible(self.blinker.on)
end
  

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
  local spacing = 15 
  self:setCenter(0,0)
  self:setImage(gfx.image.new(spacing * #content, 20))
  self.blinker = gfx.animation.blinker.new(100, 100, false,10, false )
  self:add()
  self.content = {}
  self.state = "entering"
  for i = 1, #content do
    local path = playdate.geometry.lineSegment.new(x + 400, y , x + ((i-1) * spacing), y)
    local duration = 200
    local easing = playdate.easingFunctions.outBack
    local delay = i * 20
    local img = gfx.image.new(12,20)

    gfx.pushContext(img)
      gfx.drawText(content:sub(i,i), 0,0)
    gfx.popContext()

    local spr = gfx.sprite.new(img)
    spr:setCenter(0,0)
    spr:setZIndex(400)
    spr:add()
    self.content[i] = {spr, gfx.animator.new(duration, path, easing, delay)}
  end
end

function RaceText:is_complete()
  return self.content[#self.content][2]:ended()
end

function RaceText:ended()
  return self.state == "blinking" and not self.blinker.running
end

function RaceText:update()
  if self.state == "entering" then
    for i, v in pairs(self.content) do
      local c, a = table.unpack(v) 
      local point = a:currentValue()
      c:moveTo(a:currentValue())
    end
    if self:is_complete() then self:blink() end
  elseif self.state == "blinking" then
    for i,v in pairs(self.content) do
      local c, a = table.unpack(v)
      c:setVisible(self.blinker.on)
    end
  end
end

function RaceText:blink()
  self.state = "blinking"
  self.blinker:start()
end

function RaceText:remove()
  gfx.sprite.remove(self)
  for i,v in pairs(self.content) do
    local c,a = table.unpack(v)
    c:remove()
  end
end

class("FlashTime").extends(gfx.sprite)

function FlashTime:init(time)
  FlashTime.super.init(self)

  self.blinker = gfx.animation.blinker.new(80, 80, false,20, true )
  self.blinker:start()
  self.content = string.format("%.3f", time / 1000)
  self.isFinished = false

  local img = gfx.image.new(gfx.getTextSize(self.content))

  gfx.pushContext(img)
    gfx.drawText(self.content,0,0)
  gfx.popContext()

  self:setScale(2)
  self:setZIndex(-2)
  self:setImage(img)
  self:moveTo(200, 120)
  self:add()
end

function FlashTime:update()
  self:setVisible(self.blinker.on)
  if not self.isFinished and not self.blinker.running then
    self.isFinished = true
    playdate.timer.performAfterDelay(500,self.remove, self) 
  end

  
end
