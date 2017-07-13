local Monster = {}

Monster.isMonster = true
Monster.health = 20
Monster.speed = 10
Monster.damage = 20
Monster.size = {w = 15, h = 20}
--Monster.moving = nil

function Monster:new(group)
	local instance = {}
	setmetatable(instance, self)
	self.__index = self
	instance.image = self:loadImage(group, instance)
	instance:move()
	return instance
end

function Monster:loadImage(group, instance)
	local width, height = self.size.w, self.size.h
	local image = display.newRect(group, 0, 0, width, height)
	--local image = display.newImageRect(group, img, size.w, size.h)
	physics.addBody(image, "dynamic")
	image.object = instance
	return image
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
	timer.cancel(self.moving)
	self.image:removeSelf()
	self.image.object = nil
	self.image = nil
end

return Monster