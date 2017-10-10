local composer = require( "composer" )
local physics = require( "physics" )
local scenarioLoader = require( "core.loaders.scenario_loader" )
local Celestino = require( "core.loaders.celestino" )
local enemiesLoader = require( "core.loaders.enemies" )
local jslib = require( "lib.simpleJoystick" )
local sharedData = require( "core.data.sharedData" )


local scene = composer.newScene()
physics.start()
math.randomseed(os.time())
math.random(); math.random(); math.random()

sharedData.levelFinished = false

local background = nil
local door = nil
local trapdoor = nil
local jsMove = nil
local jsShoot = nil
local celestino = nil
local gun = "left"
local carcara = nil

-- functions

function scene:create( event )
	local sceneGroup = self.view

	background = scenarioLoader.loadBackground()
	trapdoor = scenarioLoader.loadTrapDoor()
	door = scenarioLoader.loadClosedDoor( trapdoor.side )

	jsMove = jslib.new( 15, 30 )
	jsMove.x = 35
    jsMove.y = display.contentHeight - 35

    jsShoot = jslib.new( 15, 30 )
    jsShoot.x = display.contentWidth - 35
    jsShoot.y = display.contentHeight - 35

    sceneGroup:insert( background )
    sceneGroup:insert( door )
    sceneGroup:insert( trapdoor )
	sceneGroup:insert( jsMove )
	sceneGroup:insert( jsShoot )
end


function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- load celestino and setSequence
		celestino = Celestino.loadCelestino( door.side )
		carcara = enemiesLoader.loadEnemy( "carcara" )
		sceneGroup:insert( celestino )
		sceneGroup:insert( carcara )
		jsMove:activate()
		jsShoot:activate()
	elseif phase == "did" then
		-- e.g. start timers, begin animation, play audio, etc.
        celestino:play()
        sharedData.moveTimer = timer.performWithDelay( 100, move, 0 )
        sharedData.shootTimer = timer.performWithDelay( 200, shoot, 0 )
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
		timer.cancel(sharedData.moveTimer)
		timer.cancel(sharedData.shootTimer)
		background = nil
		door = nil
		trapdoor = nil
		jsMove = nil
		jsShoot = nil
		celestino = nil
		physics.stop()
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
		if gun == "left" then
			leftGun = Celestino.getCelestinoGunLeft(celestino.x, celestino.y, celestino.sequence)
			Celestino.shoot(leftGun.x, leftGun.y, celestino.sequence)
			gun = "right"
		else
			rightGun = Celestino.getCelestinoGunRight(celestino.x, celestino.y, celestino.sequence)
			Celestino.shoot(rightGun.x, rightGun.y, celestino.sequence)
			gun = "left"
		end
	end

  	return true
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene