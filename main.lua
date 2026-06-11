local create_lightning = require "create_lightning"

    S = create_lightning

function love.load()
    love.math.setRandomSeed(os.time())
    width, height = love.graphics.getDimensions()
    S:init(width/2, 0)
end

function love.update(dt)
    S:update(dt)

end

function love.draw()
    S:draw()
end

function love.keypressed(key)
    if key == "g" then
        S:init(width/2, 0)
    end

end
