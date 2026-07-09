-- Globals

Projectile = {}
Wall = {}
gravity = 980
dragging = false

-- Projectile Stuff

function Projectile:new()
    obj = {
        position = {
            x = 0,
            y = 0
        },
        velocity = {
            x = 0,
            y = 0
        },
        startPosition = {
            x = 0,
            y = 0
        },
        speed = 5,
        size = 10,
        canMove = false
    }
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Projectile:update(dt)
    if self.canMove then
        self.velocity.y = self.velocity.y + gravity * dt
    end

    self.position.x = self.position.x + self.velocity.x * dt
    self.position.y = self.position.y + self.velocity.y * dt
end

function Projectile:draw()
    love.graphics.circle('fill', self.position.x, self.position.y, self.size)
end

function Projectile:mousereleased()
    if not self.canMove then
        self:launch()
    end
end

function Projectile:launch()
    self.canMove = true
    dragging = false

    vector_x = love.mouse.getX()
    vector_y = love.mouse.getY()
    
    direction_x = self.startPosition.x - vector_x 
    direction_y = self.startPosition.y - vector_y 

    self.velocity.x = direction_x * self.speed
    self.velocity.y = direction_y * self.speed
end

-- Wall Stuff

function Wall:new(obj)
    obj = obj or {
        position = {
        x = 0,
        y = 0
        },
        dimensions = {
            w = 0, 
            h = 0,
        },
    }
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Wall:update()
    
end

function Wall:draw()
    love.graphics.polygon('fill', self:getVertices())
end

function Wall:getVertices()
    return {
        self.position.x, self.position.y,
        self.position.x + self.dimensions.w,  self.position.y,
        self.position.x + self.dimensions.w, self.position.y + self.dimensions.h,
        self.position.x, self.position.y + self.dimensions.h,
    }
end

-- Love stuff 

function love.load()
    projectiles = {}
    wall = Wall:new({
        position = {
        x = 1490,
        y = 0
        },
        dimensions = {
            w = 10, 
            h = 720,
        },
    })
    floor = Wall:new({
        position = {
        x = 0,
        y = 710
        },
        dimensions = {
            w = 1500, 
            h = 10,
        },
    })
end

function love.update(dt)

    if not dragging then
        if love.mouse.isDown(1) then
            projectile = Projectile:new()

            mouse_x = love.mouse.getX()
            mouse_y = love.mouse.getY()

            projectile.position.x = mouse_x
            projectile.position.y = mouse_y

            projectile.startPosition.x = mouse_x
            projectile.startPosition.y = mouse_y
            
            projectile.canMove = false
            dragging = true

            table.insert(projectiles, projectile)
        end
    end

    for i, p in ipairs(projectiles) do
        p:update(dt)
    end
end

function love.mousereleased() 
    for i, p in ipairs(projectiles) do
        p:mousereleased(dt)
    end
end

function love.draw()
    if dragging then
        love.graphics.line(mouse_x, mouse_y, love.mouse.getX(), love.mouse.getY())
    end
    
    for i, p in ipairs(projectiles) do
        p:draw()
    end

    wall:draw()
    floor:draw()    
end