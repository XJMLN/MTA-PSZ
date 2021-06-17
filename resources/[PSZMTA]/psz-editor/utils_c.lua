local sw, sh = guiGetScreenSize()

function edytor_velocityAngleZtoX(angle, distance)
	if not distance then distance = 1 end
	local xVel = math.cos(math.rad(angle)) * distance
	local yVel = math.sin(math.rad(angle)) * distance
	return xVel, yVel
end

function edytor_velocityAngleZtoY(angle, distance)
	if not distance then distance=1 end
	local xVel = math.sin(math.rad(angle)) * distance
	local yVel = math.cos(math.rad(angle)) * distance
	return xVel, yVel
end

function edytor_getCursor(minX, minY, maxX, maxY)
	local cX, cY = getCursorPosition()
	if (not cX) then return false end
	cX, cY = cX * sw, cY * sh
	if (cX > minX and cX < maxX and cY > minY and cY < maxY) then return true end
	return false
end

function getOffsetFromXYZ( mat, vec, off )
    -- make sure our matrix is setup correctly 'cos MTA used to set all of these to 1.
    mat[1][4] = 0
    mat[2][4] = 0
    mat[3][4] = 0
    mat[4][4] = 1
    mat = matrix.invert( mat )
    if off == 1 then 
    	local offX = vec[1] * mat[1][1] + vec[2] * mat[2][1] + vec[3] * mat[3][1] + mat[4][1]
    	return offX
    elseif off == 2 then 
    	local offY = vec[1] * mat[1][2] + vec[2] * mat[2][2] + vec[3] * mat[3][2] + mat[4][2]
    	return offY
    elseif off == 3 then
    	local offZ = vec[1] * mat[1][3] + vec[2] * mat[2][3] + vec[3] * mat[3][3] + mat[4][3]
    	return offZ
    else
    	return {offX, offY, offZ}
    end
end