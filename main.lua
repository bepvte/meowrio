

class = require "lib/30log/30log"
bump = require "lib/bump/bump"
screen = require "lib/shack/shack"
tick = require "lib/tick/tick"
player = require("player")
utf8 = require("utf8")
camera = require("lib/hump/camera")(102 + 64 * 2, 170 - 16, 2)
debug = os.getenv("DEBUG")
cmap = os.getenv("MAP")
if debug then
  inspect = require "lib/inspect/inspect"
end

map = require("map")
gamestate = 1

worklist = {
  player
}

currentconsole = ""

function love.load()
  if map.map == 5 then 
    love.event.quit()
  end
  tick.rate = 1 / 60
  love.graphics.setDefaultFilter("linear", "nearest")
  world = bump.newWorld()
  map:load()

  for _, item in pairs(worklist) do
    item:load()
  end

  camera.x, camera.y = player.loc.x, player.loc.y - 100
end

function love.update(dt)
  dt = math.min(1 / 60, dt)
  if player.cameramode == 1 then
    camera:lockPosition(player.loc.x + 150, player.loc.y, player:camera(7, "x"))-- snap camera: player:camera(7)
  elseif player.cameramode == 2 then
    camera:lockPosition(player.loc.x - 150, player.loc.y, player:camera(7, "x"))
  elseif player.cameramode == 3 then
    camera:lockPosition(player.loc.x, player.loc.y + 150, player:camera(7, "y"))
  elseif player.cameramode == 4 then
    camera:lockPosition(player.loc.x, player.loc.y - 90, player:camera(7, "y"))
  end
  for _, item in pairs(worklist) do
    item:update(dt)
  end
  screen:update(dt)
  if player.console then
    love.keyboard.setTextInput(true)
  else
    love.keyboard.setTextInput(false)
  end
end

function love.keypressed(key)
  if player.console then
    if key == "backspace" then
      -- get the byte offset to the last UTF-8 character in the string.
      local byteoffset = utf8.offset(currentconsole, -1)

      if byteoffset then
        -- remove the last UTF-8 character.
        -- string.sub operates on bytes rather than UTF-8 characters, so we couldn't do string.sub(text, 1, -2).
        currentconsole = string.sub(currentconsole, 1, byteoffset - 1)
      end
    elseif key == "return" then
      loadstring(currentconsole)()
      currentconsole = 0
      player.console = false
    end
  end
end

function love.textinput(t)
  currentconsole = currentconsole .. t
end

function love.draw()
  if player.console == true then
    love.graphics.setColor(0,0,0,128)
    love.graphics.rectangle("fill", 0, 0, 500, 20)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.print(currentconsole, 5, 5)
  end
  if debug then
    local x, y = love.mouse.getPosition()
    local camerax, cameray = camera:cameraCoords(love.mouse.getPosition())
    love.graphics.print(
    x ..
    " " ..
    y ..
    "\n" ..
    player.vel.x ..
    " " ..
    player.loc.y ..
    "\n" ..
    love.timer.getFPS() ..
    "\n" ..
    love.timer.getAverageDelta() ..
    "\n" ..
    camerax .. " " .. cameray
    )
  end
  if player.gamestate == 1 then
    screen:apply()
    camera:attach()
    love.graphics.setBackgroundColor(135, 206, 235)
    love.graphics.setColor(255, 255, 255, 255)
    map:draw()
    for _, item in pairs(worklist) do
      item:draw()
    end
    camera:detach()
  elseif player.gamestate == 2 then
    love.graphics.print("you died", love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, 0, 5, 5)
    if losetime == nil then
      losetime = love.timer.getTime()
    elseif love.timer.getTime() - losetime >= 1 then
      player.gamestate = 1
      player.loc = map.spawn:clone()
      world:update(player, player.loc.x, player.loc.y)
      losetime = nil
    end
  elseif player.gamestate == 4 then
    love.graphics.setColor(255, 0, 0)
    love.graphics.print("YOU WIN", love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, 0, 5, 5)
    if wintime == nil then
      wintime = love.timer.getTime()
    elseif love.timer.getTime() - wintime >= 3 then
      map.map = map.map + 1
      love.load()
      player.gamestate = 1
      wintime = nil
    end
  end
end

math.sign = function(n)
  return (n < 0) and -1 or ((n > 0) and 1 or 0)
end
