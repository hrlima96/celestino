local sharedData = require( "core.data.sharedData" )
local trapDoorLoader = require( "core.loaders.trapdoor" )

local enemyCollision = {}

enemyCollision.onEnemyCollision = function ( self, e )
	if e.other.myName == "bullet" then
		table.remove(sharedData.enemies, 1)
		transition.fadeOut( self, { time=200} )
		self:removeSelf()
		self = nil
		e.other:removeSelf()
		e.other = nil
	elseif e.other.myName == "celestino" then
		transition.blink( e.other, {time=700, tag="celestinoBlink"} )
		timer.performWithDelay(700, transition.cancel(e.other), 1)
	end
end

return enemyCollision