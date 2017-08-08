local Monster = {}

Monster.isMonster = true
Monster.health = 20
Monster.speed = 10
Monster.damage = 20
Monster.size = {w = 40, h = 40}
--Monster.moving = nil

function Monster:new()
	local instance = {}
	setmetatable(instance, {__index = self})
	return instance
end

function Monster:activate(group)
	self.image = self:loadImage(group)
	self:move()
	self:activateCollision()
end

function Monster:loadImage(group)
	local width, height = self.size.w, self.size.h
	local image = display.newRect(group, 0, 0, width, height)
	--local image = display.newImageRect(group, img, size.w, size.h)
	physics.addBody(image, "dynamic")
	image.object = self
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