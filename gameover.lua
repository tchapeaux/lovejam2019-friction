local GameOver ={}

function GameOver:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function GameOver:init() 

end

function GameOver:update(dt) 

end

function GameOver:draw() 
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(assets.gameOver, 0, 0)
end

function GameOver:keypressed(key, scancode, ispressed) 

end

return GameOver