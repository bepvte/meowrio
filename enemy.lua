class = require("lib/30log/30log")
vector = require("lib/hump/vector")

object = require("object")
enemy = object:extend("enemy")

function enemy:init(file, loc)
  enemy.super.init(self, file)
  self.vel = vector(0, 0)
  self.gravity = vector(0, 64 * 16)
  self.friction = 0
  self.spawn = loc:clone()
  self.loc = nil

  self.direction = -1

  self.SPEED = 60
  self.MAXVEL = 60 -- dont think about this plaease:
  self.SLIDE = 8
end

function enemy:load()
  self.loc = self.spawn:clone()
  enemy.super.load(self)
end

function enemy:draw()
  love.graphics.draw(
    self.image,
    self.loc.x + self.image:getWidth() / 2,
    self.loc.y + self.image:getHeight() / 2,
    0,
    self.scale.x,
    self.scale.y,
    self.image:getWidth() / 2,
    self.image:getHeight() / 2
  )
end

function enemy:update(dt)
  if not self:groundcollide() then
    self.vel = self.vel + (self.gravity * dt)
  else
    self.vel.y = 0
  end

  if self:sidecollide() then
    self.direction = self.direction * -1
    self.vel.x = self.direction * 20
  end
  self.vel.x = self.vel.x + (self.SPEED * self.direction)
  self.vel.x = math.min(math.abs(self.vel.x), self.MAXVEL) * math.sign(self.vel.x)
  self.vel.x = self.vel.x - (self.friction * dt) * math.sign(self.vel.x)
  if math.abs(self.vel.x) <= 4 then
    self.vel.x = 0
  end

  local goalX, goalY = (self.loc + self.vel * dt):unpack()
  self.loc.x, self.loc.y, cols, _ = world:move(self, goalX, goalY, self.collidefunc)
  for i = 1, #cols do
    if cols[i].other.name == "player" and player:groundcollide() then
      cols[i].other.gamestate = 2
    end
  end
end

function enemy:groundcollide()
  local actualx, actualy = world:check(self, self.loc.x, self.loc.y + 1, self.collidefunc)
  if actualy ~= self.loc.y + 1 then
    return true
  end
end

function enemy:sidecollide()
  local actualx, actualy = world:check(self, self.loc.x + 1, self.loc.y, self.collidefunc)
  if actualx ~= self.loc.x + 1 then
    return true
  end
  actualx, actualy = world:check(self, self.loc.x - 1, self.loc.y, self.collidefunc)
  if actualx ~= self.loc.x - 1 then
    return true
  end
end

enemy.collidefunc = function(item, other)
  if other.name == "tile" then
    return "slide"
  else
    return "cross"
  end
end

return enemy
