local Game ={}

function Game:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Game:init() 
    love.physics.setMeter(64) --the height of a meter our worlds will be 64px
    self.world = love.physics.newWorld(0, 9.81*64, true) --create a world for the bodies to exist in with horizontal gravity of 0 and vertical gravity of 9.81
    self.scrollTimer = 0

    self.objects = {} -- table to hold all our physical objects
   
    self.objects.ground = {}
    self.objects.ground.body = love.physics.newBody(self.world, wScr/2, 500) --remember, the shape (the rectangle we create next) anchors to the body from its center, so we have to move it to (650/2, 650-50/2)
    self.objects.ground.body:setAngle(math.pi / 4)
    self.objects.ground.shape = love.physics.newRectangleShape(200, 50) --make a rectangle with a width of 650 and a height of 50
    self.objects.ground.fixture = love.physics.newFixture(self.objects.ground.body, self.objects.ground.shape); --attach shape to body
   
    self.objects.player = {}
    self.objects.player.body = love.physics.newBody(self.world, wScr/2, 10, "dynamic") --place the body in the center of the world and make it dynamic, so it can move around
    self.objects.player.body:setFixedRotation(true)
    self.objects.player.body:setLinearDamping(0.5)
    self.objects.player.shape = love.physics.newRectangleShape(10, 10)
    self.objects.player.fixture = love.physics.newFixture(self.objects.player.body, self.objects.player.shape, 100) -- Attach fixture to body and give it a density of 1.
    self.objects.player.fixture:setRestitution(0.3) --let the ball bounce
    self.objects.player.fixture:setFriction(0.8)

    -- edges of the world
    self.objects.edges = {}
    local edgeLeft = {}
    edgeLeft.body = love.physics.newBody(self.world, 0, 2500)
    edgeLeft.shape = love.physics.newRectangleShape(100, 5000)
    edgeLeft.fixture = love.physics.newFixture(edgeLeft.body, edgeLeft.shape); --attach shape to body
    table.insert(self.objects.edges, edgeLeft)
    local edgeRight = {}
    edgeRight.body = love.physics.newBody(self.world, wScr, 2500)
    edgeRight.shape = love.physics.newRectangleShape(100, 5000)
    edgeRight.fixture = love.physics.newFixture(edgeRight.body, edgeRight.shape); --attach shape to body
    table.insert(self.objects.edges, edgeRight)


    self.objects.walls = {}
    for i = 1,10 do
      local blockLeft = {}
      blockLeft.body = love.physics.newBody(self.world, 100, 50 + 500 * i)
      blockLeft.shape = love.physics.newRectangleShape(0, 0, 50, 300)
      blockLeft.fixture = love.physics.newFixture(blockLeft.body, blockLeft.shape, 5) -- A higher density gives it more mass.
      table.insert(self.objects.walls, blockLeft)
    end

    for i = 1,10 do
      local blockRight = {}
      blockRight.body = love.physics.newBody(self.world, wScr - 100, 100 + 500 * i)
      blockRight.shape = love.physics.newRectangleShape(0, 0, 50, 300)
      blockRight.fixture = love.physics.newFixture(blockRight.body, blockRight.shape, 5) -- A higher density gives it more mass.
      table.insert(self.objects.walls, blockRight)
    end

    for i = 1, 10 do
        local blockDiagonal = {}
        blockDiagonal.body = love.physics.newBody(self.world, wScr / 2, 75 + 500 * i)
        blockDiagonal.body:setAngle(-math.pi / 4 + (-1 * (i % 2)) * math.pi / 2)
        blockDiagonal.shape = love.physics.newRectangleShape(0, 0, 200, 50)
        blockDiagonal.fixture = love.physics.newFixture(blockDiagonal.body, blockDiagonal.shape, 5) -- A higher density gives it more mass.
        table.insert(self.objects.walls, blockDiagonal)
      end

    --initial graphics setup
    love.graphics.setBackgroundColor(61 / 255, 30 / 255, 12 / 255) --set the background color to a nice blue

end

function Game:update(dt) 
    self.world:update(dt) --this puts the world into motion
    
    self.scrollTimer = self.scrollTimer + dt;

    --here we are going to create some keyboard events
    if love.keyboard.isDown("right") then --press the right arrow key to push the ball to the right
      self.objects.player.body:applyForce(1000, 0)
    elseif love.keyboard.isDown("left") then --press the left arrow key to push the ball to the left
      self.objects.player.body:applyForce(-1000, 0)
    elseif love.keyboard.isDown("up") then --press the left arrow key to push the ball to the left
      self.objects.player.body:applyForce(0, -2000)
    elseif love.keyboard.isDown("return") then --press the up arrow key to set the ball in the air
      self.scrollTimer = 0
      self.objects.player.body:setPosition(wScr / 2, 10)
      self.objects.player.body:setLinearVelocity(0, 0) --we must set the velocity to zero to prevent a potentially large velocity generated by the change in position
    end
  
end

function Game:draw() 
    love.graphics.translate(0, self.scrollTimer * -100)

    love.graphics.setColor(0.28, 0.63, 0.05) -- set the drawing color to green for the ground
    love.graphics.polygon("fill", self.objects.ground.body:getWorldPoints(self.objects.ground.shape:getPoints())) -- draw a "filled in" polygon using the ground's coordinates
   
    love.graphics.setColor(0.76, 0.18, 0.05) --set the drawing color to red for the ball
    love.graphics.polygon("fill", self.objects.player.body:getWorldPoints(self.objects.player.shape:getPoints()))
   
    love.graphics.setColor(0.20, 0.20, 0.20) -- set the drawing color to grey for the blocks
    for i=1,#self.objects.walls do
      love.graphics.polygon("fill", self.objects.walls[i].body:getWorldPoints(self.objects.walls[i].shape:getPoints()))
    end

    love.graphics.setColor(94 / 255, 8 / 255, 2 / 255) -- set the drawing color to grey for the blocks
    for i=1,#self.objects.edges do
      love.graphics.polygon("fill", self.objects.edges[i].body:getWorldPoints(self.objects.edges[i].shape:getPoints()))
    end

end

return Game