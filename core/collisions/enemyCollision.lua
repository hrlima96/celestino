local sharedData = require( "core.data.sharedData" )
local composer = require( "composer" )
local vulnerable = true
local blinkTransition


local enemyCollision = {}

enemyCollision.onEnemyCollision = function ( self, e )
	if e.other.myName == "bullet" then

		sharedData.points = sharedData.points + 100
		sharedData.pointsObject.text = sharedData.points
		transition.fadeOut( self, { time=200} )
		self:removeSelf()
		self = nil
		e.other:removeSelf()
		e.other = nil
	elseif e.other.myName == "celestino" then
		if vulnerable then
			if sharedData.livesObject[sharedData.lives] then
				sharedData.livesObject[sharedData.lives]:setFillColor(1,1,1,0)
				sharedData.livesObject[sharedData.lives]:removeSelf()
				sharedData.livesObject[sharedData.lives] = nil
			end
			sharedData.lives = sharedData.lives - 1
			if sharedData.lives <= 0 then
				composer.removeScene( "core.levels.level1" )
				composer.gotoScene( "core.levels.gameOver", "fade", 400 )
			end
			vulnerable = false
			timer.performWithDelay(1000, beVulnerable)
		end
	end
end

function beVulnerable(  )
	vulnerable = true
end

return enemyCollision