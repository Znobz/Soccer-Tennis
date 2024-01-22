Player = {}


-- load functions
function Player:load()
    self.x = 100
    self.y = 0
    self.width = 32
    self.height = 46
    self.collider = World:newRectangleCollider(self.x * 2, self.y * 2, self.width * 2, self.height * 2)
    self.collider:setFixedRotation(true)
    self.collider:setCollisionClass("Player")
    self.collider:setObject(self)
    
    self.maxSpeed = 400
    self.spriteSheet = love.graphics.newImage("Sprites/Will Ishan Nielsen.png") -- saves sprite sheet
    self.grid = anim8.newGrid(24, 24, self.spriteSheet:getWidth(), self.spriteSheet:getHeight()) -- converts sprite sheet into a grid of frames
    self.grounded = false
    self.xVel = 0
    self.yVel = 0
    self.scale = 2
    
    Player:animations()

    

end


function Player:animations() -- loads in animations
    local g = self.grid
    self.idle = anim8.newAnimation(g(("1-4"), 1), 0.1)
    self.runAnim = anim8.newAnimation(g(("6-9"), 1), 0.1)
    self.jumpAnim = anim8.newAnimation(g((11), 1), 0.1)
    self.fallAnim = anim8.newAnimation(g((10), 1), 0.1)
    self.currentAnim = self.idle
end


-- Update functions
function Player:update(dt)
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
    self:PlayerRespawn() -- repawns player if leaves screen
end

function Player:move(dt)
    if love.keyboard.isDown("d") then -- moves player to the right
        self.currentAnim = self.runAnim
        if self.xVel < self.maxSpeed then
            self.collider:applyForce(6000, 0)
        end
    elseif love.keyboard.isDown("a") then -- moves player to the left
        self.currentAnim = self.runAnim
        if self.xVel > -self.maxSpeed then
            self.collider:applyForce(-6000, 0)
        end
    else
        self.currentAnim = self.idle
    end
end

-- miscellaneous
--[[function Player:onBall() -- checks if the player is on top of the ball or not
    self.collider:setPreSolve(function(collider_1, collider_2)
        if collider_1.collision_class == "Player" and collider_2.collision_class == "Ballz" then
            local heroPos = collider_1:getY() + 48     
            local ballPos = collider_2:getY() - collider_2:getRadius()
            if heroPos >= ballPos then self.grounded = true print(true) else
                self.grounded = false
            end
        end
    end)
end--]]

function Player:jump(key) -- controls for jumping
    if key == "w" and self.grounded then
        sounds.jump:play()
        self.collider:applyLinearImpulse(0, -8000)
    end
end

function Player:facing(key) --  working
    if key == "d" then
        self.scale = 2
    elseif key == "a" then
        self.scale = -2
    end
end

function Player:skyAnim() -- sky animation
    if self.grounded == false then
        if self.yVel > 0 then
            self.currentAnim = self.jumpAnim
        elseif self.yVel < 0 then
            self.currentAnim = self.fallAnim
        end
    end
end 


-- draw function
function Player:draw()
    self.currentAnim:draw(self.spriteSheet, self.x, (self.y-9) - self.width / 2, nil, self.scale, 2, 12)
end

function Player:PlayerRespawn()
    if self.x < -10 then
        self.collider:destroy()
        self.x = 100
        self.y = 0
        self.collider = World:newRectangleCollider(self.x * 2, self.y * 2, self.width * 2, self.height * 2)
        self.x = 100/2
        self.y = 0
        self.collider:setFixedRotation(true)
        self.collider:setType("dynamic")
        self.collider:setCollisionClass('Player')
    end
end