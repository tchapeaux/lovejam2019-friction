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
    assets.music.level2:stop()
    assets.music.level2:play()

    self.world = World:new()

    self.scrollStart = false
    self.scrollTimer = 0
    self.scrollSpeed = 100

    self.objects = {} -- table to hold all our physical objects
   
    self.player = Player:new(self.world._w)
    self.isGameOver = false
    self.isYouWin = false

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
    o.body = love.physics.newBody(self.world._w, wScr / 3, 300)
    o.shape = love.physics.newRectangleShape(2 * wScr / 2, 50)
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
    local nbOfObjects = 40
    math.randomseed(51934)
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

    -- ticket
    self.objects.ticket = {}
    objectFromSprite(self.objects.ticket, self.world._w, assets.ticket, false)
    self.objects.ticket.body:setPosition(wScr / 2, self.endOfObjects + 200)
    self.objects.ticket.fixture:setUserData('ticket')

    -- GROUND below ticket
    local o ={}
    o.body = love.physics.newBody(self.world._w, wScr / 2, self.endOfObjects + 250)
    o.shape = love.physics.newRectangleShape(wScr, 20)
    o.fixture = love.physics.newFixture(o.body, o.shape, 1)
    o.fixture:setFriction(0.6)
    self.objects.ground = o

    --initial graphics setup
    love.graphics.setBackgroundColor(61 / 255, 30 / 255, 12 / 255)
end

function Level2:update(dt) 
    self.world:update(dt) --this puts the world into motion
    
    if not self.isGameOver and self.scrollStart then
      self.scrollTimer = self.scrollTimer + dt

      -- bound
      self.scrollTimer = math.min(self.scrollTimer, (self.endOfObjects + 290 - hScr) / self.scrollSpeed)
    end

    if not self.scrollStart then
      local sX, sY = self.player.body:getLinearVelocity()
      if sX ~= 0 then
        self.scrollStart = true
      end
    end

    self.player:update(dt)

    -- Check if player is dead
    local _, y = self.player.body:getWorldCenter()
    if not self.isGameOver and (
      y + self.player.shapeHeight / 2 < self.scrollTimer * self.scrollSpeed
      or y - self.player.shapeHeight / 2> self.scrollTimer * self.scrollSpeed + hScr
    ) then
        assets.music.level2:stop()
        self.isGameOver = true
    end

    -- Check winning condition
    local collisionList = self.world._w:getContactList()

    for i=1,#collisionList do
      local fixA, fixB = collisionList[i]:getFixtures ()
      if fixA:getUserData() == 'ticket' or fixB:getUserData() == 'ticket' then
        self.isYouWin = true
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

    -- ticket draw
    drawSpriteObject(self.objects.ticket)

    love.graphics.setColor(94 / 255, 8 / 255, 2 / 255)
    for i=1,#self.objects.edges do
      love.graphics.polygon("fill", self.objects.edges[i].body:getWorldPoints(self.objects.edges[i].shape:getPoints()))
    end

    if self.isGameOver then
      love.graphics.translate(0, self.scrollTimer * self.scrollSpeed)


      love.graphics.setColor(1, 0, 0)
      love.graphics.setFont(assets.fonts.fontBig)
      love.graphics.printf("YOU DIED", 0, hScr / 2 - 50, wScr, "center")
    end

    if self.isYouWin then
      love.graphics.translate(0, self.scrollTimer * self.scrollSpeed)


      love.graphics.setColor(0, 0, 1)
      love.graphics.setFont(assets.fonts.fontBig)
      love.graphics.printf("YOU WIN", 0, hScr / 2 - 50, wScr, "center")

    end
  end

return Level2