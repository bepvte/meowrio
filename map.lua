class = require "lib/30log/30log"

local map = class("map")
tilesize = 64

function map:init(tiles)
    self.tiles = {
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0},
        {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0}
    }
end

function map:load()
    for y, row in pairs(self.tiles) do
        for x, val in pairs(row) do
            if val == 1 then
                world:add(
                    {name = "tile", x = x, y = y},
                    x * tilesize - tilesize,
                    y * tilesize - tilesize,
                    tilesize,
                    tilesize
                )
            end
        end
    end
end

function map:draw()
    for y, row in pairs(self.tiles) do
        for x, val in pairs(row) do
            if val == 1 then
                love.graphics.rectangle("fill", x * tilesize - tilesize, y * tilesize - tilesize, tilesize, tilesize)
            end
        end
    end
end

return map()
