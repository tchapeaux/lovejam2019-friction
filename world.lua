local World = {};

function World:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self

    o._w = love.physics.newWorld(0, 9.81*64, true)

    local _beginContact = function(fixA, fixB, coll)
        o:beginContact(fixA, fixB, coll)
    end

    o._w:setCallbacks(_beginContact, nil, nil, nil)

    o.particles = {}

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
        love.graphics.draw(pS, 0, 0)
    end
end


function World:beginContact(fixA, fixB, coll)
    local x, y = coll:getPositions()
    local pS = love.graphics.newParticleSystem(assets.particle, 10)

    pS:setPosition(x, y)
    pS:setColors(1, 1, 1, 1, 1, 1, 1, 1)
    pS:setDirection(-math.pi/4)
    pS:setSpread(math.pi/4)
    pS:setSizes(1)
    pS:setSpeed(100)
    pS:setBufferSize(2)
    pS:setEmissionRate(10)
    pS:setParticleLifetime(1)
    pS:setEmitterLifetime(1)
    pS:setSizes(0.5, 0.3, 0.1)
    
    pS:start()
    
    table.insert(self.particles, pS)
end

return World;
