local gfx <const> = playdate.graphics
local SWAY <const> = 10
local SUCCESS_TIME <const> = 100
local FAIL_TIME <const> = 400
local POS_X = 200
local POS_Y = 200
local TOLERANCE <const> = 20
local img_close <const> = gfx.image.new("img/wheelgun.png")
local img_far <const> = gfx.image.new("img/wheelgun_sm.png")

local sfx <const> = playdate.sound
local synth = sfx.synth.new(playdate.sound.kWaveSawtooth)
local envelope = sfx.envelope.new(.05, .1,.2, .1)
envelope:setScale(-2)
synth:setADSR(.1, .2,.4,.2)
synth:setFrequencyMod(envelope)


class("Wheelgun").extends(gfx.sprite)


function Wheelgun:init(wheel)
    self.reticle = Reticle(self)
    self:attach(wheel)
    local width, height = self:getSize()
    self.state = "ready"
    self:setZIndex(500)
    self:setImage(img_close)
    local w,h = self:getImage():getSize()
    self.rotation = 0
    self.mode = "loosen"
    self:setCenter(0.5, 0.15)
    self:add()
end

function Wheelgun:update()
    self.rotation = (playdate.getCrankPosition() + 270) % 360
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
        playdate.timer.performAfterDelay(SUCCESS_TIME, self.reset, self)

    elseif self.state == "fail" then
        local x = self.wheel.x + 25 * math.cos(math.rad(self.rotation)) + math.random(-5,5)
        local y = self.wheel.y + 25 * math.sin(math.rad(self.rotation)) + math.random(-5,5)
        self:moveTo(x, y)
    end

end


function Wheelgun:try(wheel)
  synth:playNote(600, 1, .3)
  local nuts = wheel.nuts
  local rotation = self.rotation
  if self.mode == "loosen" then
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
    playdate.timer.performAfterDelay(FAIL_TIME, self.reset, self)
    return false

  elseif self.mode == "tighten" then
    self:setImage(img_far)
    for i = 1, #nuts do
        local nut = nuts[i]
        local target = nut:getRotation()
        if not nut.is_present and (target - TOLERANCE) < rotation and rotation < (target + TOLERANCE) then
            self.state = "success"
            return nut
        end
    end
    self.state = "fail"
    playdate.timer.performAfterDelay(FAIL_TIME, self.reset, self)
    return false

  end
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
end

