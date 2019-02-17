local YouWin ={}

function YouWin:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function YouWin:init() 

end

function YouWin:update(dt) 

end

function YouWin:draw() 
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(assets.youWin, 0, 0)
end

function YouWin:keypressed(key, scancode, ispressed) 

end

return YouWin