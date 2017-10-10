local sharedData = require( "core.data.sharedData" )

local enemyCollision = {}

enemyCollision.onEnemyCollision = function ( self, e )
	if e.other.myName == "bullet" then
		transition.fadeOut( self, { time=200} )
		self:removeSelf()
		self = nil
		e.other:removeSelf()
		e.other = nil
		sharedData.levelFinished = true
	end
end

return enemyCollision