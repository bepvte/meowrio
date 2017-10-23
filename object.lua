class = require "lib/30log/30log"
vector = require "lib/hump/vector"
object = class("object")

function object:init(file)
	self.loc = vector(0,0)
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
	love.graphics.draw(self.image, self.loc:unpack())
end

return object