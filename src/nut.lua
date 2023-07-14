local gfx <const> = playdate.graphics
local nut_img <const>  = gfx.image.new("img/nut.png")
local no_nut_img <const>  = gfx.image.new("img/no_nut.png")
class("Nut").extends(gfx.sprite)

function Nut:init(wheel, pos, is_present)
    self.wheel = wheel
    self.pos = pos
    self:setZIndex(3)
    self.is_present = is_present
    if is_present then
      self:setImage(nut_img)
    else
      self:setImage(no_nut_img)
    end

    self:add()

end

function Nut:update()
    local rotation = self:getRotation()
    local x = self.wheel.x + self.wheel.nut_offset * math.cos(math.rad(rotation))
    local y = self.wheel.y + self.wheel.nut_offset * math.sin(math.rad(rotation))
    
    self:moveTo(x,y)
end

function Nut:getRotation()
    return (self.wheel.rotation + self.pos * 360/#(self.wheel.nuts)) % 360
end

function Nut:pop_off()
    self.is_present = false
    self:setImage(no_nut_img)
    LooseNut(self.x,self.y)
end

function Nut:put_on()
    self.is_present = true
    self:setImage(nut_img)
end

class("LooseNut").extends(gfx.sprite)
LooseNut.gravity = 10 

function LooseNut:init(x,y)
    self:setImage(gfx.image.new("img/nut.png"))
    self:setZIndex(10)
    local direction = math.random(210,330)
    local velocity = 40
    self.dx = velocity * math.cos(math.rad(direction))
    self.dy = velocity * math.sin(math.rad(direction))
    self:moveTo(x,y)
    self:add()
end

function LooseNut:update()
    if self.y > 220 then
        self:remove()
    else
        self.dy += self.gravity
        self:moveTo(self.x+self.dx, self.y+self.dy)
    end
    -- print("loose nut", self.x, self.y, self.dx, self.dy)
end
