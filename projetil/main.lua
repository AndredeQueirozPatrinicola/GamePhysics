gravity = 9.8

function love.load()
    projectile = {
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
        }
    }
    isDragging = false
end

function love.update(dt)
    projectile.velocity.y = projectile.velocity.y + gravity * dt

    if love.mouse.isDown(1) and not isDragging then
        mouse_x = love.mouse.getX()
        mouse_y = love.mouse.getY()
        projectile.pos = {x= mouse_x, y = mouse_y}
        projectile.velocity.y = 0
        projectile.startDragPos.x = mouse_x
        projectile.startDragPos.y = mouse_y
        isDragging = true
    end

    if isDragging then 
        if love.mouse.isDown(2) then
            vector_x = love.mouse.getX()
            vector_y = love.mouse.getY()

            direction_x = mouse_x - vector_x 
            direction_y = mouse_y - vector_y             

            projectile.velocity = {
                x = direction_x * 0.10,
                y = direction_y * 0.10
            }
            isDragging = false
        end
    else 
        projectile.pos.x = projectile.pos.x + projectile.velocity.x
        projectile.pos.y = projectile.pos.y + projectile.velocity.y
    end 

    
end 


function love.draw()
    love.graphics.circle('fill', projectile.pos.x, projectile.pos.y, 10)
end