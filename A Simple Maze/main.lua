local gameState = "menu"


local laberinto

local menuOptions = {}

function love.conf(t)
    t.window.width = 800
    t.window.height = 600
    t.window.title = "A Simple Maze"
end

function love.load()
    
    -- Cargar imágenes para las opciones del menú
    menuOptions[1] = love.graphics.newImage("Sprites/PlayButton.png")
    menuOptions[2] = love.graphics.newImage("Sprites/RulesButton.png")
    menuOptions[3] = love.graphics.newImage("Sprites/ExitButton.png")
    local success = pcall(function()
    laberinto = love.graphics.newImage("Sprites/MapLevel-1.png")
    end)
   -- Verificar si la carga fue exitosa
   if not success or not laberinto then
    print("Error al cargar la imagen del laberinto.")
    love.event.quit()  -- Salir del juego en caso de error
end
end


function love.update(dt)
    
end

function love.draw()
    if gameState == "menu" then
        -- Dibujar el menú principal
        love.graphics.print("Menu Principal", 200, 100)
        
        -- Dibujar las imágenes de las opciones del menú
        love.graphics.draw(menuOptions[1], 200, 150)
        love.graphics.draw(menuOptions[2], 200, 250)
        love.graphics.draw(menuOptions[3], 200, 350)
    elseif gameState == "game" then
           -- Dibujar el laberinto
           love.graphics.draw(laberinto, 0, 0)
        end
end

function love.keypressed(key)
    if gameState == "menu" then
        -- Cambiar de estado según la opción seleccionada en el menú
        if key == "1" then
            gameState = "game"
        elseif key == "2" then
            -- Mostrar las instrucciones o información sobre cómo jugar
            print("Cómo jugar: Usa las teclas W, A, S y D para mover el cuadrado. Evita las paredes.")
        elseif key == "3" then
            love.event.quit() -- Salir del juego
        end
    end
end
