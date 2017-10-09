local celestino = {}

local heroWidth = 72
local heroHeight = 72
local file_url = 'images/celestino_parado.png'

celestino.loadCelestino = function ( doorSide )
	local heroSheet = graphics.newImageSheet( file_url, {width = heroWidth, height = heroHeight, numFrames = 4} )
	local sequenceData = {
		{name = "up", sheet = heroSheet, frames = {3}, time = 400, loopCount = 0},
		{name = "down", sheet = heroSheet, frames = {1}, time = 400, loopCount = 0},
		{name = "left", sheet = heroSheet, frames = {4}, time = 400, loopCount = 0},
		{name = "right", sheet = heroSheet, frames = {2}, time = 400, loopCount = 0}
	}
	local celestino = display.newSprite(heroSheet, sequenceData)
	if doorSide == 1 then -- top
		celestino.x, celestino.y = display.contentWidth/2, 50
		celestino:setSequence( "down" )
	elseif doorSide == 2 then -- right
		celestino.x, celestino.y = display.contentWidth - 50, display.contentHeight/2
		celestino:setSequence( "left" )
	elseif doorSide == 3 then -- down
		celestino.x, celestino.y = display.contentWidth/2, display.contentHeight - 50
		celestino:setSequence( "up" )
	elseif doorSide == 4 then -- left
		celestino.x, celestino.y = 50, display.contentHeight/2
		celestino:setSequence( "right" )
	end

	physics.addBody( celestino, "dynamic", { density = 3.0 } )
	celestino.gravityScale = 0
	celestino.myName = "celestino"

	return celestino
end

celestino.getCelestinoGunRight = function ( celestinoX, celestinoY, direction )
	local rightGun = {}

	if direction == "down" then
		rightGun.x, rightGun.y = (celestinoX + heroWidth/2) - 7, (celestinoY + heroHeight/2) - 16
	elseif direction == "up" then
		rightGun.x, rightGun.y = (celestinoX + heroWidth/2) - 14, (celestinoY - heroHeight/2) + 14
	elseif direction == "right" then
		rightGun.x, rightGun.y = (celestinoX + heroWidth/2) - 14, (celestinoY + heroWidth/2) - 14
	elseif direction == "left" then
		rightGun.x, rightGun.y = (celestinoX - heroHeight/2) + 14, (celestinoY - heroWidth/2) + 14
	end

	return rightGun
end

celestino.getCelestinoGunLeft = function ( celestinoX, celestinoY, direction )
	local leftGun = {}

	if direction == "down" then
		leftGun.x, leftGun.y = (celestinoX - heroWidth/2) + 14, (celestinoY + heroHeight/2) - 14
	elseif direction == "up" then
		leftGun.x, leftGun.y = (celestinoX - heroWidth/2) + 7, (celestinoY - heroHeight/2) + 16
	elseif direction == "right" then
		leftGun.x, leftGun.y = (celestinoX + heroWidth/2) - 16, (celestinoY - heroWidth/2) + 7
	elseif direction == "left" then
		leftGun.x, leftGun.y = (celestinoX - heroHeight/2) + 16, (celestinoY + heroWidth/2) - 7
	end

	return leftGun
end

celestino.shoot = function ( x, y, direction )
	local bullet = display.newCircle( x, y, 2)
	physics.addBody( bullet, 'dynamic', { radius = 2 } )
	bullet.gravityScale = 0
	bullet.isBullet = true
	bullet.myName = "bullet"

	if direction == "down" then
		bullet:setLinearVelocity(0, 300)
	elseif direction == "up" then
		bullet:setLinearVelocity(0, -300)
	elseif direction == "right" then
		bullet:setLinearVelocity(300, 0)
	elseif direction == "left" then
		bullet:setLinearVelocity(-300, 0)
	end

	return bullet
end

return celestino