gravity = 980
debug = {}

function love.load()
    object = {
        x = 10,
        y = 500,
        speed = 100,
        jump = 400,
        vx = 0,
        vy = 0
    }
end

function love.update(dt)
    debug.x = object.x
    debug.y = object.y
    debug.vx = object.vx
    debug.vy = object.vy


    if love.keyboard.isDown("a") then
        object.vx = -object.speed
    elseif love.keyboard.isDown("d") then
        object.vx = object.speed
    else
        object.vx = 0
    end

    if love.keyboard.isDown("space") then
        object.vy = -object.jump
    end

    object.vy = object.vy + gravity * dt

    object.x = object.x + object.vx * dt
    object.y = object.y + object.vy * dt
end

function love.draw()
     local y = 10

    for k,v in pairs(debug) do
        love.graphics.print(k .. ": " .. tostring(v), 10, y)
        y = y + 20
    end

    love.graphics.circle("fill", object.x, object.y, 10)
end