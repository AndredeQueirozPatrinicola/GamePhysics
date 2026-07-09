gravity = 9.8


function getNewProjectile()
    return {
        pos = {
            x = 0,
            y = 0
        },
        velocity = {
            x = 0,
            y = 0
        },
        force = 0,
        startDragPos = {
            x = 0,
            y = 0
        },
        isBeingDragged = false
    }
end


function love.load()
    projectiles = {}
    isDragging = false
    mouse_x = 0
    mouse_y = 0
end

function love.update(dt)

    for i, p in ipairs(projectiles) do
        if not p.isBeingDragged then 
            p.velocity.y = p.velocity.y + gravity * dt
        end
    end

    if love.mouse.isDown(1) then
        if not isDragging then
            mouse_x = love.mouse.getX()
            mouse_y = love.mouse.getY()

            projectile = getNewProjectile()

            projectile.pos = {x= mouse_x, y = mouse_y}
            projectile.velocity.y = 0
            projectile.startDragPos.x = mouse_x
            projectile.startDragPos.y = mouse_y

            projectile.isBeingDragged = true
            isDragging = true

            table.insert(projectiles, projectile)            
        end
    end

    for i, p in ipairs(projectiles) do
        p.pos.x = p.pos.x + p.velocity.x
        p.pos.y = p.pos.y + p.velocity.y
    end
end

function love.mousereleased(x, y, button)
    if button == 1 then
        vector_x = love.mouse.getX()
        vector_y = love.mouse.getY()

        direction_x = mouse_x - vector_x 
        direction_y = mouse_y - vector_y             

        projectile.velocity = {
            x = direction_x * 0.05,
            y = direction_y * 0.05
        }

        isDragging = false
        projectile.isBeingDragged = false
    end
end

function love.draw()
    for i, p in ipairs(projectiles) do
        love.graphics.circle('fill', p.pos.x, p.pos.y, 10)
    end

    if isDragging then
        love.graphics.line(mouse_x, mouse_y, love.mouse.getX(), love.mouse.getY())
    end
end