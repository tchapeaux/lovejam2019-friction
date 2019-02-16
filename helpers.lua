function objectFromSprite(o, world, sprite, isDynamic)
    o = o or {}

    local _d = isDynamic and 'dynamic' or 'static' -- ternary operator

    o.body = love.physics.newBody(world, 0, 0, _d)
    o.sprite = sprite
    o.shapeWidth = o.sprite:getWidth()
    o.shapeHeight = o.sprite:getHeight()
    o.shape = love.physics.newRectangleShape(o.shapeWidth, o.shapeHeight)
    o.fixture = love.physics.newFixture(o.body, o.shape, 1)

    return o
end


function drawSpriteObject(spriteObject)
    love.graphics.setColor(1, 1, 1)

    local posX, posY = spriteObject.body:getWorldCenter()

    -- love.graphics.polygon("fill", spriteObject.body:getWorldPoints(spriteObject.shape:getPoints()))
    love.graphics.draw(
        spriteObject.sprite,
        posX - spriteObject.shapeWidth / 2,
        posY - spriteObject.shapeHeight / 2
    )
end