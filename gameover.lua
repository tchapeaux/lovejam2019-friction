
local GameOver ={}

function GameOver:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function GameOver:init()
    assets.music.gameOver:play()

end

function GameOver:update(dt)

end

function GameOver:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(assets.gameOver, 0, 0)
end

function GameOver:keypressed(key, scancode, ispressed)

    if key == 'return' then
        assets.music.gameOver:stop()
        currentView = Level2:new()
        currentView:init()
    end

end

return GameOver
