local backgroundCollision = {}

backgroundCollision.onWallCollision = function ( self, e )
	if e.other.myName == "bullet" then
		e.other:removeSelf()
		e.other = nil
	elseif e.other.myName == "celestino" then
		
	end
end

return backgroundCollision