import "ui.lua"
import "game.lua"
import "CoreLibs/timer"

local gfx <const> = playdate.graphics
local f1_img = gfx.image.new("img/car_f1.png")
-- local f1_blurred = f1_img:blurredImage(2, 3, gfx.image.kDitherTypeDiagonalLine)


class("Car").extends(gfx.sprite)

function Car:init(num_nuts, car_type)
  Car.super.init(self)
  self:setImage(f1_img)
  self:setCenter(.22, .64)
  self:add()
  self:setZIndex(-1)
  -- self:roll_in()
  self.num_nuts = num_nuts
  self.car_type = car_type
  self.wheel = OldWheel(self)
  self.rear_wheel = RearWheel(self)
  self.timer_started = false
  self.state = "notify"
  self.incoming_note = RaceText("Car incoming!", 80, 30)
  self:moveTo(0,-500)
end

function Car:update()

  if self.state == "notify" then
    if self.incoming_note:ended() then
      self.incoming_note:remove()
      self:roll_in()
    end
  else
    if self.state == "new" and self.a:ended() then
      self.state = "waiting"
      pit_time = PitTimer()
      self.timer_started = true
      self.start_time = playdate.getCurrentTimeMilliseconds()
    end

    if self.wheel.state == "ready" and self.timer_started then
      pit_time:remove()
      self:roll_out()
      self.timer_started = false
    end

    if self.wheel.state == "gone" then
        self.wheel:remove()
        self.wheel = NewWheel(game.car)
        game.wheelgun:attach(self.wheel)
        game.wheelgun.mode = "tighten"
    end
    self:moveTo(self.a:currentValue())
  end

end

function Car:elapsed_time()
  return playdate.getCurrentTimeMilliseconds() - self.start_time
end

function Car:roll_out()
  self.state = "rollout"
    FlashTime(playdate.getCurrentTimeMilliseconds() - self.start_time)
    local durations = {150, 1200}
    local ls1 = playdate.geometry.lineSegment.new(200,100, 200,140)
    local ls2 = playdate.geometry.lineSegment.new(200,140, -2000, 140)
    local easings = {playdate.easingFunctions.outBack, playdate.easingFunctions.inQuint}
    self.a = gfx.animator.new(durations, {ls1, ls2}, easings)
    playdate.timer.performAfterDelay(1000, function() Puff() end)
    playdate.timer.performAfterDelay(durations[1]+durations[2], function(x) game.state = "waiting" end)
end

function Car:roll_in()
  self.state = "new"
    local durations = {800, 100}
    local ls1 = playdate.geometry.lineSegment.new(1500,140, 200,140)
    local ls2 = playdate.geometry.lineSegment.new(200,140, 200, 100)
    local easings = {playdate.easingFunctions.outQuint, playdate.easingFunctions.linear}
    self.a = gfx.animator.new(durations, {ls1, ls2}, easings)
end

function Car:remove()
  self.rear_wheel:remove()
  self.wheel:remove()
  gfx.sprite.remove(self)
end

function Car:get_axle()
  return playdate.geometry.point.new(self.x, math.min(140, self.y + 30))
end

