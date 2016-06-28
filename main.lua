
-- Declaración de Variables y Constantes--
--Personaje
player = { x = 200, y = 500, speed = 200, img = nil }

--Estados
canShoot = true
isAlive = true

--Timer
canShootTimerMax = 0.3 
canShootTimer = canShootTimerMax
createEnemyTimerMax = 0.8
createEnemyTimer = createEnemyTimerMax

--Imagenes
bulletImg = nil
enemyImg = nil

-- Storage
bullets = {} 
enemies = {}
score = 0


function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end

function love.load(arg)
	player.img = love.graphics.newImage("Assets/sprites/personaje/jump/right.png")
	bulletImg  = love.graphics.newImage("Assets/sprites/objetos/banana.png")
	backImg    = love.graphics.newImage("Assets/fondos/jungle2_by_andigr-d5sraou.jpg")
	enemyImg   = love.graphics.newImage("Assets/sprites/objetos/statue.png")
	floorImg   = love.graphics.newImage("Assets/sprites/piso/grassbehind.png")
	playerquad = love.graphics.newQuad(0, 0, 100,100,  player.img:getWidth()/1.8, player.img:getHeight()/1.8)
	backquad   = love.graphics.newQuad(0, 0, 480 ,600, backImg:getWidth(), backImg:getHeight())
	enemyquad  = love.graphics.newQuad(0, 0, 100 ,150, enemyImg:getWidth()/2.5, enemyImg:getHeight()/2.5)
	bulletquad = love.graphics.newQuad(0, 0, 100 ,150, bulletImg:getWidth()/3, bulletImg:getHeight()/3)
	floorquad  = love.graphics.newQuad(0, 0, 480 ,50, floorImg:getWidth()/2, floorImg:getHeight()/2)
end

function love.draw(dt)
	love.graphics.draw(backImg,backquad,0,0)
	for i, bullet in ipairs(bullets) do
		--randoang = math.random(100,250)
		randoang = 50
 		love.graphics.draw(bullet.img,bulletquad, bullet.x, bullet.y,math.rad(randoang))
	end
	for i, enemy in ipairs(enemies) do
		love.graphics.draw(enemy.img,enemyquad, enemy.x, enemy.y)
	end
	if isAlive then
		love.graphics.draw(player.img, playerquad, player.x, player.y)
	else
		love.graphics.print("Press 'R' to restart", love.graphics:getWidth()/2-50, love.graphics:getHeight()/2-10)
	end
	love.graphics.print(level, 3,480)
	love.graphics.setColor(255, 255, 255)
	love.graphics.print(score, 3,500,0, 2, 2)
	love.graphics.draw(floorImg,floorquad,0,550)
end

function love.update(dt)

	if love.keyboard.isDown('escape') then
		love.event.push('quit')
	end
	if love.keyboard.isDown('left','a') then
		if player.x > 0 then -- binds us to the map
			player.x = player.x - (player.speed*dt)
		end
		elseif love.keyboard.isDown('right','d') then
		if player.x < (love.graphics.getWidth() - player.img:getWidth()) then
			player.x = player.x + (player.speed*dt)
		end
	end

	if love.keyboard.isDown('up', 'w') and canShoot then
		if isAlive then
			newBullet = { x = player.x + (player.img:getWidth()/2), y = player.y, img = bulletImg }
			table.insert(bullets, newBullet)
			canShoot = false
			canShootTimer = canShootTimerMax
		end
	end

	for i, bullet in ipairs(bullets) do
		bullet.y = bullet.y - (250 * dt)
  		if bullet.y < 0 then -- remove bullets when they pass off the screen
			table.remove(bullets, i)
		end
	end

	canShootTimer = canShootTimer - (1 * dt)
	if canShootTimer < 0 then
  		canShoot = true
	end
	if score == 0 then
			createEnemyTimerMax = 0.8
			level ="Nivel 1"
        elseif	(score >= 10 and score < 20) then
			createEnemyTimerMax = 0.5
			level ="Nivel 2"
		elseif	score >= 20 then
			createEnemyTimerMax = 0.3
			level ="Nivel 3"
		else 
			createEnemyTimerMax = 0.8
      	end

	createEnemyTimer = createEnemyTimer - (1 * dt)
	if createEnemyTimer < 0 then
		createEnemyTimer = createEnemyTimerMax
		randomNumber = math.random(10, love.graphics.getWidth() - 10)
		newEnemy = { x = randomNumber, y = -10, img = enemyImg }
		table.insert(enemies, newEnemy)
	end

	for i, enemy in ipairs(enemies) do
		enemy.y = enemy.y + (200 * dt)
		if enemy.y > 850 then 
			table.remove(enemies, i)
		end
	end

	for i, enemy in ipairs(enemies) do
		for j, bullet in ipairs(bullets) do
			if CheckCollision(enemy.x, enemy.y, enemy.img:getWidth()/2.5, enemy.img:getHeight()/2.5, bullet.x, bullet.y, bullet.img:getWidth()/3, bullet.img:getHeight()/3) then
				table.remove(bullets, j)
				table.remove(enemies, i)
				score = score + 1
			end
		end

		if CheckCollision(enemy.x, enemy.y, enemy.img:getWidth()/2.5, enemy.img:getHeight()/2.5, player.x, player.y, player.img:getWidth()/1.8, player.img:getHeight()/1.8) 
		and isAlive then
			table.remove(enemies, i)
			isAlive = false
		end
	end

	

	if not isAlive and love.keyboard.isDown('r') then
	-- remove all our bullets and enemies from screen
		isAlive = true
		bullets = {}
		enemies = {}

	-- reset timers
		canShootTimer = canShootTimerMax
		createEnemyTimer = createEnemyTimerMax

	-- move player back to default position
		player.x = 200
		player.y = 500

	-- reset puntaje
		score = 0
		
	end
	
end