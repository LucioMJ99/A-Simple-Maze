local gameState = "menu"

local laberinto
local menuOptions = {}
local player = { x = 100, y = 100, size = 8, speed = 100 }

-- Definir áreas de colisión para los obstáculos
local colisionables = {
    { x = 0, y = 0, width = 32, height = 600 },  -- Barras Blancas
    { x = 0, y = 0, width = 33, height = 33 },    -- Cuadrados
    { x = 0, y = 0, width = 96, height = 33 },    -- Rectángulos obstáculos
    { x = 0, y = 0, width = 32, height = 224 },   -- Separador de la M
    { x = 0, y = 593, width = 736, height = 7 }   -- Linea semi circular de abajo de todo
}

function love.conf(t)
    t.window.width = 800
    t.window.height = 600
    t.window.title = "A Simple Maze"
end

function love.load()
    -- Cargar imágenes para las opciones del menú
    menuOptions[1] = { image = love.graphics.newImage("Sprites/PlayButton.png"), x = 200, y = 150, width = 150, height = 50 }
    menuOptions[2] = { image = love.graphics.newImage("Sprites/RulesButton.png"), x = 200, y = 250, width = 150, height = 50 }
    menuOptions[3] = { image = love.graphics.newImage("Sprites/ExitButton.png"), x = 200, y = 350, width = 150, height = 50 }

    -- Intentar cargar la imagen del laberinto
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
    if gameState == "game" then
        -- Manejar la entrada del teclado para mover al jugador
        if love.keyboard.isDown("w") and player.y > 0 then
            player.y = player.y - player.speed * dt
        end
        if love.keyboard.isDown("a") and player.x > 0 then
            player.x = player.x - player.speed * dt
        end
        if love.keyboard.isDown("s") and player.y + player.size < love.graphics.getHeight() then
            player.y = player.y + player.speed * dt
        end
        if love.keyboard.isDown("d") and player.x + player.size < love.graphics.getWidth() then
            player.x = player.x + player.speed * dt
        end

        -- Verificar colisiones con los obstáculos
        for _, colisionable in ipairs(colisionables) do
            if checkCollision(player, colisionable) then
                -- Manejar la colisión como desees (en este caso, reiniciar la posición del jugador)
                player.x = 100
                player.y = 100
            end
        end
    end
end

function love.draw()
    if gameState == "menu" then
        -- Dibujar el menú principal
        love.graphics.print("Menu Principal", 200, 100)

        -- Dibujar las imágenes de las opciones del menú
        for _, option in ipairs(menuOptions) do
            love.graphics.draw(option.image, option.x, option.y)
        end
    elseif gameState == "game" then
        -- Guardar el color actual
        local r, g, b, a = love.graphics.getColor()

        -- Dibujar el laberinto
        love.graphics.setColor(255, 255, 255)  -- Restablecer el color a blanco
        love.graphics.draw(laberinto, 0, 0)

        -- Dibujar al jugador (cuadrado)
        love.graphics.setColor(0, 255, 0)
        love.graphics.rectangle("fill", player.x, player.y, player.size, player.size)

        -- Restablecer el color al valor original
        love.graphics.setColor(r, g, b, a)
    end
end

function love.mousepressed(x, y, button, istouch, presses)
    if gameState == "menu" then
        -- Verificar clic en las opciones del menú
        for _, option in ipairs(menuOptions) do
            if x >= option.x and x <= option.x + option.width and y >= option.y and y <= option.y + option.height then
                if option == menuOptions[1] then
                    gameState = "game"
                elseif option == menuOptions[2] then
                    print("Cómo jugar: Usa las teclas W, A, S y D para mover el cuadrado. Evita las paredes.")
                elseif option == menuOptions[3] then
                    love.event.quit()
                end
            end
        end
    end
end

-- Función para verificar colisiones entre dos rectángulos
function checkCollision(a, b)
    return a.x < b.x + b.width and
           a.x + a.size > b.x and
           a.y < b.y + b.height and
           a.y + a.size > b.y
end
