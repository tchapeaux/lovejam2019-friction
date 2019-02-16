local Title ={}

function Title:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Title:init() 

end

function Title:update(dt) 

end

function Title:draw() 
    love.graphics.setBackgroundColor(0, 0, 0)

    love.graphics.draw(assets.title, 0, 0)
end

return Title