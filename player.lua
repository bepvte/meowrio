-- note: this isnt a physicsobject because i am gay
object = require "object"
class = require "lib/30log/30log"
screen = require "lib/shack/shack"

player = object:extend("player")

function player:init(file)
  player.super.init(self, file)
  self.vel = vector(0, 0)
  self.gravity = vector(0, 64 * 16)
  self.friction = 64 * 9
  self.loc = nil
  self.animations = {}
  self.frame = 1
  self.rot = 0
  self.gamestate = 1
  self.console = false
  self.doomy = 0
  self.cameramode = 1

  self.SPEED = 64 * 15
  self.MAXVEL = 64 * 6
  self.SLIDE = 8

  self.JUMP = -(self.gravity.x + (64 * 7))
end

function player:draw()
  love.graphics.draw(
    self.animations[self.frame],
    self.loc.x + self.image:getWidth() / 2,
    self.loc.y + self.image:getHeight() / 2,
    self.rot,
    self.scale.x,
    self.scale.y,
    self.image:getWidth() / 2,
    self.image:getHeight() / 2
  )
  if debug then
    love.graphics.line(self.loc.x, self.loc.y, self.loc.x + self.image:getWidth(), self.loc.y)
    love.graphics.line(
      self.loc.x,
      self.loc.y + self.image:getHeight(),
      self.loc.x + self.image:getWidth(),
      self.loc.y + self.image:getHeight()
    )
  end
end

function player:load()
  table.insert(self.animations, love.graphics.newImage("gfx/meow.png"))
  table.insert(self.animations, love.graphics.newImage("gfx/jump.png"))
  self.loc = map.spawn:clone()
  self.doomy = map.doomy
  player.super.load(self)
end

function player:controls(dt)
  if player.console then
    return
  end
  if love.keyboard.isDown("w") or love.keyboard.isDown("space") and self.vel.y < 0 then
    if self:groundcollide() then
      self.vel.y = self.JUMP
      self.frame = 2
    end
  end
  if love.keyboard.isDown("a") then
    if self.vel.x > 0 then
      self.vel.x = self.vel.x - (self.SLIDE * dt)
    else
      self.vel.x = math.max(self.vel.x - (self.SPEED * dt), -self.MAXVEL)
    end
    self.scale.x, self.origin.x = -1, self.image:getWidth()
  end

  if love.keyboard.isDown("d") then
    if self.vel.x < 0 then
      self.vel.x = self.vel.x + (self.SLIDE * dt)
    else
      self.vel.x = math.min(self.vel.x + (self.SPEED * dt), self.MAXVEL)
    end
    self.scale.x, self.origin.x = 1, 0
  end
  if love.keyboard.isDown("r") then
    self.gamestate = 1
    self.vel = vector(0, 0)
    self.loc = map.spawn:clone()
    world:update(self, self.loc.x, self.loc.y)
    camera:lookAt(player.loc.x, player.loc.y)
  elseif love.keyboard.isDown("q") then
    love.event.quit()
  elseif love.keyboard.isDown("`") then
    self.console = not self.console
  end
end

function player:update(dt)
  if love.keyboard.isDown("w") or love.keyboard.isDown("space") then
    -- self.gravity.y = 5
  else
    -- self.gravity.y = 100
  end

  if not self:groundcollide() then
    self.vel = self.vel + (self.gravity * dt)
  else
    self.frame = 1
    self.rot = math.rad((math.ceil(self.loc.x) % 2.5 * 10))
    self.vel.y = 0
  end

  if player:roofcollide() then
    self.vel.y = 10
  end
  if player:sidecollide() then
    self.vel.x = 0
  end

  player:controls(dt)

  self.vel.x = self.vel.x - (self.friction * dt) * math.sign(self.vel.x)
  if math.abs(self.vel.x) <= 4 then
    self.vel.x = 0
  end
  local goalX, goalY = (self.loc + self.vel * dt):unpack()
  self.loc.x, self.loc.y, cols, _ = world:move(self, goalX, goalY, self.collidefunc)

  for i = 1, #cols do
    if cols[i].other.name == "camera" and player:groundcollide() then
      self.cameramode = cols[i].other.direction
    end
  end
  -- lose cond
  if self.loc.y >= map.doomy and not love.keyboard.isDown("r") then
    self.gamestate = 2
    -- keeps it from flipping out on my cpu
    self.vel = vector(0, 0)
    --self.loc = map.spawn:clone()
    world:update(self, self.loc.x, self.loc.y)
  end
end

function player:roofcollide()
  local actualx, actualy = world:check(self, self.loc.x, self.loc.y - 1, self.collidefunc)
  if actualy ~= self.loc.y - 1 then
    return true
  end
end
function player:groundcollide()
  local actualx, actualy = world:check(self, self.loc.x, self.loc.y + 1, self.collidefunc)
  if actualy ~= self.loc.y + 1 then
    return true
  end
end

function player:sidecollide()
  local actualx, actualy = world:check(self, self.loc.x + 1, self.loc.y, self.collidefunc)
  if actualx ~= self.loc.x + 1 then
    return true
  end
  actualx, actualy = world:check(self, self.loc.x - 1, self.loc.y, self.collidefunc)
  if actualx ~= self.loc.x - 1 then
    return true
  end
end
function player:camera(stiffness, locker)
  assert(type(stiffness) == "number", "Invalid parameter: stiffness = " .. tostring(stiffness))
  if locker == "x" then
    return function(dx, dy, s)
      if player:groundcollide() then
        local dts = love.timer.getDelta() * (s or stiffness)
        return dx * dts, dy * dts
      else
        local dts = love.timer.getDelta() * (s or stiffness)
        return dx * dts, 0
      end
    end
  elseif locker == "y" then
    return function(dx, dy, s)
      if player:groundcollide() then
        local dts = love.timer.getDelta() * (s or stiffness)
        return dx * dts, dy * dts
      else
        local dts = love.timer.getDelta() * (s or stiffness)
        return 0, dy * dts
      end
    end
  end
  return function(dx, dy, s)
    if player:groundcollide() then
      local dts = love.timer.getDelta() * (s or stiffness)
      return dx * dts, dy * dts
    else
      return 0, 0
    end
  end
end

player.collidefunc = function(item, other)
  if other.name == "win" then
    other.name = "stupidest fucking workaround i have ever made i hate life and "
    item.gamestate = 4
    return "cross"
  elseif other.name == "tile" then
    return "slide"
  else
    return "cross"
  end
end
-- this is dumb! this its udumb!
function player:whee()
  self.gravity = vector(0,0)
  self.controls = function(self, dt)
    if player.console then
      return
    end
    if love.keyboard.isDown("w") or love.keyboard.isDown("space") and self.vel.y < 0 then
      self.loc.y = self.loc.y - 10
    end
    if love.keyboard.isDown("a") then
      self.loc.x = self.loc.x - 10
    end
    if love.keyboard.isDown("s") then
      self.loc.y = self.loc.y + 10
    end
    if love.keyboard.isDown("d") then
      self.loc.x = self.loc.x +10
    end
    if love.keyboard.isDown("r") then
      self.gamestate = 1
      self.vel = vector(0, 0)
      self.loc = map.spawn:clone()
      world:update(self, self.loc.x, self.loc.y)
      camera:lookAt(player.loc.x, player.loc.y)
    elseif love.keyboard.isDown("q") then
      love.event.quit()
    elseif love.keyboard.isDown("`") then
      self.console = not self.console
    end
  end
end
return player("gfx/meow.png")
