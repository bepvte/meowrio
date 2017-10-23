map = require("map")

class = require "lib/30log/30log"
bump = require "lib/bump/bump"

player = require("player")("gfx/meow.png")

worklist = {
    player
}
function love.load()
    world = bump.newWorld()
    for _, item in pairs(worklist) do
        item:load()
    end
    map:load()
end

function love.update(dt)
    for _, item in pairs(worklist) do
        item:update(dt)
    end
end

function love.draw()
    love.graphics.setBackgroundColor(128, 128, 128)
    map:draw()
    for _, item in pairs(worklist) do
        item:draw()
    end
end
