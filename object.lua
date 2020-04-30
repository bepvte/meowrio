class = require("lib/30log/30log")
vector = require("lib/hump/vector")

object = class("object")

function object:init(file)
	self.scale = vector(1,1)
	self.origin = vector(0,0)
	self.file = file
end

function object:load()
	self.image = love.graphics.newImage(self.file)
	world:add(self, self.loc.x, self.loc.y, self.image:getWidth(), self.image:getHeight())
end

function object:update(dt)
	world:update(self, self.loc.x, self.loc.y)
end

function object:draw()
	love.graphics.draw(self.image, self.loc.x, self.loc.y,0, self.scale.x, self.scale.y, self.origin.x, self.origin.y)
end

return object
