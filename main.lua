---Need to have Lua and LOVE2d installed on the device with all the folder in the same directory
Class =require 'class'
push =require 'push'
require 'Ball'
require 'Paddle'
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720
paddle_speed=300
function love.load()
    love.window.setTitle('Ping Pong')
    love.graphics.setDefaultFilter('nearest','nearest')
    smallfont=love.graphics.newFont('font.ttf',12)
    scorefont=love.graphics.newFont('font.ttf',32)
    victor=love.graphics.newFont('font.ttf',32)
    push:setupScreen(VIRTUAL_WIDTH,VIRTUAL_HEIGHT,WINDOW_WIDTH,WINDOW_HEIGHT,{
        fullscreen=false,
        resizable=false,
        vsync=true
    })
    player1_score=0
    player2_score=0
    serving_player=math.random(2)==1 and 1 or 2
    winner=0
    paddle1=Paddle(5,20,5,20)
    paddle2=Paddle(VIRTUAL_WIDTH-10,VIRTUAL_HEIGHT-30,5,20)
    ball=Ball(VIRTUAL_WIDTH/2-2,VIRTUAL_HEIGHT/2-2,5,5)
    gamestate='start'
    if serving_player==1 then
        ball.dx=300
    else
        ball.dx=-300
    end
end
function love.update(dt)
    paddle1:update(dt)
    paddle2:update(dt)
    --player1 movement
    if love.keyboard.isDown('w') then
        paddle1.dy=-paddle_speed
    elseif love.keyboard.isDown('s') then
        paddle1.dy=paddle_speed
    else
        paddle1.dy=0
    end
    --player2 movement
    if love.keyboard.isDown('up') then
        paddle2.dy=-paddle_speed
    elseif love.keyboard.isDown('down') then
        paddle2.dy=paddle_speed
    else
        paddle2.dy=0
    end
    if gamestate=='play' then
        if  ball.x<=0 then
            player2_score=player2_score+1
            ball:reset()
            ball.dx=-300
            serving_player=2
            if player2_score>=3 then
                gamestate='victory'
                winner=2
            else
                gamestate='serve'
            end
        end
        if ball.x>=VIRTUAL_WIDTH-4 then
            player1_score=player1_score+1
            ball:reset()
            ball.dx=300
            serving_player=1
            if player1_score>=3 then
                gamestate='victory'
                winner=1
            else
                gamestate='serve'
            end
        end
        ball:update(dt)
        if ball:collides(paddle1) then
            ball.dx=-ball.dx
        end
        if ball:collides(paddle2) then
            ball.dx=-ball.dx
        end
        if ball.y<=0 then
            ball.dy=-ball.dy
            ball.y=0
        end
        if ball.y>=VIRTUAL_HEIGHT-4 then
            ball.dy=-ball.dy
            ball.y=VIRTUAL_HEIGHT-4
        end
    end
end
function love.keypressed(key)
    if key=='escape' then
        love.event.quit()--terminates the application
    elseif key=='enter' or key=='return' then
        if gamestate=='start'then
            gamestate='serve'
        elseif gamestate=='serve' then
            gamestate='play'
        elseif gamestate=='victory' then
            player1_score=0
            player2_score=0
            gamestate='start'
        end
    end
end
function love.draw()
    push:apply('start')
    love.graphics.clear(40/255, 45/255, 52/255, 1)
    love.graphics.setFont(smallfont)
    if gamestate == 'start' then
        love.graphics.printf("Welcome to the game! ",0,20,VIRTUAL_WIDTH,'center')
        love.graphics.printf("Press Enter to play",0,32,VIRTUAL_WIDTH,'center')
    elseif gamestate=='serve' then
        love.graphics.printf("Player ".. tostring(serving_player).."'s turn",0,20,VIRTUAL_WIDTH,'center')
        love.graphics.printf("Press Enter to serve",0,32,VIRTUAL_WIDTH,'center')
    elseif gamestate=='victory' then
        love.graphics.setFont(victor)
        love.graphics.printf("Player ".. tostring(winner).." wins",0,42,VIRTUAL_WIDTH,'center')
    end
    paddle1:render()
    paddle2:render()

    love.graphics.setFont(scorefont)
    love.graphics.print(tostring(player1_score),VIRTUAL_WIDTH/2-50,VIRTUAL_HEIGHT/3)
    love.graphics.print(tostring(player2_score),VIRTUAL_WIDTH/2+30,VIRTUAL_HEIGHT/3)
   
    ball:render()
    displayFPS()
    push:apply('end')
end
function displayFPS()
    love.graphics.setColor(0,1,0,1)
    love.graphics.setFont(smallfont)
    love.graphics.print('FPS:'..tostring(love.timer.getFPS()),40,20)
    love.graphics.setColor(1,1,1,1)
end