local Hero = {}

Hero.isHero = true
Hero.image = nil
Hero.imgPath = ""
Hero.size = {w = 70, h = 70}
Hero.weapon = nil
Hero.shootDelay = 200
Hero.speed = 800
Hero.health = 200

function Hero:new(group)
	local instance = {}
	setmetatable(instance, self)
	self.__index = self
	instance.image = self:loadImage(group, instance)
	instance:activateMovement()
	instance:activateCollision()
	return instance
end

function Hero:loadImage(group, instance)
	local width, height = self.size.w, self.size.h
	local image = display.newRect(group, 0, 0, width, height)
	--local image = display.newImageRect(group, img, size.w, size.h)
	physics.addBody(image, "dynamic")--, {box = { halfWidth=64, halfHeight=8, x=0, y=8, angle=0 }})
	image.object = instance
	image.isFixedRotation = true
	return image
end

function Hero:setWeapon(weapon)
	self.weapon = weapon
end

function Hero:activateCollision()
	local image = self.image
	function image:collision(event)
		local self = self.object
		if event.phase == "began" then
			local object = event.other.object
			if object.isMonster then
				self:collideMonster(object)
				object:collideHero(self)
			elseif object.isDrop then
				--self:collideDrop(object) probably useful for changing audio or something similar
				object:collideHero(self)
			end
		end
	end
  	image:addEventListener("collision") 
end

function Hero:collideMonster(monster)
	local damage = monster.damage
	self:remove()
end

function Hero:activateMovement()
	local instance = self
	local lastDirection = nil
	function self.axis(event)
		if event.phase == "began" or event.phase == "moved" then
			instance:move(event.axisX, event.axisY, event.angle)
		elseif event.phase == "ended" then 
			instance:stopMovement()
		end
	end
	Runtime:addEventListener("axis", self.axis)  
end		

function Hero:move(dx, dy, angle)
	local image = self.image
	local speed = self.speed
	image:setLinearVelocity(dx*speed, dy*speed)
	if not self.weapon.isShooting then
		image.rotation = angle
	end
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

function Hero:deactivate()
	self.image:removeEventListener("collision")
	Runtime:removeEventListener("axis", self.axis)
end

function Hero:remove()
	self.weapon:remove()
	self:deactivate()
	self.image.object = nil
	self.image:removeSelf()
	self.image = nil
	self = nil
end

return Hero 