local sharedData = require( "core.data.sharedData" )

local stats = {}

stats.loadLives = function (  )
	local livesGroup = display.newGroup()
	local presentX = 30
	local fixedY = 30
	for i=1,sharedData.lives do
		local heart = display.newImageRect( 'images/coracao.png', 32, 32 )
		heart.x, heart.y = presentX, fixedY
		livesGroup:insert( heart )
		presentX = presentX + 42
	end

	return livesGroup
end

stats.loadPoints = function (  )
	local points = display.newText({text=sharedData.points, x=display.contentWidth - 30, y = 30})
	points:setFillColor(0, 0, 0)

	return points
end

return stats