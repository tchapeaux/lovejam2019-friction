local World = require('world')
local Player = require('player')

local Level1 ={}

function Level1:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Level1:init() 
    love.physics.setMeter(64) --the height of a meter our worlds will be 64px

    self.world = World:new()

    self.scrollTimer = 0

    self.objects = {} -- table to hold all our physical objects
   
    self.objects.ground = {}
    self.objects.ground.body = love.physics.newBody(self.world._w, wScr/2, 500) --remember, the shape (the rectangle we create next) anchors to the body from its center, so we have to move it to (650/2, 650-50/2)
    self.objects.ground.body:setAngle(math.pi / 4)
    self.objects.ground.shape = love.physics.newRectangleShape(200, 50) --make a rectangle with a width of 650 and a height of 50
    self.objects.ground.fixture = love.physics.newFixture(self.objects.ground.body, self.objects.ground.shape); --attach shape to body
   
    self.player = Player:new(self.world._w)

    -- edges of the world
    self.objects.edges = {}
    local edgeLeft = {}
    edgeLeft.body = love.physics.newBody(self.world._w, 0, 2500)
    edgeLeft.shape = love.physics.newRectangleShape(100, 5000)
    edgeLeft.fixture = love.physics.newFixture(edgeLeft.body, edgeLeft.shape); --attach shape to body
    table.insert(self.objects.edges, edgeLeft)
    local edgeRight = {}
    edgeRight.body = love.physics.newBody(self.world._w, wScr, 2500)
    edgeRight.shape = love.physics.newRectangleShape(100, 5000)
    edgeRight.fixture = love.physics.newFixture(edgeRight.body, edgeRight.shape); --attach shape to body
    table.insert(self.objects.edges, edgeRight)


    self.objects.walls = {}
    for i = 1,10 do
      local blockLeft = {}
      blockLeft.body = love.physics.newBody(self.world._w, 100, 50 + 500 * i)
      blockLeft.shape = love.physics.newRectangleShape(0, 0, 50, 300)
      blockLeft.fixture = love.physics.newFixture(blockLeft.body, blockLeft.shape, 5) -- A higher density gives it more mass.
      table.insert(self.objects.walls, blockLeft)
    end

    for i = 1,10 do
      local blockRight = {}
      blockRight.body = love.physics.newBody(self.world._w, wScr - 100, 100 + 500 * i)
      blockRight.shape = love.physics.newRectangleShape(0, 0, 50, 300)
      blockRight.fixture = love.physics.newFixture(blockRight.body, blockRight.shape, 5) -- A higher density gives it more mass.
      -- blockRight.fixture:setFriction(1)
      table.insert(self.objects.walls, blockRight)
    end

    for i = 1, 10 do
        local blockDiagonal = {}
        blockDiagonal.body = love.physics.newBody(self.world._w, wScr / 2, 75 + 500 * i)
        blockDiagonal.body:setAngle(-math.pi / 4 + (-1 * (i % 2)) * math.pi / 2)
        blockDiagonal.shape = love.physics.newRectangleShape(0, 0, 200, 50)
        blockDiagonal.fixture = love.physics.newFixture(blockDiagonal.body, blockDiagonal.shape, 5) -- A higher density gives it more mass.
        table.insert(self.objects.walls, blockDiagonal)
      end

    --initial graphics setup
    love.graphics.setBackgroundColor(0.41, 0.53, 0.97) --set the background color to a nice blue

end

function Level1:update(dt) 
    self.world:update(dt) --this puts the world into motion
    
    self.scrollTimer = self.scrollTimer + dt;

    self.player:update(dt)
end

function Level1:draw() 
    self.world:draw()

  -- love.graphics.translate(0, self.scrollTimer * -100)

    love.graphics.setColor(0.28, 0.63, 0.05) -- set the drawing color to green for the ground
    love.graphics.polygon("fill", self.objects.ground.body:getWorldPoints(self.objects.ground.shape:getPoints())) -- draw a "filled in" polygon using the ground's coordinates
   
    self.player:draw() 
    
    love.graphics.setColor(0.20, 0.20, 0.20) -- set the drawing color to grey for the blocks
    for i=1,#self.objects.walls do
      love.graphics.polygon("fill", self.objects.walls[i].body:getWorldPoints(self.objects.walls[i].shape:getPoints()))
    end

    love.graphics.setColor(94 / 255, 8 / 255, 2 / 255) -- set the drawing color to grey for the blocks
    for i=1,#self.objects.edges do
      love.graphics.polygon("fill", self.objects.edges[i].body:getWorldPoints(self.objects.edges[i].shape:getPoints()))
    end

end

return Level1
