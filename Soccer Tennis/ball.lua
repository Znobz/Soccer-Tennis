Ball = {}

function Ball:load()
    self.x = 400
    self.y = 100
    self.rad = 30
    self.sprite = love.graphics.newImage("Sprites/DaBall.png")
    self.ball = World:newCircleCollider(self.x, self.y, self.rad)
    self.ball:setCollisionClass('Ballz')
    self.ball:setRestitution(0.8)

    ballPos = true
    switch = 600 -- determines where the ball respawns
    bounceCounter = 0 -- global variable bounce counter
end

function Ball:draw()
    love.graphics.draw(self.sprite, self.x - 15, self.y - 15, nil, 2)
end

-- 
function Ball:winOrLose()
    if (bounceCounter == 2  and self.x < 320) or (self.x < 0) then
        playerTwoScore = playerTwoScore + 1
        sounds.score:play()
        
        switch = 400
        Ball:respawn()
        bounceCounter = 0
        --sounds.score:play()
    elseif (bounceCounter == 2 and self.x > 340) or (self.x > 640) then
        playerOneScore = playerOneScore + 1
        sounds.score:play()

        switch = 890
        Ball:respawn()
        bounceCounter = 0
        --sounds.score:play()
    end
end--]]

--[[
function Ball:winOrLose()
    if self.x < 320 then 
        ballPos = true
    elseif self.x > 340 then 
        ballPos = false
    end

    while(ballPos)
    do
        
    end

end    

--]]

function Ball:respawn()
        self.ball:destroy()
        self.x = switch
        self.y = 100
        self.ball = World:newCircleCollider(self.x, self.y, self.rad)
        self.x = switch/2 -- render the ball at half of the physics' representation coordinates
        self.y = 100/2
        self.ball:setType("dynamic")
        self.ball:setCollisionClass('Ballz')
        self.ball:setRestitution(0.8)
end
