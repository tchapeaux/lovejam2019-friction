local Anim2 ={}

function Anim2:new(onEndCb)
    local o = {}
    setmetatable(o, self)
    self.__index = self

    o.onEndCb = onEndCb
    o.step = 1

    o.images = {}
    o.images[1] = assets.anim_2_1
    o.images[2] = assets.anim_2_2
    
    o.texts = {}
    o.texts[1] = "OH NON MON TICKET"
    o.texts[2] = "IL EST DANS MON SAC"

    o.textTimer = 0
    return o
end

function Anim2:init() 

end

function Anim2:update(dt) 
    self.textTimer = self.textTimer + dt * 20
end


function Anim2:keypressed(key, scancode, isrepeat)
    if key == 'return' and not isrepeat then
        self:nextStep()
    end
end

function Anim2:nextStep()
    self.step = self.step + 1
    self.textTimer = 0
    if (self.step > #self.images) then
        self.onEndCb()
    end
end

function Anim2:draw() 
    love.graphics.setBackgroundColor(0, 0, 0)

    local text = string.sub(
        self.texts[self.step],
        1, self.textTimer
    )
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(self.images[self.step], 0, 0)
    love.graphics.setColor(0, 0, 0)
    love.graphics.setFont(assets.fontMedium)
    love.graphics.printf(text, 10, hScr * 0.7, wScr - 20, 'center')
end

return Anim2