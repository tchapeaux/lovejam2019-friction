require('helpers')
local Player = {}

function Player:new(world)
    local o = {}
    setmetatable(o, self)
    self.__index = self

    o.world = world

    objectFromSprite(o, world, assets.finger, true)
    o.body:setPosition(wScr/2, 10)
    o.body:setFixedRotation(true)
    o.body:setLinearDamping(0.5)

    return o
end

function Player:update(dt)
    --here we are going to create some keyboard events
    if love.keyboard.isDown("right") then --press the right arrow key to push the ball to the right
      self.body:applyForce(1000, 0)
    end
    if love.keyboard.isDown("left") then --press the left arrow key to push the ball to the left
      self.body:applyForce(-1000, 0)
    end
    if love.keyboard.isDown("up") then --press the left arrow key to push the ball to the left
      self.body:applyForce(0, -2000)
    end
    if love.keyboard.isDown("return") then --press the up arrow key to set the ball in the air
      self.scrollTimer = 0
      self.body:setPosition(wScr / 2, 10)
      self.body:setLinearVelocity(0, 0) --we must set the velocity to zero to prevent a potentially large velocity generated by the change in position
    end

    
    local vx, vy = self.body:getLinearVelocity() 
    if vy < 0 then
        self.body:setLinearVelocity(vx, 0)
    end
end

function Player:draw(dt)
    love.graphics.setColor(1, 1, 1)

    local posX, posY = self.body:getWorldCenter()

    -- love.graphics.polygon("fill", self.body:getWorldPoints(self.shape:getPoints()))
    love.graphics.draw(
        self.sprite,
        posX - self.shapeWidth / 2,
        posY - self.shapeHeight / 2
    )
end

return Player