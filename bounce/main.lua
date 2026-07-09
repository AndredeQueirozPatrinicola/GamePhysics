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
        start_position = {
            x = 0,
            y = 0
        },
        speed = 5,
        radius = 10,
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
    love.graphics.circle('fill', self.position.x, self.position.y, self.radius)
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
    
    direction_x = self.start_position.x - vector_x 
    direction_y = self.start_position.y - vector_y 

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
        }
    }
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Wall:update(dt, obj)
    if(self:object_entered_area(obj)) then
        -- if obj.velocity.x < self.position.x then
        --     obj.velocity.x = obj.velocity.x * -1
        -- end
        -- if obj.velocity.y < self.position.y then
        --     obj.velocity.y = obj.velocity.y * -1
        -- end

        if self.type == 'vertical' then
            obj.velocity.x = obj.velocity.x * -1
        end 
        if self.type == 'horizontal' then 
            obj.velocity.y = obj.velocity.y * -1
        end
    end
end

function Wall:object_entered_area(obj) 
        return (
            (obj.position.x + obj.radius) >= self.position.x and 
            (obj.position.x + obj.radius) <= self.position.x + self.dimensions.w and
            (obj.position.y + obj.radius) >= self.position.y and
            (obj.position.y + obj.radius) <= self.position.y + self.dimensions.h
        )
end

function Wall:draw()
    love.graphics.polygon('fill', self:get_vertices())
end

function Wall:get_vertices()
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
    walls = {
        Wall:new({
            position = {
            x = 1470,
            y = 0
            },
            dimensions = {
                w = 50, 
                h = 720,
            },
            type = 'vertical'
        }),
        Wall:new({
            position = {
            x = 0,
            y = 700
            },
            dimensions = {
                w = 1500, 
                h = 20,
            },
            type = 'horizontal'
        }),
         Wall:new({
            position = {
            x = -20,
            y = 0
            },
            dimensions = {
                w = 50, 
                h = 720,
            },
            type = 'vertical'
        }),
    }
end

function love.update(dt)

    if not dragging then
        if love.mouse.isDown(1) then
            projectile = Projectile:new()

            mouse_x = love.mouse.getX()
            mouse_y = love.mouse.getY()

            projectile.position.x = mouse_x
            projectile.position.y = mouse_y

            projectile.start_position.x = mouse_x
            projectile.start_position.y = mouse_y
            
            projectile.canMove = false
            dragging = true

            table.insert(projectiles, projectile)
        end
    end

    for i, p in ipairs(projectiles) do
        p:update(dt)

        for i, w in ipairs(walls) do
            w:update(dt, p) 
        end
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

    for i, w in ipairs(walls) do
        w:draw() 
    end   
end