function love.load()
    particle = {
        x = 10,
        y = 500,
        vx = 90,
        vy = 0
    }

    black_hole = {
        x = 750,
        y = 360
    }
end

function love.update(dt)
    vector_x = black_hole.x - particle.x
    vector_y = black_hole.y - particle.y

    distance = math.sqrt(vector_x ^ 2 + vector_y ^ 2)

    direction_x = vector_x / distance
    direction_y = vector_y / distance

    force = 1e7 / (distance * distance)

    particle.vx = particle.vx + direction_x * force * dt
    particle.vy = particle.vy + direction_y * force * dt

    particle.x = particle.x + particle.vx * dt
    particle.y = particle.y + particle.vy * dt
end

function love.draw()
    love.graphics.circle("fill", black_hole.x, black_hole.y, 10)
    love.graphics.circle("fill", particle.x, particle.y, 10)
end