local door = {}

local file_url = 'images/porta.png'
local doorWidth = 3
local doorHeight = 72

door.loadClosedDoor = function ( trapDoorSide )
	local door = display.newImageRect(file_url, doorWidth, doorHeight)
	local side = nil
	door:setFillColor( 0 )

	local pass = true
	while pass do
		side = math.random(4)
		if side ~= trapDoorSide then
			if side == 1 then -- top
				door.x = display.contentWidth/2
				door.y = 3
				door.rotation = 90
			elseif side == 2 then -- right
				door.x, door.y = display.contentWidth-3, display.contentHeight/2 
			elseif side == 3 then -- down
				door.x = display.contentWidth/2
				door.y = display.contentHeight-3
				door.rotation = 90
			elseif side == 4 then -- left
				door.x, door.y = 3, display.contentHeight/2 
			end
			pass = false
		end
	end
	door.side = side

	return door
end

return door