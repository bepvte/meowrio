
class = require "lib/30log/30log"
vector = require "lib/hump/vector"
inspect = require "lib/inspect/inspect"
enemy = require "enemy"

local map = class("map")
tilesize = 32

function map:init(tiles)
  self.tiles = {}
  self.map = cmap or 1
  self.doomy = 0
  self.spawn = vector(0, 0)
end

function map:load()
  local tilepng = love.image.newImageData("gfx/tilemap" .. self.map .. ".png")
  self.animation = {love.graphics.newImage("gfx/tile3.png"), love.graphics.newImage("gfx/tile2.png")}
  self.win = love.graphics.newImage("gfx/goal.png")
  self.brick = love.graphics.newImage("gfx/brick.png")
  self.tiles = {}
  for y = 0, tilepng:getHeight() - 1 do
    table.insert(self.tiles, {})

    for x = 0, tilepng:getWidth() - 1 do
      local r, g, b, a = tilepng:getPixel(x, y)
      r = r*255.0
      g = g*255.0
      b = b*255.0
      a = a*255.0
      if r == 0 and g == 255 and b == 0 then
        table.insert(self.tiles[y + 1], 1)
        world:add({name = "tile", x = x, y = y}, x * tilesize, y * tilesize, tilesize, tilesize)
      elseif r == 0 and g == 0 and b == 255 then
        table.insert(self.tiles[y + 1], 2)
        world:add({name = "win", x = x, y = y}, x * tilesize, y * tilesize, tilesize, tilesize)
      elseif r == 255 and b == 0 and g == 0 then
        table.insert(self.tiles[y + 1], 3)
        world:add({name = "tile", x = x, y = y}, x * tilesize, y * tilesize, tilesize, tilesize)
      elseif r == 255 and b == 255 and g == 0 then
        self.spawn = vector(x * tilesize, y * tilesize)
        table.insert(self.tiles[y + 1], 0)
      elseif r == 246 and g == 0 and b == 255 then
        table.insert(self.tiles[y + 1], 0)
        table.insert(worklist, enemy("gfx/enemy.png", vector(x*tilesize, y*tilesize)))
      elseif r == 255 and b == 0 and g == 255 then
        self.doomy = y * tilesize
        table.insert(self.tiles[y + 1], 0)
      end
        -- camera stuff below
      if a == 255 then
        map:upsert(self.tiles, y, x, 4)
        world:add({name = "camera", x = x, y = y, direction = 1}, x * tilesize, y * tilesize, tilesize, tilesize)
      elseif a == 0 then
        map:upsert(self.tiles, y, x, 5)
        world:add({name = "camera", x = x, y = y, direction = 2}, x * tilesize, y * tilesize, tilesize, tilesize)
      elseif a == 64 then
        map:upsert(self.tiles, y, x, 6)
        world:add({name = "camera", x = x, y = y, direction = 3}, x * tilesize, y * tilesize, tilesize, tilesize)
      elseif a == 128 then
        map:upsert(self.tiles, y, x, 7)
        world:add({name = "camera", x = x, y = y, direction = 4}, x * tilesize, y * tilesize, tilesize, tilesize)
      else
        table.insert(self.tiles[y + 1], 0)
      end
    end
  end
end
function map:upsert(tiles, y, x, num)
  if tiles[y+1][x+1] == nil then
    table.insert(tiles[y+1], num)
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
      else
        if debug then
          if val == 4 then
            love.graphics.setColor(0,1,0)
          elseif val == 5 then
            love.graphics.setColor(0,0,1)
          else
            love.graphics.setColor(1, 0, 0)
          end
          if vall ~= 0 then
            love.graphics.rectangle(
            "line",
            x * tilesize - tilesize,
            y * tilesize - tilesize,
            tilesize,
            tilesize
            )
          end
          -- love.graphics.print(x .. "\n" .. y, x * tilesize - tilesize, y * tilesize - tilesize)
          love.graphics.setColor(1,1,1)
        end
      end
    end
  end
end

return map()
