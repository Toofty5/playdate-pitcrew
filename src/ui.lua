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
