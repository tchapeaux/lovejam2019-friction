
local GameOver ={}

function GameOver:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function GameOver:init()
    assets.music.gameOver:play()

    self.textTimer = 0
end

function GameOver:update(dt)
    self.textTimer = self.textTimer + dt
end

function GameOver:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(assets.gameOver, 0, 0)

    if (self.textTimer > 1) then
        local alpha = math.min((self.textTimer - 1) / 2, 0.6)

        love.graphics.setColor(0, 0, 0, alpha)
        love.graphics.rectangle("fill", 0, hScr*0.85, wScr, hScr*0.15)

        love.graphics.setColor(1, 1, 1, alpha)
        love.graphics.setFont(assets.fonts.fontMedium)
        love.graphics.printf("Press enter to retry", 0, hScr * 0.85, wScr, "center")
    end
end

function GameOver:keypressed(key, scancode, ispressed)

    if key == 'return' then
        assets.music.gameOver:stop()
        currentView = Level2:new()
        currentView:init()
    end

end

return GameOver
