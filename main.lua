map = require("map")

class = require "lib/30log/30log"
bump = require "lib/bump/bump"
screen = require "lib/shack/shack"
player = require("player")
utf8 = require("utf8")

debug = os.getenv("DEBUG")
if debug then
    inspect = require "lib/inspect/inspect"
end

gamestate = 1

worklist = {
    player
}

currentconsole = ""

function love.load()
    love.graphics.setDefaultFilter("linear", "nearest")
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
    if player.console then
        love.graphics.setColor(128, 128, 128, 128)
        love.graphics.rectangle("fill", 0, 0, 500, 20)
        love.graphics.setColor(255, 255, 255, 255)
        love.graphics.print(currentconsole, 5, 5)
    end
    if debug then
        local x, y = love.mouse.getPosition()
        love.graphics.print(
            x ..
                " " ..
                    y ..
                        "\n" ..
                            player.loc.x ..
                                " " ..
                                    player.loc.y .. "\n" .. love.timer.getFPS() .. "\n" .. love.timer.getAverageDelta()
        )
    end
    if player.gamestate == 1 then
        screen:apply()
        love.graphics.push()
        love.graphics.scale(2, 2)
        love.graphics.translate(player.camerax, 0)
        love.graphics.setBackgroundColor(135, 206, 235)
        love.graphics.setColor(255, 255, 255, 255)
        map:draw()
        for _, item in pairs(worklist) do
            item:draw()
        end
        love.graphics.pop()
    elseif player.gamestate == 2 then
        love.graphics.print("game over.", love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, 0, 5, 5)
    elseif player.gamestate == 4 then
        love.graphics.setColor(255, 0, 0)
        love.graphics.print("YOUR WIN", love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, 0, 5, 5)
    end
end
