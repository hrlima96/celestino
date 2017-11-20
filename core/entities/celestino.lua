local celestino = {}

local heroWidth = 32
local heroHeight = 32
local file_url = 'images/celestino_parado.png'

local getCelestinoGunRight = function ( celestinoX, celestinoY, direction )
	local rightGun = {}

	if direction == "down" then
		rightGun.x, rightGun.y = (celestinoX - heroWidth/2) + 6, (celestinoY + heroHeight/2) - 6
	elseif direction == "up" then
		rightGun.x, rightGun.y = (celestinoX + heroWidth/2) - 6, (celestinoY - heroHeight/2) + 3
	elseif direction == "right" then
		rightGun.x, rightGun.y = (celestinoX + heroWidth/2) - 5, (celestinoY + heroWidth/2) - 6
	elseif direction == "left" then
		rightGun.x, rightGun.y = (celestinoX - heroHeight/2) + 3, (celestinoY - heroWidth/2) + 6
	end

	return rightGun
end

local getCelestinoGunLeft = function ( celestinoX, celestinoY, direction )
	local leftGun = {}

	if direction == "down" then
		leftGun.x, leftGun.y = (celestinoX + heroWidth/2) - 3, (celestinoY + heroHeight/2) - 5
	elseif direction == "up" then
		leftGun.x, leftGun.y = (celestinoX - heroWidth/2) + 3, (celestinoY - heroHeight/2) + 5
	elseif direction == "right" then
		leftGun.x, leftGun.y = (celestinoX + heroWidth/2) - 5, (celestinoY - heroWidth/2) + 3
	elseif direction == "left" then
		leftGun.x, leftGun.y = (celestinoX - heroHeight/2) + 3, (celestinoY + heroWidth/2) - 3
	end

	return leftGun
end

local shoot = function ( x, y, direction )
	local bullet = display.newCircle( x, y, 1)
	physics.addBody( bullet, 'dynamic', { radius = 1 } )
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
		celestino.x, celestino.y = display.contentWidth/2, 25
		celestino:setSequence( "down" )
	elseif doorSide == 2 then -- right
		celestino.x, celestino.y = display.contentWidth - 25, display.contentHeight/2
		celestino:setSequence( "left" )
	elseif doorSide == 3 then -- down
		celestino.x, celestino.y = display.contentWidth/2, display.contentHeight - 25
		celestino:setSequence( "up" )
	elseif doorSide == 4 then -- left
		celestino.x, celestino.y = 25, display.contentHeight/2
		celestino:setSequence( "right" )
	end

	physics.addBody( celestino, "dynamic", { density = 3.0 } )
	celestino.gravityScale = 0
	celestino.myName = "celestino"
	celestino.isFixedRotation = true

	celestino.getCelestinoGunRight = getCelestinoGunRight
	celestino.getCelestinoGunLeft = getCelestinoGunLeft
	celestino.shoot = shoot

	return celestino
end

return celestino