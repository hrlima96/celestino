local sharedData = require( "core.data.sharedData" )
local composer = require( "composer" )

local trapDoorCollision = {}

trapDoorCollision.onTrapDoorCollision = function ( self, e )
	if e.other.myName == "celestino" and sharedData.levelFinished then
		composer.removeScene( "core.levels.level1" )
		composer.gotoScene( "core.levels.level1", "fade", 400 )
	end
end

return trapDoorCollision