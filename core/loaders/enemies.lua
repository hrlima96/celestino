local enemyCollision = require( "core.collisions.enemyCollision" )

local enemies = {}

local file_url = nil
local enemyWidth = nil
local enemyHeight = nil

enemies.loadEnemies = function (  )
	
end

enemies.loadEnemy = function ( enemyType )
	if enemyType == "carcara" then
		file_url = 'images/carcara.png'
		enemyWidth = 46
		enemyHeight = 64
	end

	local enemySheet = graphics.newImageSheet( file_url, {width = enemyWidth, height = enemyHeight, numFrames = 1} )
	local sequenceData = {
		{name = "steady", sheet = enemySheet, frames = {1}, time = 400, loopCount = 0}
	}
	local enemy = display.newSprite(enemySheet, sequenceData)
	enemy.x, enemy.y = display.contentWidth/2, display.contentHeight/2

	physics.addBody( enemy, "dynamic", { density = 3.0 } )
	enemy.gravityScale = 0
	enemy.myName = enemyType
	enemy:setSequence( "steady" )
	enemy:play()

	enemy.collision = enemyCollision.onEnemyCollision
	enemy:addEventListener( "collision" )

	return enemy
end

return enemies