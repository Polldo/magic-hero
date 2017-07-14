local Monster = {}

Monster.isMonster = true
Monster.health = 20
Monster.speed = 10
Monster.damage = 20
Monster.size = {w = 40, h = 40}
--Monster.moving = nil

function Monster:new(group)
	local instance = {}
	setmetatable(instance, self)
	self.__index = self
	instance.image = self:loadImage(group, instance)
	instance:move()
	instance:activateCollision()
	return instance
end

function Monster:loadImage(group, instance)
	local width, height = self.size.w, self.size.h
	local image = display.newRect(group, 0, 0, width, height)
	--local image = display.newImageRect(group, img, size.w, size.h)
	physics.addBody(image, "dynamic", {isSensor = true})
	image.object = instance
	return image
end

function Monster:activateCollision()
	local image = self.image
	function image:collision(event)
		local self = self.object
		if event.phase == "began" then
			local object = event.other.object
			if object.isAmmo then
				self:collideAmmo(object)
				object:collideMonster(self)
			end
		end
	end
  	image:addEventListener("collision") 
end

function Monster:collideAmmo(ammo)
	self:remove()
end

function Monster:collideHero(hero)
	self:remove()
end

function Monster:move()
	self.moving = timer.performWithDelay(10, function() self:movement() end, 0)
end

function Monster:movement()
	local image = self.image
	if image.y < -10 then
		self:remove()
	else
		image.y = image.y - self.speed
	end
end

function Monster:remove()
	self.image:removeEventListener("collision")
	timer.cancel(self.moving)
	self.image:removeSelf()
	self.image.object = nil
	self.image = nil
	self = nil
end

return Monster