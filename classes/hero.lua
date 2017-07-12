local Hero = {}

Hero.image = nil
Hero.imgPath = ""
Hero.size = {w = 70, h = 70}
Hero.weapon = nil
Hero.shootDelay = 200
Hero.speed = 300
Hero.health = 200

function Hero:new(group)
	local instance = {}
	setmetatable(instance, self)
	self.__index = self
	instance.image = self:loadImage(group, instance)
	instance:activateMovement()
	return instance
end

function Hero:loadImage(group, instance)
	local width, height = self.size.w, self.size.h
	local image = display.newRect(group, 0, 0, width, height)
	--local image = display.newImageRect(group, img, size.w, size.h)
	physics.addBody(image, "dynamic", {box = { halfWidth=64, halfHeight=8, x=0, y=8, angle=0 }})
	image.object = instance
	image.isFixedRotation = true
	return image
end

function Hero:setWeapon(weapon)
	self.weapon = weapon
end

function Hero:activateMovement()
	local instance = self
	local lastDirection = nil
	local function key(event)
		if event.phase == "down" then
			if event.keyName == "right" then 
				instance:moveRight()
				lastDirection = "right"
			elseif event.keyName == "left" then 
				instance:moveLeft()
				lastDirection = "left"
		  	end
		elseif event.phase == "up" then 
			if event.keyName == "right" then
				instance:stopMovement()
			elseif event.keyName == "left" then 
				instance:stopMovement()
			end
		elseif event.phase == "moved" then
			print(event.keyName)
			if event.keyName == "right" and lastDirection ~= "right" then
				instance:moveRight()
				lastDirection = "right"
			elseif event.keyName == "left" and lastDirection ~= "left" then
				instance:moveLeft()
				lastDirection = "left"
			end
		end
	end
	Runtime:addEventListener("key", key)  
end		

function Hero:moveRight()
	local image = self.image
	image:setLinearVelocity(self.speed, 0)
end

function Hero:moveLeft()
	local image = self.image
	image:setLinearVelocity(-self.speed, 0)
end

function Hero:stopMovement()
	local image = self.image
	image:setLinearVelocity(0, 0)
	local vx, vy = image:getLinearVelocity()
	if self.weapon then
		local weaponImage = self.weapon.image
		weaponImage:setLinearVelocity(0, 0)
	end
end


return Hero 