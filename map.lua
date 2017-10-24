class = require "lib/30log/30log"

local map = class("map")
tilesize = 32

function map:init(tiles)
    self.tiles = {
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 0, 3},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3},
        {
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            3,
            0,
            0,
            0,
            0,
            2
        },
        {
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            0,
            0,
            0,
            0,
            1,
            0,
            0,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1
        }
    }
end

function map:load()
    self.animation = {love.graphics.newImage("gfx/tile3.png"), love.graphics.newImage("gfx/tile2.png")}
    self.win = love.graphics.newImage("gfx/goal.png")
    self.brick = love.graphics.newImage("gfx/brick.png")
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
            elseif val == 2 then
                world:add(
                    {name = "win", x = x, y = y},
                    x * tilesize - tilesize,
                    y * tilesize - tilesize,
                    tilesize,
                    tilesize
                )
            elseif val == 3 then
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
                love.graphics.draw(
                    self.animation[x % 6 ~= 0 and 1 or 2],
                    -- self.animation[math.floor(math.random(1, #self.animation))],
                    -- this is hell dont do that ahajk
                    x * tilesize - tilesize,
                    y * tilesize - tilesize
                )
            elseif val == 2 then
                love.graphics.draw(self.win, x * tilesize - tilesize, y * tilesize - tilesize)
            elseif val == 3 then
                love.graphics.draw(self.brick, x * tilesize - tilesize, y * tilesize - tilesize)
            end
        end
    end
end

return map()
