local gameState = "menu"

local player = { x = 100, y = 100, size = 20 }
local walls = {}

function love.load()
    -- Definir las coordenadas de las paredes (forma de "M")
    walls = {
        { x = 50, y = 50, width = 20, height = 200 },
        { x = 70, y = 50, width = 80, height = 20 },
        { x = 150, y = 50, width = 20, height = 200 },
        { x = 150, y = 50, width = 80, height = 20 },
        { x = 150, y = 230, width = 20, height = 200 }
    }
end

function love.update(dt)
    if gameState == "game" then
        -- Actualizar el juego solo cuando estamos en el estado "game"
        -- Manejar la entrada del teclado
        if love.keyboard.isDown("w") and player.y > 0 then
            player.y = player.y - 200 * dt
        end
        if love.keyboard.isDown("a") and player.x > 0 then
            player.x = player.x - 200 * dt
        end
        if love.keyboard.isDown("s") and player.y + player.size < love.graphics.getHeight() then
            player.y = player.y + 200 * dt
        end
        if love.keyboard.isDown("d") and player.x + player.size < love.graphics.getWidth() then
            player.x = player.x + 200 * dt
        end

        -- Verificar colisiones con las paredes
        for _, wall in ipairs(walls) do
            if checkCollision(player, wall) then
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
        love.graphics.print("1. Jugar", 200, 150)
        love.graphics.print("2. Ver Cómo Jugar", 200, 170)
        love.graphics.print("3. Salir", 200, 190)
    elseif gameState == "game" then
        -- Dibujar el juego solo cuando estamos en el estado "game"
        love.graphics.setColor(255, 255, 255)
        for _, wall in ipairs(walls) do
            love.graphics.rectangle("fill", wall.x, wall.y, wall.width, wall.height)
        end

        love.graphics.setColor(0, 255, 0)
        love.graphics.rectangle("fill", player.x, player.y, player.size, player.size)
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

-- Función para verificar colisiones entre dos rectángulos
function checkCollision(a, b)
    return a.x < b.x + b.width and
           a.x + a.size > b.x and
           a.y < b.y + b.height and
           a.y + a.size > b.y
end
