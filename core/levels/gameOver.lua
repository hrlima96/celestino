-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()


function onBackBtnTouch( event )
	if event.phase == "ended" then
		composer.removeScene( "core.levels.gameOver" )
		composer.gotoScene( "core.levels.menu", "fade", 500 )
	end

	return true
end
--------------------------------------------

function scene:create( event )
	local sceneGroup = self.view

	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	-- display a background image
	--local background = display.newImageRect( "background.jpg", display.contentWidth, display.contentHeight )
	--background.anchorX = 0
	--background.anchorY = 0
	--background.x, background.y = 0, 0
	
	-- create/position logo/title image on upper-half of the screen
	--local titleLogo = display.newImageRect( "logo.png", 264, 42 )
	--titleLogo.x = display.contentWidth * 0.5
	--titleLogo.y = 100

	local background = display.newImageRect( 'images/background_menu.png', display.contentWidth, display.contentHeight )
	background.x, background.y = display.contentWidth/2, display.contentHeight/2
	sceneGroup:insert( background )

	local gameOverText = display.newText( {parent=sceneGroup, text="Está Morto", x=display.contentWidth/2, y=display.contentHeight/2, fontSize=50} )
	gameOverText:setFillColor(0)

	local backText = display.newText( {parent=sceneGroup, text="voltar", x=display.contentWidth/2, y=display.contentHeight/2 + 50, fontSize=18} )
	backText:setFillColor(0)
	backText:addEventListener( "touch", onBackBtnTouch )


end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
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

	elseif phase == "did" then
		-- Called when the scene is now off screen
	end	
end

function scene:destroy( event )
	local sceneGroup = self.view
	
	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.

end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene