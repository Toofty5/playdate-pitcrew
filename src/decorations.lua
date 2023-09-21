local gfx <const> = playdate.graphics


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
