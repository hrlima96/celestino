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

	enemy.collision = onEnemyCollision
	enemy:addEventListener( "collision" )

	return enemy
end

function onEnemyCollision( self, e )
	if e.other.myName == "bullet" then
		transition.fadeOut( self, { time=200} )
		self:removeSelf()
		self = nil
		e.other:removeSelf()
		e.other = nil
		trapdoor.isOpen = true
	end
end

return enemies