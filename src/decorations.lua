import "CoreLibs/animator"

local gfx <const> = playdate.graphics


-- draw star centered at x,y; r1 is outer radius, r2 is inner
function draw_star(x,y,num_points,r1,r2,rotation)
  -- get the angle of each whole segment
  local angle = 2 * math.pi / num_points
  points = {}
  for i = 0,num_points do
    --outer point
    local x1 = x + (r1 * math.cos(angle * i + rotation))
    local y1 = y + (r1 * math.sin(angle * i + rotation))
    table.insert(points,x1)
    table.insert(points,y1)

    --inner point
    local x2 = x + (r2 * math.cos((angle * (i + .5) ) + rotation))
    local y2 = y + (r2 * math.sin((angle * (i + .5) ) + rotation))
    table.insert(points,x2)
    table.insert(points,y2)
  end

  gfx.drawPolygon(table.unpack(points))

end

--star that goes up and left
class("Star").extends(gfx.sprite)
function Star:init(x,y)
  Star.super.init(self)
  self:setZIndex(200)
  local img = gfx.image.new("img/puff_sm.png")
  self:setImage(img)
  self:moveTo(x,y)
  self:setCenter(1,1)
  local easing = playdate.easingFunctions.outQuint
  local dist = 50
  local ls = playdate.geometry.lineSegment.new(x,y,x - dist, y - dist)
  self.animator = gfx.animator.new(500, ls, easing)
  self:add()
end


--star that goes to the right
class("RStar").extends(Star)
function RStar:init(x,y)
  RStar.super.init(self,x,y)
  self:setCenter(0,1)
  self:setImageFlip(gfx.kImageFlippedX)
  local easing = playdate.easingFunctions.outQuint
  local dist = 50
  local ls = playdate.geometry.lineSegment.new(x,y,x + dist, y - dist)
  self.animator = gfx.animator.new(300, ls, easing)
end

function Star:update()
  self:moveTo(self.animator:currentValue())
  if self.animator:ended() then self:remove() end
end


function puff(x,y)
  Puff(x-10,y)
  RPuff(x+10,y)
end
--puff that goes up and left
class("Puff").extends(gfx.sprite)
function Puff:init(x,y)
  Puff.super.init(self)
  self:setZIndex(200)
  local img = gfx.image.new("img/puff_sm.png")
  self:setImage(img)
  self:moveTo(x,y)
  self:setCenter(1,1)
  local easing = playdate.easingFunctions.outQuint
  local dist = 50
  local ls = playdate.geometry.lineSegment.new(x,y,x - dist, y - dist)
  self.animator = gfx.animator.new(500, ls, easing)
  self:add()
end


--puff that goes to the right
class("RPuff").extends(Puff)
function RPuff:init(x,y)
  RPuff.super.init(self,x,y)
  self:setCenter(0,1)
  self:setImageFlip(gfx.kImageFlippedX)
  local easing = playdate.easingFunctions.outQuint
  local dist = 50
  local ls = playdate.geometry.lineSegment.new(x,y,x + dist, y - dist)
  self.animator = gfx.animator.new(300, ls, easing)
end

function Puff:update()
  self:moveTo(self.animator:currentValue())
  if self.animator:ended() then self:remove() end
end

function puff(x,y)
  Puff(x-10,y)
  RPuff(x+10,y)
end


class("Asphalt").extends(gfx.sprite)
function Asphalt:init()
  local asphalt_img = gfx.image.new(600,160)

  gfx.pushContext(asphalt_img)
    gfx.fillRect(0, 80, 600, 160)
  gfx.popContext()

  local asphalt_blurred = asphalt_img:blurredImage(20, 8, gfx.image.kDitherTypeBayer8x8)

  Asphalt.super.init(self)
  self:add()
  self:setZIndex(-100)
  self:setCenter(0,0)
  self:moveTo(-100,100)
  self:setImage(asphalt_blurred)
end



class("Wake").extends(gfx.sprite)
function Wake:init()
  Wake.super.init(self)
  self:setZIndex(150)
  local img = gfx.image.new("img/wake.png")
  local img_blurred = img:blurredImage(4, 1, gfx.image.kDitherTypeBayer2x2)
  self:setImage(img_blurred)
  self:moveTo(400,200)
  self:setCenter(0,1)
  local easing = playdate.easingFunctions.outQuint
  self.animator = gfx.animator.new(600, 400, 220, easing)
  self:add()
end

function Wake:update()
  self:moveTo(self.animator:currentValue(), self.y)
  if self.animator:ended() then self:remove() end
  print(self.animator:ended())
end


--ended up not using the wall in the background
class("Wall").extends(gfx.sprite)
function Wall:init()
  local wall_img = gfx.image.new(400, 50)
  gfx.pushContext(wall_img)
    gfx.setLineWidth(3)
    local seg_width=100
    for i=0,5 do
      gfx.setColor(gfx.kColorWhite)
      gfx.fillRect(i*seg_width-30,0,seg_width, 50)
      gfx.setColor(gfx.kColorBlack)
      gfx.drawRect(i*seg_width-30,0,seg_width, 50)
    end
  gfx.popContext()

  local wall_blurred = wall_img:blurredImage(1, 3, gfx.image.kDitherTypeBayer8x8)
  Wall.super.init(self)

  self:add()
  self:setZIndex(-99)
  self:setCenter(0,0)
  self:moveTo(0,100)
  self:setImage(wall_blurred)
end


-- eh, particles
class("Spark").extends(gfx.sprite)
local spark1_img = gfx.image.new(1,1)
  gfx.pushContext(spark1_img)
  gfx.drawPixel(0,0)
  gfx.popContext()
local spark2_img = gfx.image.new(10,10)
  gfx.pushContext(spark2_img)
  gfx.drawLine(5,0,5,10)
  gfx.drawLine(0,5,10,5)
  gfx.popContext()
local spark3_img = gfx.image.new(7,7)
  gfx.pushContext(spark3_img)
  gfx.drawLine(0,0,7,7)
  gfx.drawLine(0,7,7,0)
  gfx.popContext()
local spark_img = {spark1_img, spark2_img, spark3_img}

function Spark:init(x,y)
  Spark.super.init(self)
  self:setImage(spark_img[math.random(1,3)])
  self:moveTo(x,y)
  self.velocity = math.random(30,50)
  self.direction = math.random(0,360)
  self.start_time = playdate.getCurrentTimeMilliseconds()
  self:add()
end

function Spark:update()
  local new_x = self.x + self.velocity * math.cos(self.direction)
  local new_y = self.y + self.velocity * math.sin(self.direction)
  self:moveTo(new_x, new_y)
  local age = playdate.getCurrentTimeMilliseconds() - self.start_time
  if age >= 100 then self:remove() end
end


