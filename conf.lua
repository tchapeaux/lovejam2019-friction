function love.conf(t)
    t.version = "11.0"                  -- The LÖVE version this game was made for (string)
    t.accelerometerjoystick = false      -- Enable the accelerometer on iOS and Android by exposing it as a Joystick (boolean)

    t.audio.mixwithsystem = true        -- Keep background music playing when opening LOVE (boolean, iOS and Android only)
 
    t.window.title = "The frictionful life of a finger"         -- The window title (string)
    t.window.icon = "assets/icon.png"                 -- Filepath to an image to use as the window's icon (string)
    t.window.width = 500                -- The window width (number)
    t.window.height = 500               -- The window height (number)
end