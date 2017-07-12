local Button = {}
local stage = display.getCurrentStage()

function Button.newButton(key, img)
	
	local instance

	if type(img) == "number" then
	    instance = display.newCircle(0,0, img)
	    instance:setFillColor(0.2, 0.2, 0.2, 0.9)
	    instance.strokeWidth = 6
	    instance:setStrokeColor(1, 1, 1, 1)
  	else
    	instance = display.newImage(img, 0, 0)
  	end

	function instance:touch(event)
		local phase = event.phase
		if phase == "began" then
			if event.id then stage:setFocus(event.target, event.id) end
			instance._xScale, instance._yScale = instance.xScale, instance.yScale
			instance.xScale, instance.yScale = instance.xScale * 0.95, instance.yScale * 0.95
			local keyEvent = {name = "key", phase = "down", keyName = key or "none"}
			Runtime:dispatchEvent(keyEvent)
		elseif phase=="ended" or phase == "canceled" then
		    if event.id then stage:setFocus(nil, event.id) end
			instance.xScale, instance.yScale = instance._xScale, instance._yScale
			local keyEvent = {name = "key", phase = "up", keyName = key or "none"}
			Runtime:dispatchEvent(keyEvent)
			--let's use the stage focus to know the last key pressed
		elseif phase == "moved" then
		    --if event.id then stage:setFocus(nil, event.id) end
		    print(event.target)
		    --local keyEvent
		    --if event.x < self.x - self.width/2 then
			local	keyEvent = {name ="key", phase = "moved", keyName = "outerLeft" or "none"}
			--elseif event.x > self.x - 
			Runtime:dispatchEvent(keyEvent)			
		end
		return true
	end

	function instance:activate()
		self:addEventListener("touch")
	end

	function instance:deactivate()
		self:removeEventListener("touch")
	end

	instance:activate()
	return instance
end

return Button