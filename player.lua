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
    self.loc = vector(2, 100)
    self.camerax = 0
    self.animations = {}
    self.frame = 1
    self.rot = 0
    self.gamestate = 1
    self.console = false
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
    player.super.load(self)
    table.insert(self.animations, love.graphics.newImage("gfx/meow.png"))
    table.insert(self.animations, love.graphics.newImage("gfx/jump.png"))
end

function player:controls(dt)
    if player.console then
        return
    end
    if love.keyboard.isDown("w") or love.keyboard.isDown("space") then
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
        self.gamestate = 1
        self.vel = vector(0, 0)
        self.acc = vector(0, 0)
        self.loc = vector(100, 100)
        world:update(self, self.loc.x, self.loc.y)
        self.camerax = 0
    elseif love.keyboard.isDown("q") then
        love.event.quit()
    elseif love.keyboard.isDown("`") then
        self.console = not self.console
    end
end

function player:update(dt)
    if love.keyboard.isDown("w") or love.keyboard.isDown("space") then
        self.gravity.y = 0.5
    else
        self.gravity.y = 1
    end

    if not self:groundcollide() then
        self.acc = self.acc + self.gravity
    else
        self.frame = 1
        self.rot = math.rad((self.loc.x % 2 * 15)) -- just fucking complete wizardry i made on accident it
        -- good news: less wizardry
        self.vel.y = 0
    end

    if player:roofcollide() then
        self.vel.y = 0
    end

    player:controls(dt)

    self.acc = self.acc * self.weight
    self.vel = self.vel + self.acc
    self.vel.x = self.vel.x * self.friction
    local goalX, goalY = (self.loc + self.vel * dt):unpack()
    self.acc.y, self.acc.x = 0, 0
    self.loc.x, self.loc.y, cols, _ = world:move(self, goalX, goalY, self.collidefunc)

    -- cameron
    if self.loc.x >= 130 - self.camerax then
        self.camerax = self.camerax - (self.loc.x + self.camerax) * 2 * dt
    end

    -- lose cond
    if self.loc.y >= 300 and not love.keyboard.isDown("r") then
        self.gamestate = 2
        -- keeps it from flipping out on my cpu
        self.vel = vector(0, 0)
        self.acc = vector(0, 0)
        self.loc = vector(100, 100)
        world:update(self, self.loc.x, self.loc.y)
    end
end

function player:jomp(dt)
    if self:groundcollide() then
        self.vel.y = -9 * self.weight
        self.frame = 2
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

player.collidefunc = function(item, other)
    if other.name == "win" then
        item.gamestate = 4
        return "touch"
    elseif other.name == "tile" then
        return "slide"
    end
end

return player("gfx/meow.png")
