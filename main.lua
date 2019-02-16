require('load-assets')

local Anim2 = require('anim2')
local Level1 = require("level1")
local Level2 = require("level2")
local Title = require("title")

function love.load()
    wScr = 600
    hScr = 600

    currentView = Title:new()
    currentView:init()

    love.window.setMode(wScr, hScr)
end

function love.update(dt)
    currentView:update(dt)  
end
   
function love.draw()
    currentView:draw()
end

function love.keypressed(key, scancode, isrepeat) 
    if currentView.keypressed then
        currentView:keypressed(key, scancode, isrepeat)
    end

    if key == "o" then
        assets.music.title:stop()

        currentView = Level1:new()
        currentView:init()
    elseif key == "p" then
        assets.music.title:stop()
        function goToLevel2()
            currentView = Level2:new()
            currentView:init()    
        end

        currentView = Anim2:new(goToLevel2)
        currentView:init()
    elseif key == 'escape' then
      love.event.quit()
    end
end