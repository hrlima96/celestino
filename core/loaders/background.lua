local background = {}

background.loadBackground = function (  )
	local file_url = 'images/background.png'
	local background = display.newImageRect( file_url, display.contentWidth, display.contentHeight )
	background.x, background.y = display.contentWidth/2, display.contentHeight/2

	makeWalls()
	
	return background 
end

function makeWalls(  )
	local borderGroup = display.newGroup()

	borderBodyElement = { density = 20.0, friction = 0.5, bounce = 0.0 }

	local borderTop = display.newRect( 0, 0, display.contentWidth*2, 0 ) 
	borderTop:setFillColor( 0, 0, 0)
	physics.addBody( borderTop, "static", borderBodyElement )
	borderTop.myName = "border top" 

	local borderBottom = display.newRect( 0, display.contentHeight, display.contentWidth*2, 0 )
	borderBottom:setFillColor( 0, 0, 0)
	physics.addBody( borderBottom, "static", borderBodyElement )
	borderBottom.myName = "border bottom" 

	local borderLeft = display.newRect( 0, 0, 0, display.contentHeight*2 )
	borderLeft:setFillColor( 0, 0, 0)	
	physics.addBody( borderLeft, "static", borderBodyElement )
	borderLeft.myName = "border left" 

	local borderRight = display.newRect( display.contentWidth, 0, 0, display.contentHeight*2 )
	borderRight:setFillColor( 0, 0, 0)
	physics.addBody( borderRight, "static", borderBodyElement )
	borderRight.myName = "border right" 
	
	borderGroup:insert(borderTop)
	borderGroup:insert(borderBottom)
	borderGroup:insert(borderLeft)
	borderGroup:insert(borderRight)
	borderGroup.isVisible = false

	borderTop.collision = onWallCollision
	borderTop:addEventListener( "collision" )
	borderBottom.collision = onWallCollision
	borderBottom:addEventListener( "collision" )
	borderRight.collision = onWallCollision
	borderRight:addEventListener( "collision" )
	borderLeft.collision = onWallCollision
	borderLeft:addEventListener( "collision" )
	
	return borderGroup
end

function onWallCollision( self, e )
	if e.other.myName == "bullet" then
		e.other:removeSelf()
		e.other = nil
	elseif e.other.myName == "celestino" then
		
	end
end

return background