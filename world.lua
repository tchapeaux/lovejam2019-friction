local World = {};

function World:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self

    self._w = love.physics.newWorld(0, 9.81*64, true)

    local _beginContact = function(fixA, fixB, coll)
        self:beginContact(fixA, fixB, coll)
    end

    self._w:setCallbacks(_beginContact, nil, nil, nil)

    self.particles = {}

    return o
end

function World:update(dt)
    self._w:update(dt)

    for i = 1, #self.particles  do
        local pS = self.particles[i]
        pS:update(dt)
    end
end


function World:draw()
    love.graphics.setColor(1, 1, 1)
    for i = 1, #self.particles do
        local pS = self.particles[i]
        print(pS.count)
        print(pS:getCount())
        love.graphics.draw(pS, 0, 0)
    end
end


function World:beginContact(fixA, fixB, coll)
    local x, y = coll:getPositions()
    local pS = love.graphics.newParticleSystem(assets.particle, 10)

    pS:setPosition(x, y)
    pS:setColors(1, 1, 1, 1, 1, 1, 1, 1)
    pS:setDirection(- math.pi / 4)
    pS:setSpread(2 * math.pi)
    pS:setSizes(1)
    pS:setSpeed(100)
    pS:setBufferSize(10)
    pS:setEmissionRate(10)
    pS:setParticleLifetime(5)
    
    pS:start()
    
    table.insert(self.particles, pS)
end

return World;