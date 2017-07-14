local Joystick = {}

local stage = display.getCurrentStage()

function Joystick.new(nameEvent, innerRadius, outerRadius)
	innerRadius, outerRadius = innerRadius or 48, outerRadius or 96
	local instance = display.newGroup()
		instance.nameEvent = nameEvent
	local outerArea 
	if type(outerRadius) == "number" then
		outerArea = display.newCircle( instance, 0,0, outerRadius )
		outerArea.strokeWidth = 8
		outerArea:setFillColor( 0.2, 0.2, 0.2, 0.9 )
		outerArea:setStrokeColor( 1, 1, 1, 1 )
	else
		outerArea = display.newImage( instance, outerRadius, 0,0 )
		outerRadius = (outerArea.contentWidth + outerArea.contentHeight) * 0.25
	end

	local joystick 
	if type(innerRadius) == "number" then
		joystick = display.newCircle( instance, 0,0, innerRadius )
		joystick:setFillColor( 0.4, 0.4, 0.4, 0.9 )
		joystick.strokeWidth = 6
		joystick:setStrokeColor( 1, 1, 1, 1 )
	else
		joystick = display.newImage( instance, innerRadius, 0,0 )
		innerRadius = (joystick.contentWidth + joystick.contentHeight) * 0.25
		joystick.group = instance
	end  

	-- where should joystick motion be stopped?
	local stopRadius = outerRadius - innerRadius

	function joystick:touch(event)
		local phase = event.phase
		if phase=="began" or (phase=="moved" and self.isFocus) then
			if phase == "began" then
				stage:setFocus(event.target, event.id)
				self.eventID = event.id
				self.isFocus = true
			end
			local parent = self.parent
			local posX, posY = parent:contentToLocal(event.x, event.y)
			local angle = -math.atan2(posY, posX)
			local angleDeg = math.deg(-math.atan2( posX, posY ))
			instance.angle = angleDeg
			local distance = math.sqrt((posX*posX)+(posY*posY))

			if( distance >= stopRadius ) then
				distance = stopRadius
				self.x = distance*math.cos(angle)
				self.y = -distance*math.sin(angle)
			else
				self.x = posX
				self.y = posY
			end
		else
			self.x = 0
			self.y = 0
			stage:setFocus(nil, event.id)
			self.isFocus = false
			axisEvent = {name = instance.nameEvent, phase = event.phase}
			Runtime:dispatchEvent(axisEvent)
		end
		instance.axisX = self.x / stopRadius
		instance.axisY = self.y / stopRadius
		local axisEvent
		if self.y == self._y then
			instance.axisY = 0
		end
		if self.x == self._x then
			instance.axisX = 0
		end
		if instance.axisX ~= 0 or instance.axisY ~= 0 then
			axisEvent = {name = instance.nameEvent, phase = event.phase, axisX = instance.axisX, axisY = instance.axisY, angle = instance.angle}
			Runtime:dispatchEvent(axisEvent)
			print("X:   " .. instance.axisX .. "     Y:  " .. instance.axisY .. "    Angle: " .. instance.angle)
		end
		self._x, self._y = self.x, self.y
		return true
	end

	function instance:activate()
		self:addEventListener("touch", joystick )
		self.axisX = 0
		self.axisY = 0
	end

	function instance:deactivate()
		stage:setFocus(nil, joystick.eventID)
		joystick.x, joystick.y = outerArea.x, outerArea.y
		self:removeEventListener("touch", self.joystick )
		self.axisX = 0
		self.axisY = 0
	end

	instance:activate()
	return instance
end

return Joystick