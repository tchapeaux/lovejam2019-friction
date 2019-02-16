local Level1 = require("level1")
local Level2 = require("level2")
local Title = require("title")

function love.load()
    wScr = 600
    hScr = 600

    assets = {}
    assets.credit_card = love.graphics.newImage("assets/credt-card.png")
    assets.fifty_cents = love.graphics.newImage("assets/fifty-cents.png")
    assets.finger = love.graphics.newImage("assets/finger.png")
    assets.one_euro = love.graphics.newImage("assets/one-euro.png")
    assets.particle = love.graphics.newImage("assets/particle.png")
    assets.phone = love.graphics.newImage("assets/phone.png")
    assets.scissors = love.graphics.newImage("assets/scissors.png")
    assets.title = love.graphics.newImage("assets/titleScreenStart.png")
    assets.two_euros = love.graphics.newImage("assets/two-euros.png")
    assets.wallet = love.graphics.newImage("assets/wallet.png")

    currentView = Title:new()

    love.window.setMode(wScr, hScr)
end

function love.update(dt)
    currentView:update(dt)  
end
   
function love.draw()
    currentView:draw()
end

function love.keypressed(key, scancode, isrepeat) 
    if key == "o" then
        currentView = Level1:new()
        currentView:init()
    elseif key == "p" then
        currentView = Level2:new()
        currentView:init()
    elseif key == 'escape' then
      love.event.quit()
    end
end