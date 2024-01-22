local STI = require("sti")
local wf = require("windfield")
anim8 = require("anim8/anim8")
love.graphics.setDefaultFilter("nearest", "nearest")
require("player")
require("ball")
require("polly")
--require("04b_30")
--require("Sounds")


function love.load()
    mapLoader()
    Player:load()
    Polly:load() --player 2
    Ball:load()
    sounds = {}
    sounds.bounce = love.audio.newSource("Sounds/Bounce.mp3", "static")
    sounds.jump = love.audio.newSource("Sounds/jump.wav", "static")
    sounds.score = love.audio.newSource("Sounds/cymbal.mp3", "static")
    sounds.score:setVolume(2.0)
    sounds.music = love.audio.newSource("Sounds/Jeremy Blake - Powerup.mp3", "stream")
    sounds.music:setVolume(0.5)
    playerOneScore = 0
    playerTwoScore = 0
    gameFont = love.graphics.newImageFont("Sprites/Imagefont.png",
                " abcdefghijklmnopqrstuvwxyz" ..
                "ABCDEFGHIJKLMNOPQRSTUVWXYZ0" ..
                "123456789.,!?-+/():;%&`'*#=[]\"")
    --love.graphics.setFont(gameFont, 100)
    
end

function love.update(dt)
    
    World:update(dt) -- updates what is happening to the world
    Player.x = Player.collider:getX() / 2
    Player.y = Player.collider:getY() / 2

    Polly.x = Polly.collider:getX() / 2
    Polly.y = Polly.collider:getY() / 2


    Ball.x = Ball.ball:getX() / 2
    Ball.y = Ball.ball:getY() / 2

    Player:update(dt)

    Polly:update(dt)

    if Ball.ball:enter('Border') then 
        sounds.bounce:play()
        bounceCounter = bounceCounter + 1 -- increments the number of bounces to resent ball position
    end

    if Ball.ball:enter("Player") then
        bounceCounter = 0
    end
    sounds.music:play()
    Ball:winOrLose()

    if (playerOneScore == 10) or (playerTwoScore == 10) then
        playerOneScore = 0
        playerTwoScore = 0
    end

end

function love.draw()
    love.graphics.setFont(gameFont)
    love.graphics.draw(background)
    love.graphics.draw(dividerLine, 432, -40, nil, 0.5, 0.5)
    love.graphics.draw(poleSprite, 630, 400)
    love.graphics.print(playerOneScore, 50, 50, nil, 8, 8)
    love.graphics.print(playerTwoScore, 1150, 50, nil, 8, 8)
    --love.graphics.draw(dividerLine, 220, -330)
    --World:draw()
    Map:draw(0,0,2,2)
    love.graphics.push()
    love.graphics.scale(2,2)
    Player:draw() -- must be drawn after scale but before pop
    Polly:draw()
    Ball:draw()

    
    love.graphics.pop()      -- draws tilemap and scales it
    print(tostring(Player.x))
    --print(tostring(playerTwoScore))
    --print(tostring(playerOneScore))
    
    

    
end

function mapLoader() -- loads the tilemap and background
    --background = love.graphics.newImage("Sprites/blueSky.jpg")
    Map = STI("map/1.lua", {"box2d"})
    World = wf.newWorld(0, 500)
    World:addCollisionClass('Border')
    World:addCollisionClass('Ballz')
    World:addCollisionClass("Player")
    World:addCollisionClass("divider", {ignores = {'Ballz'}})
    --local stick = World:newLineCollider(640, 200, 800, 200)
    walls = {}
    if Map.layers["solid"] then
        for i, obj in pairs (Map.layers["solid"].objects) do
            local wall = World:newRectangleCollider(obj.x * 2, obj.y * 2, obj.width * 2, obj.height * 2)
            local top = World:newLineCollider(obj.x * 2 + 1, obj.y * 2, (obj.x + obj.width)  * 2 - 1, (obj.y) * 2)
            wall:setType("static")
            top:setType("static")
            top:setCollisionClass('Border') -- fixes sky anim bug
            table.insert(walls, wall)
            table.insert(walls, top)
        end
    end
    Map.layers.solid.visable = false
    pole = World:newRectangleCollider(630, 400, 20, 240)
    topPole = World:newLineCollider(631, 400, 649, 400)
    pole:setType("static")
    topPole:setType("static")
    topPole:setCollisionClass('Border')

    dividerLine = World:newLineCollider(640, 0, 640, 400)
    dividerLine:setType("static")
    dividerLine:setCollisionClass("divider")

    LeftSide = World:newLineCollider(0, 20, 0, 600) -- Left border
    LeftSide:setType("static")

    RightSide = World:newLineCollider(1280, 20, 1280, 600) -- Right border
    RightSide:setType("static")

    background = love.graphics.newImage("Sprites/blueSky.jpg")
    poleSprite = love.graphics.newImage("Sprites/RealPole.png")
    dividerLine = love.graphics.newImage("Sprites/whiteline.png")


end

function love.keypressed(key)
    Player:jump(key)
    Player:facing(key)

    Polly:jump(key)
    Polly:facing(key)
    --print(Ball.x)
end








