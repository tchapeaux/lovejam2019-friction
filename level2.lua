local Level2 ={}

function Level2:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Level2:init()
    assets.music.level2:stop()
    assets.music.level2:play()

    self.world = World:new()

    self.scrollStart = false
    self.scrollTimer = 0
    self.scrollSpeed = 100

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
    self.tutorialY = 300 -- used to trigger scroll
    o.body = love.physics.newBody(self.world._w, wScr / 3, self.tutorialY)
    o.shape = love.physics.newRectangleShape(2 * wScr / 2, 50)
    o.fixture = love.physics.newFixture(o.body, o.shape, 1)
    o.fixture:setFriction(0.6)
    table.insert(self.objects.tutorialArea, o)

    self.objects.walls = {}
    local _sprites = {
        assets.level2.credit_card,
        assets.level2.fifty_cents,
        assets.level2.phone,
        assets.level2.gumBox,
        assets.level2.one_euro,
        assets.level2.two_euros,
        assets.level2.wallet
    }
    local nbOfObjects = 30
    math.randomseed(51934) -- chosen arbitrarily
    for i = 1,nbOfObjects do
      local newBlock = {}
      objectFromSprite(newBlock, self.world._w, _sprites[1 + (i % #_sprites)], false)
      newBlock.body:setPosition(
          0.1 * wScr + math.random() * (0.8 * wScr),
          400 + 100 * i + ((-0.5 + math.random()) * 50)
      )
      table.insert(self.objects.walls, newBlock)
    end

    self.endOfObjects = 400 + nbOfObjects * 100 + 50

    -- LAST OBSTACLE above ticket
    local o = {}
    o.body = love.physics.newBody(self.world._w, wScr / 2, self.endOfObjects + 300)
    o.shape = love.physics.newRectangleShape(wScr * 0.7, 20)
    o.fixture = love.physics.newFixture(o.body, o.shape, 1)
    o.fixture:setFriction(0.6)
    self.objects.lastObstacles = o

    -- ticket
    self.objects.ticket = {}
    objectFromSprite(self.objects.ticket, self.world._w, assets.ticket, false)
    self.objects.ticket.body:setPosition(wScr / 2, self.endOfObjects + 400)
    self.objects.ticket.fixture:setUserData('ticket')

    -- GROUND below ticket
    local o2 ={}
    o2.body = love.physics.newBody(self.world._w, wScr / 2, self.endOfObjects + 500)
    o2.shape = love.physics.newRectangleShape(wScr, 20)
    o2.fixture = love.physics.newFixture(o2.body, o2.shape, 1)
    o2.fixture:setFriction(0.6)
    self.objects.ground = o2

    --initial graphics setup
    love.graphics.setBackgroundColor(61 / 255, 30 / 255, 12 / 255)
end

function Level2:update(dt)
    self.world:update(dt) --this puts the world into motion

    if self.scrollStart then
      self.scrollTimer = self.scrollTimer + dt

      -- bound
      self.scrollTimer = math.min(self.scrollTimer, (self.endOfObjects + 520 - hScr) / self.scrollSpeed)
    end

    if not self.scrollStart then
      local pX, pY = self.player.body:getWorldCenter()
      if pY > self.tutorialY then
        self.scrollStart = true
      end
    end

    self.player:update(dt)

    -- Check if player is dead
    local _, y = self.player.body:getWorldCenter()
    if y + self.player.shapeHeight / 2 < self.scrollTimer * self.scrollSpeed or y - self.player.shapeHeight / 2> self.scrollTimer * self.scrollSpeed + hScr then
        assets.music.level2:stop()
        currentView = GameOver:new()
        currentView:init()
    end

    -- Check winning condition
    local collisionList = self.world._w:getContacts()

    for i=1,#collisionList do
      local fixA, fixB = collisionList[i]:getFixtures ()
      if fixA:getUserData() == 'ticket' or fixB:getUserData() == 'ticket' then
        assets.music.level2:stop()

        currentView = YouWin:new()
        currentView:init()
      end
    end
  end

function Level2:draw()
    love.graphics.translate(0, self.scrollTimer * -self.scrollSpeed)

    self.world:draw()

    self.player:draw()

    for i=1,#self.objects.walls do
      drawSpriteObject(self.objects.walls[i])
    end

    -- rectangle blocks
    love.graphics.setColor(94 / 255, 8 / 255, 2 / 255)
    love.graphics.polygon("fill", self.objects.tutorialArea[1].body:getWorldPoints(self.objects.tutorialArea[1].shape:getPoints()))
    love.graphics.polygon("fill", self.objects.ground.body:getWorldPoints(self.objects.ground.shape:getPoints()))
    love.graphics.polygon("fill", self.objects.lastObstacles.body:getWorldPoints(self.objects.lastObstacles.shape:getPoints()))

    -- ticket draw
    drawSpriteObject(self.objects.ticket)

    love.graphics.setColor(94 / 255, 8 / 255, 2 / 255)
    for i=1,#self.objects.edges do
      love.graphics.polygon("fill", self.objects.edges[i].body:getWorldPoints(self.objects.edges[i].shape:getPoints()))
    end

    if not self.scrollStart then
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(assets.level2.instructions, 0, 0)
    end
  end

function Level2:keypressed(key, scancode, isrepeat)
    if key == "return" then
        currentView = Level2:new()
        currentView:init()
    end
end

return Level2
