local Game = require("game")

function love.load()
    wScr = 800
    hScr = 800

    game = Game:new()
    game:init()

    love.window.setMode(wScr, hScr)
  end

  function love.update(dt)
    game:update(dt)  
  end
   
  function love.draw()
    game:draw()
  end