import "decorations.lua"
-- import "sounds.lua"

local gfx <const> = playdate.graphics
local SWAY <const> = 10
local SUCCESS_TIME <const> = 100
local FAIL_TIME <const> = 400
local POS_X = 200
local POS_Y = 200
local TOLERANCE <const> = 20
local img_close <const> = gfx.image.new("img/wheelgun.png")
local img_far <const> = gfx.image.new("img/wheelgun_sm.png")


class("Wheelgun").extends(gfx.sprite)


function Wheelgun:init(wheel)
    self.reticle = Reticle(self)
    self:attach(wheel)
    local width, height = self:getSize()
    self.state = "ready"
    self:setZIndex(200)
    self:setImage(img_close)
    local w,h = self:getImage():getSize()
    self.rotation = 0
    self.mode = "loosen"
    self:setCenter(0.5, 0.15)
    self:add()
end

function Wheelgun:update()
  if self.wheel.num_nuts == 1 then
    self.rotation = 90

  else
    self.rotation = (playdate.getCrankPosition() + 270) % 360
  end

  if  self.state == "ready" then
      self:setImage(img_close)
      local dx = SWAY * math.cos(math.rad(self.rotation))
      local dy = SWAY * .75 * math.sin(math.rad(self.rotation))
      self:moveTo(POS_X+dx , POS_Y+dy)

      if playdate.buttonJustPressed(playdate.kButtonUp) then
        
        nut = self:try(self.wheel, self.rotation)
      end
  elseif self.state == "success" then
      self:moveTo(nut.x, nut.y)
      if self.mode == "loosen" then
        self.wheel:remove_nut(nut.pos)
      elseif self.mode == "tighten" then
        self.wheel:add_nut(nut.pos)
      end

      self.state = "pause"
      playdate.timer.performAfterDelay(SUCCESS_TIME, starburst, self.x, self.y+10)
      playdate.timer.performAfterDelay(SUCCESS_TIME, self.reset, self)

  elseif self.state == "fail" then
    local x,y = 200, 140

    -- is wheel in position?
    if self.wheel.state == "waiting" or self.wheel.car.state == "waiting" then
      x = self.wheel.x + 25 * math.cos(math.rad(self.rotation))
      y = self.wheel.y + 25 * math.sin(math.rad(self.rotation))
    end
    self:moveTo(x+math.random(-5,5), y+math.random(-5,5))
  end

end


function Wheelgun:try(wheel)
  local nuts = wheel.nuts
  local rotation

  if self.wheel.num_nuts == 1 then
    rotation = nuts[1]:getRotation()
  else 
    rotation = self.rotation
  end

  if self.mode == "loosen" and self.wheel.car.state == "waiting" then
    self:setImage(img_far)
    for i = 1, #nuts do
        local nut = nuts[i]
        local target = nut:getRotation()
        if nut.is_present and (target - TOLERANCE) < rotation and rotation < (target + TOLERANCE) then
            self.state = "success"
            return nut
        end
    end
    self.state = "fail"

  elseif self.mode == "tighten" and self.wheel.state == "waiting" then
    self:setImage(img_far)
    for i = 1, #nuts do
        local nut = nuts[i]
        local target = nut:getRotation()
        if not nut.is_present and (target - TOLERANCE) < rotation and rotation < (target + TOLERANCE) then
            self.state = "success"
            return nut
        end
    end
  end


  self.state = "fail"
  playdate.timer.performAfterDelay(FAIL_TIME, self.reset, self)
  return false
end

function Wheelgun:exhaust()
  puff(self.x, self.y+50)
end

function Wheelgun:attach(wheel)
  self.wheel = wheel
  self.reticle:setVisible(true)
end

function Wheelgun:detach()
  self.reticle:setVisible(false)
end

function Wheelgun:reset()
    self.state = "ready"
    --playdate.timer.performAfterDelay(10, self.exhaust, self)
end

