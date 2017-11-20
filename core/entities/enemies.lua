local enemyCollision = require( "core.collisions.enemyCollision" )

local enemies = {}

local file_url = nil
local enemyWidth = nil
local enemyHeight = nil

enemies.levelEnemies = function ( level, celestinoSide )
	local enemies = display.newGroup()
	if level == 1 then
		file_url = 'images/carcara.png'
		enemyWidth = 32
		enemyHeight = 32
		for i=1, 3 do
			enemies:insert( addEnemy( "carcara", celestinoSide ))
		end
	elseif level == 2 then
		file_url = 'images/carcara.png'
		enemyWidth = 32
		enemyHeight = 32
		for i=1, 6 do
			enemies:insert( addEnemy( "carcara", celestinoSide ))
		end
	elseif level == 3 then
		file_url = 'images/carcara.png'
		enemyWidth = 32
		enemyHeight = 32
		for i=1, 10 do
			enemies:insert( addEnemy( "carcara", celestinoSide ))
		end
	end

	return enemies
end

function addEnemy ( enemyType, celestinoSide )
	local gridCellWidth, gridCellHeight = display.contentWidth / 5, display.contentHeight / 3
	local cantCreateX, cantCreateY = -1, -1
	if celestinoSide == 1 then -- top
		cantCreateX = 3
		cantCreateY = 1
	elseif celestinoSide == 2 then -- right
		cantCreateX = 5
		cantCreateY = 2
	elseif celestinoSide == 3 then -- down
		cantCreateX = 3
		cantCreateY = 3
	elseif celestinoSide == 4 then -- left
		cantCreateX = 1
		cantCreateY = 2
	end

	local createPlaceX, createPlaceY = cantCreateX, cantCreateY
	while createPlaceX == cantCreateX and cantCreateY == createPlaceY do
		createPlaceX = math.random(5)
		createPlaceY = math.random(3)
	end
	enemyX, enemyY = (gridCellWidth * createPlaceX) - 32, (gridCellHeight * createPlaceY) - 50 

	if enemyType == "carcara" then
		file_url = 'images/carcara.png'
		enemyWidth = 32
		enemyHeight = 32
	end

	local enemySheet = graphics.newImageSheet( file_url, {width = enemyWidth, height = enemyHeight, numFrames = 1} )
	local sequenceData = {
		{name = "steady", sheet = enemySheet, frames = {1}, time = 400, loopCount = 0}
	}
	local enemy = display.newSprite(enemySheet, sequenceData)
	enemy.x, enemy.y = enemyX, enemyY

	physics.addBody( enemy, "static", { density = 3.0 } )
	enemy.gravityScale = 0
	enemy.myName = enemyType
	enemy:setSequence( "steady" )
	enemy:play()

	enemy.collision = enemyCollision.onEnemyCollision
	enemy:addEventListener( "collision" )

	return enemy
end

return enemies