Ball = {}
Platform = {}
Game = {}


function Ball:new(obj) 
    obj = obj or {}
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Ball:load(obj)  
    return Ball:new(obj)
end 

function Ball:update(dt)
    self.position.x = self.position.x + self.velocity.x * self.speed * dt
    self.position.y = self.position.y + self.velocity.y * self.speed * dt

    if self.position.y < 0 or self.position.y > 720 then 
        self.velocity.y = self.velocity.y * -1
    end

    if self.position.x < 0 or self.position.x > 1500 then
        self.position.x = 750 
        self.position.y = 360
        self.velocity.x = -50
        self.velocity.y = 0
    end
end

function Ball:draw()  
    love.graphics.circle('fill', self.position.x, self.position.y, self.radius)
end

function Platform:new(obj)  
    obj = obj or {}
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Platform:load(obj)  
    return Platform:new(obj)
end 

function Platform:update(dt, obj) 

    if(self:object_entered_area(obj)) then
        obj.velocity.x = obj.velocity.x * -1
        obj.velocity.y = obj.velocity.y + self.velocity.y
    end

    if love.keyboard.isDown("a") then
        self.velocity.y = (self.velocity.y - 1) 
    end
    if love.keyboard.isDown("d") then
        self.velocity.y = (self.velocity.y + 1) 
    end
    if love.keyboard.isDown("w") then
        self.velocity.y = (self.velocity.y - 1) 
    end
    if love.keyboard.isDown("s") then
        self.velocity.y = (self.velocity.y + 1) 
    end

    self.position.y = self.position.y + self.velocity.y * self.speed * dt
    
end

function Platform:draw()
    love.graphics.polygon('fill', self:get_vertices())
end

function Platform:object_entered_area(obj) 
        return (
            (obj.position.x + obj.radius) >= self.position.x and 
            (obj.position.x + obj.radius) <= self.position.x + self.width and
            (obj.position.y + obj.radius) >= self.position.y and
            (obj.position.y + obj.radius) <= self.position.y + self.height
        )
end

function Platform:get_vertices()
    return {
        self.position.x, self.position.y,
        self.position.x + self.width,  self.position.y,
        self.position.x + self.width, self.position.y + self.height,
        self.position.x, self.position.y + self.height,
    }
end

function love.load() 
    platforms = {
        Platform:load({
            position = {x = 10, y = 0},
            velocity = {x = 0, y = 0},
            width = 20,
            height = 100,
            speed = 10
        }),
        Platform:load({
            position = {x = 1470, y = 0},
            velocity = {x = 0, y = 0},
            width = 20,
            height = 100,
            speed = 10
        })
    }

    ball = Ball:load({
        position = {x = 750, y = 360},
        velocity = {x = -50, y = 0},
        radius = 10,
        speed = 10
    })
end

function love.update(dt)  

    ball:update(dt)

    for i, pltfrm in ipairs(platforms) do
        pltfrm:update(dt, ball)
    end
end 

function love.draw()  
    for i, pltfrm in ipairs(platforms) do
        pltfrm:draw()
    end

    ball:draw()
end 
