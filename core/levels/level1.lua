local composer = require( "composer" )
local physics = require( "physics" )
local scenarioLoader = require( "core.loaders.scenarioLoader" )
local statsLoader = require( "core.loaders.statsLoader" )
local celestinoEntity = require( "core.entities.celestino" )
local enemiesEntity = require( "core.entities.enemies" )
local jslib = require( "lib.simpleJoystick" )
local sharedData = require( "core.data.sharedData" )

local scene = composer.newScene()
physics.start()
math.randomseed(os.time())
math.random(); math.random(); math.random()
system.activate("multitouch")

if sharedData.lives == nil then
	sharedData.lives = 3
end
if sharedData.points == nil then
	sharedData.points = 0
end
if sharedData.level == nil then
	sharedData.level = 1
end
sharedData.levelFinished = false

local enemies = {}
local background = nil
local door = nil
local trapdoor = nil
local jsMove = nil
local jsShoot = nil
local celestino = nil
local gun = "left"
local carcara = nil
local openTrapDoor = nil

local sounds = {
	walkingSound=audio.loadSound( "audio/andando.mp3" ),
	shotSound=audio.loadSound( "audio/tiro.wav" )
}

-- functions

function scene:create( event )
	local sceneGroup = self.view

	sharedData.levelFinished = false
	enemies = {}

	background = scenarioLoader.loadBackground()
	trapdoor = scenarioLoader.loadTrapDoor()
	openTrapDoor = scenarioLoader.openTrapDoor(trapdoor)
	door = scenarioLoader.loadClosedDoor( trapdoor.side )

	sharedData.livesObject = statsLoader.loadLives()
	sharedData.pointsObject = statsLoader.loadPoints()


	jsMove = jslib.new( 15, 30 )
	jsMove.x = 35
    jsMove.y = display.contentHeight - 35

    jsShoot = jslib.new( 15, 30 )
    jsShoot.x = display.contentWidth - 35
    jsShoot.y = display.contentHeight - 35

    sceneGroup:insert( background )
    sceneGroup:insert( sharedData.pointsObject )
    sceneGroup:insert( sharedData.livesObject )
    sceneGroup:insert( door )
    sceneGroup:insert( trapdoor )
    sceneGroup:insert( openTrapDoor )
    sceneGroup:insert( jsMove )
	sceneGroup:insert( jsShoot )
end


function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- load celestino and setSequence
		celestino = celestinoEntity.loadCelestino( door.side )
		enemies = enemiesEntity.levelEnemies( sharedData.level, door.side )
		sceneGroup:insert( enemies )
		sceneGroup:insert( celestino )
		jsMove:activate()
		jsShoot:activate()
	elseif phase == "did" then
		-- e.g. start timers, begin animation, play audio, etc.
        celestino:play()
        sharedData.moveTimer = timer.performWithDelay( 100, move, 0 )
        sharedData.shootTimer = timer.performWithDelay( 200, shoot, 0 )
        sharedData.enemiesTimer = timer.performWithDelay( 200, enemiesListener, 0 )
	end
end

function scene:hide( event )
	local sceneGroup = self.view
	
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
		timer.pause(sharedData.moveTimer)
		timer.pause(sharedData.shootTimer)
		timer.pause(sharedData.enemiesTimer)
		audio.pause(1)
		audio.pause(2)
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end	
	
end

function scene:destroy( event )

	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	local sceneGroup = self.view

	timer.cancel(sharedData.moveTimer)
	timer.cancel(sharedData.shootTimer)
	timer.cancel(sharedData.enemiesTimer)

	enemies:removeSelf()
	enemies = nil
	background = nil
	door = nil
	trapdoor = nil
	jsMove = nil
	jsShoot = nil
	celestino = nil
	openTrapDoor = nil
	audio.stop(1)
	audio.stop(2)
	
	package.loaded[physics] = nil
	physics = nil
	scene:removeEventListener("create", scene)
	scene:removeEventListener("show", scene)
	scene:removeEventListener("hide", scene)
	scene:removeEventListener("destroy", scene)
end

function move( e )
	local jsDirection = jsMove:getDirection()
	if jsDirection == 1 then --right
		celestino:setLinearVelocity(180, 0)
	elseif jsDirection == 2 then -- up
		celestino:setLinearVelocity(0, -180)
	elseif jsDirection == 3 then -- left
		celestino:setLinearVelocity(-180, 0)
	elseif jsDirection == 4 then -- down
		celestino:setLinearVelocity(0, 180)
	end

	if jsMove.getDistance() == 0 then
		celestino:setLinearVelocity(0, 0)
		audio.pause(1)
	else
		if audio.isChannelActive( 1 ) then
			audio.resume(1)
		else
			audio.play(sounds["walkingSound"], {loops=-1, channel=1})
		end
	end

  	return true
end

function shoot( e )
	local jsDirection = jsShoot:getDirection()
	local jsDistance = jsShoot:getDistance()
	local leftGun, rightGun = nil, nil


	if jsDirection == 1 then --right
		celestino:setSequence("right")
	elseif jsDirection == 2 then -- up
		celestino:setSequence("up")
	elseif jsDirection == 3 then -- left
		celestino:setSequence("left")
	elseif jsDirection == 4 then -- down
		celestino:setSequence("down")
	end

	if jsShoot:getDistance() ~= 0 then
		audio.play(sounds["shotSound"], {loops=0, channel=2})
		if gun == "left" then
			leftGun = celestino.getCelestinoGunLeft(celestino.x, celestino.y, celestino.sequence)
			celestino.shoot(leftGun.x, leftGun.y, celestino.sequence)
			gun = "right"
		else
			rightGun = celestino.getCelestinoGunRight(celestino.x, celestino.y, celestino.sequence)
			celestino.shoot(rightGun.x, rightGun.y, celestino.sequence)
			gun = "left"
		end
	end

  	return true
end

function enemiesListener( e )
	if enemies.numChildren == 0 then
		sharedData.levelFinished = true
		trapdoor.alpha = 0
		openTrapDoor.alpha = 1
	end
	if sharedData.points >= 1000 then
		sharedData.level = 2
	elseif sharedData.points >= 2000 then
		sharedData.level = 3
	end
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene