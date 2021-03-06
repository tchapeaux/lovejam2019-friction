local Title ={}

function Title:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Title:init() 
    assets.music.title:play()
    love.graphics.setBackgroundColor(107 / 255, 191 / 255, 227 / 255)

    self.fadeTimer = 0
end

function Title:update(dt) 
    self.fadeTimer = self.fadeTimer + dt
end

function Title:draw() 
    love.graphics.setColor(1, 1, 1, math.min(self.fadeTimer * 2, 1))

    love.graphics.draw(assets.title, 0, 0)

    love.graphics.setFont(assets.fonts.fontNormal)
    love.graphics.printf('PRESS ENTER TO START', 0, hScr * 0.8, wScr, 'center')
end

function Title:keypressed(key, scancode, ispressed) 
    if key == "return" then
        assets.music.title:stop()

        currentView = Anim2:new()
        currentView:init()
    end
end

return Title