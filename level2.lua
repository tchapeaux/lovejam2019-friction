local World = require('world')
local Player = require('player')

local Level2 ={}

function Level2:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Level2:init() 
    love.physics.setMeter(64) --the height of a meter our worlds will be 64px

    assets.music.level2:stop()
    assets.music.level2:play()

    self.world = World:new()

    self.scrollTimer = 0

    self.objects = {} -- table to hold all our physical objects
   
    self.player = Player:new(self.world._w)

    -- edges of the world
    self.objects.edges = {}
    local edgeLeft = {}
    edgeLeft.body = love.physics.newBody(self.world._w, 0, 2500)
    edgeLeft.shape = love.physics.newRectangleShape(100, 5000)
    edgeLeft.fixture = love.physics.newFixture(edgeLeft.body, edgeLeft.shape); --attach shape to body
    edgeLeft.fixture:setFriction(0.6)
    table.insert(self.objects.edges, edgeLeft)
    local edgeRight = {}
    edgeRight.body = love.physics.newBody(self.world._w, wScr, 2500)
    edgeRight.shape = love.physics.newRectangleShape(100, 5000)
    edgeRight.fixture = love.physics.newFixture(edgeRight.body, edgeRight.shape); --attach shape to body
    table.insert(self.objects.edges, edgeRight)
    edgeRight.fixture:setFriction(0.6)


    self.objects.tutorialArea = {}

    local o ={}
    o.body = love.physics.newBody(self.world._w, wScr / 5, 300)
    o.shape = love.physics.newRectangleShape(2 * wScr / 3, 50)
    o.fixture = love.physics.newFixture(o.body, o.shape, 1)
    o.fixture:setFriction(0.6)
    table.insert(self.objects.tutorialArea, o)

    self.objects.walls = {}
    local _sprites = {
        assets.level2.credit_card,
        assets.level2.fifty_cents,
        assets.level2.phone,
        assets.level2.scissors,
        assets.level2.one_euro,
        assets.level2.two_euros,
        assets.level2.wallet
    }
    for i = 1,50 do
      local newBlock = {}
      objectFromSprite(newBlock, self.world._w, _sprites[1 + (i % #_sprites)], false)
      newBlock.body:setPosition(
          0.1 * wScr + math.random() * (0.8 * wScr),
           400 + 100 * i + ((-0.5 + math.random()) * 50) 
      )
      table.insert(self.objects.walls, newBlock)
    end

    --initial graphics setup
    love.graphics.setBackgroundColor(61 / 255, 30 / 255, 12 / 255) --set the background color to a nice blue

end

function Level2:update(dt) 
    self.world:update(dt) --this puts the world into motion
    
    self.scrollTimer = self.scrollTimer + dt;

    self.player:update(dt)

    
end

function Level2:draw() 
    love.graphics.translate(0, self.scrollTimer * -100)

    self.world:draw()

    self.player:draw()
   
    love.graphics.setColor(0.20, 0.20, 0.20) -- set the drawing color to grey for the blocks
    for i=1,#self.objects.walls do
      drawSpriteObject(self.objects.walls[i])
    end

    love.graphics.setColor(94 / 255, 8 / 255, 2 / 255) -- set the drawing color to grey for the blocks
    love.graphics.polygon("fill", self.objects.tutorialArea[1].body:getWorldPoints(self.objects.tutorialArea[1].shape:getPoints()))


    for i=1,#self.objects.edges do
      love.graphics.polygon("fill", self.objects.edges[i].body:getWorldPoints(self.objects.edges[i].shape:getPoints()))
    end

end

return Level2