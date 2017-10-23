object = require "object"
class = require "lib/30log/30log"

player = object:extend("player")

function player:init(file)
    player.super.init(self, file)
    self.acc = vector(0, 0)
    self.vel = vector(0, 0)
	self.friction = 0.5
	self.gravity = vector(0, 8)
	self.grounded = 1
end

function player:controls(dt)
	if love.keyboard.isDown('w') then
		player:jomp()
	end if love.keyboard.isDown('s') then
		-- uhh crouch i guess???
	end if love.keyboard.isDown('a') then
		self.acc = vector(-1, 0)
	end if love.keyboard.isDown('d') then
		self.acc = vector(1, 0)
	end
end

function player:update(dt)
	player:controls(dt)
	self.acc = self.acc * 1000 * dt	+ self.gravity
	self.vel = (self.vel + self.acc) * self.friction
    local goalX, goalY = (self.loc + self.vel):unpack()
    self.acc.y, self.acc.x = 0, 0
	self.loc.x, self.loc.y, cols, _ = world:move(self, goalX, goalY)
end

function player:jomp(dt)
	local actualx, actualy = world:check(self, self.loc.x, self.loc.y + 1)
	if actualy ~= self.loc.y + 1 then
		self.vel.y = -128
	end
end
return player