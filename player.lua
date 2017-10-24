object = require "object"
class = require "lib/30log/30log"
screen = require "lib/shack/shack"

player = object:extend("player")

function player:init(file)
    player.super.init(self, file)
    self.acc = vector(0, 0)
    self.vel = vector(0, 0)
    self.gravity = vector(0, 1)
    self.friction = 0.8
    self.weight = 100
    self.loc = vector(100, 100)
    self.camerax = 0
    self.animations = {}
    self.frame = 1
end

function player:draw()
    love.graphics.draw(
        self.image,
        self.loc.x + self.image:getWidth() / 2,
        self.loc.y + self.image:getHeight() / 2,
        math.floor(self.loc.x) * 245.23,
        self.scale.x,
        self.scale.y,
        self.image:getWidth() / 2,
        self.image:getHeight() / 2
    )
end

function player:load()
    player.super.load(self)
    table.insert(self.animations, love.graphics.newImage("gfx/meow.png"))
    table.insert(self.animations, love.graphics.newImage("gfx/meow2.png"))
end

function player:controls(dt)
    if love.keyboard.isDown("w") then
        self:jomp(dt)
    end
    if love.keyboard.isDown("a") then
        self.acc.x = -1
        self.scale.x, self.origin.x = -1, self.image:getWidth()
    end

    if love.keyboard.isDown("d") then
        self.acc.x = 1
        self.scale.x, self.origin.x = 1, 0
    end
    if love.keyboard.isDown("r") then
        love.event.quit("restart")
    end
end

function player:update(dt)
    if love.keyboard.isDown("w") then
        self.gravity.y = 0.5
    else
        self.gravity.y = 1
    end

    if not self:groundcollide() then
        self.acc = self.acc + self.gravity
    else
        self.vel.y = 0
    end

    player:controls(dt)

    self.acc = self.acc * self.weight
    self.vel = self.vel + self.acc
    self.vel.x = self.vel.x * self.friction
    local goalX, goalY = (self.loc + self.vel * dt):unpack()
    self.acc.y, self.acc.x = 0, 0
    self.loc.x, self.loc.y, cols, _ = world:move(self, goalX, goalY)

    if self.loc.x >= 130 - self.camerax then
        self.camerax = self.camerax - (self.loc.x + self.camerax) * dt
    end

    -- lose cond
    if self.loc.y >= 300 then
        gamestate = 2
    end
end

function player:jomp(dt)
    if self:groundcollide() then
        self.vel.y = -9 * self.weight
    end
end

function player:groundcollide()
    local actualx, actualy = world:check(self, self.loc.x, self.loc.y + 1)
    if actualy ~= self.loc.y + 1 then
        return true
    end
end

return player("gfx/meow.png")
