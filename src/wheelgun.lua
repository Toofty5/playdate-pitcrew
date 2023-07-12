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


function Wheelgun:init()
    local width, height = self:getSize()
    self.state = "ready"
    self:setZIndex(200)
    self:setImage(img_close)
    local w,h = self:getImage():getSize()
    self.rotation = 0
    self.reticle = Reticle(self)
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
            nut = self:try(self.rotation, self.wheel.nuts)
        end
    elseif self.state == "success" then
        print("success")
        self:moveTo(nut.x, nut.y)
        self.wheel:remove_nut(nut.pos)
        self.state = "pause"
        playdate.timer.performAfterDelay(SUCCESS_TIME, self.reset, self)

    elseif self.state == "fail" then
        print("fail")
        local x = self.wheel.x + 25 * math.cos(math.rad(self.rotation)) + math.random(-5,5)
        local y = self.wheel.y + 25 * math.sin(math.rad(self.rotation)) + math.random(-5,5)
        self:moveTo(x, y)
    end

end


function Wheelgun:try(rotation, nuts)
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
end

function Wheelgun:attach(wheel)
  self.wheel = wheel
end

function Wheelgun:detach()
  self.wheel = nil
end

function Wheelgun:reset()
    self.state = "ready"
    print("ready")
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
