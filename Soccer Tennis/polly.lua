Polly = {}


-- load functions
function Polly:load()
    self.x = 500
    self.y = 0
    self.width = 32
    self.height = 46
    self.collider = World:newRectangleCollider(self.x * 2, self.y * 2, self.width * 2, self.height * 2)
    self.collider:setFixedRotation(true)
    self.collider:setCollisionClass("Player")
    self.collider:setObject(self)
    
    self.maxSpeed = 400
    self.spriteSheet = love.graphics.newImage("Sprites/Polly Jr.png") -- saves sprite sheet
    self.grid = anim8.newGrid(24, 24, self.spriteSheet:getWidth(), self.spriteSheet:getHeight()) -- converts sprite sheet into a grid of frames
    self.grounded = false
    self.xVel = 0
    self.yVel = 0
    self.scale = 2
    
    Polly:animations()

    

end


function Polly:animations() -- loads in animations
    local g = self.grid
    self.idle = anim8.newAnimation(g(("1-4"), 1), 0.1)
    self.runAnim = anim8.newAnimation(g(("6-9"), 1), 0.1)
    self.jumpAnim = anim8.newAnimation(g((11), 1), 0.1)
    self.fallAnim = anim8.newAnimation(g((10), 1), 0.1)
    self.currentAnim = self.idle
end


-- Update functions
function Polly:update(dt)
    self.xVel, self.yVel = self.collider:getLinearVelocity()
    self.currentAnim:update(dt)
    if self.collider:enter('Border') then
        self.grounded = true
    elseif self.collider:exit('Border') then
        self.grounded = false
    end
    --self:onBall()
    --place onBall function here
    self:move(dt)
    self:skyAnim()
    self:PlayerRespawn()
    
end

function Polly:move(dt)
    if love.keyboard.isDown("right") then -- moves player to the right
        self.currentAnim = self.runAnim
        if self.xVel < self.maxSpeed then
            self.collider:applyForce(6000, 0)
        end
    elseif love.keyboard.isDown("left") then -- moves player to the left
        self.currentAnim = self.runAnim
        if self.xVel > -self.maxSpeed then
            self.collider:applyForce(-6000, 0)
        end
    else
        self.currentAnim = self.idle
    end
end

-- miscellaneous

function Polly:jump(key) -- controls for jumping
    if key == "up" and self.grounded then
        sounds.jump:play()
        self.collider:applyLinearImpulse(0, -8000)
    end
end

function Polly:facing(key) --  working
    if key == "left" then
        self.scale = 2
    elseif key == "right" then
        self.scale = -2
    end
end

function Polly:skyAnim() -- sky animation
    if self.grounded == false then
        if self.yVel > 0 then
            self.currentAnim = self.jumpAnim
        elseif self.yVel < 0 then
            self.currentAnim = self.fallAnim
        end
    end
end 


-- draw function
function Polly:draw()
    self.currentAnim:draw(self.spriteSheet, self.x, (self.y-9) - self.width / 2, nil, self.scale, 2, 12)
end

function Polly:PlayerRespawn()
    if self.x > 650 then
        self.collider:destroy()
        self.x = 500
        self.y = 0
        self.collider = World:newRectangleCollider(self.x * 2, self.y * 2, self.width * 2, self.height * 2)
        self.x = 500/2
        self.y = 0
        self.collider:setFixedRotation(true)
        self.collider:setType("dynamic")
        self.collider:setCollisionClass('Player')
    end
end