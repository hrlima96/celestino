local trapDoorCollision = require( "core.collisions.trapDoorCollision" )

local trapdoor = {}

local file_url = 'images/alcapao.png'
local trapDoorWidth = 32
local trapDoorHeight = 32	

trapdoor.loadTrapDoor = function (  )
	local side = nil --math.random(4)
	local trapdoor = display.newImageRect(file_url, trapDoorWidth, trapDoorHeight)

	side = math.random(4)
	if side == 1 then -- top
		trapdoor.x, trapdoor.y, trapdoor.side = display.contentWidth/2, 50, side
		trapdoor.rotation = 90
	elseif side == 2 then -- right
		trapdoor.x, trapdoor.y, trapdoor.side = display.contentWidth - 50, display.contentHeight/2, side
		trapdoor.rotation = 180
	elseif side == 3 then -- down
		trapdoor.x, trapdoor.y, trapdoor.side = display.contentWidth/2, display.contentHeight - 50, side
		trapdoor.rotation = -90
	elseif side == 4 then -- left
		trapdoor.x, trapdoor.y, trapdoor.side = 50, display.contentHeight/2, side
	end

	trapdoor.myName = "trapdoor"
	physics.addBody(trapdoor, "static")
	trapdoor.collision = trapDoorCollision.onTrapDoorCollision
	trapdoor:addEventListener( "collision" )
	trapdoor.isSensor = true

	return trapdoor
end

trapdoor.openTrapDoor = function ( t )
	local openTrapDoor = display.newImageRect('images/alcapao_aberto.png', trapDoorWidth*2, trapDoorHeight)
	openTrapDoor.x, openTrapDoor.y = t.x, t.y
	openTrapDoor.alpha = 0
	openTrapDoor.rotation = t.rotation

	return openTrapDoor
end

return trapdoor