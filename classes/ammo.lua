local Ammo = {}

Ammo.damage = 1
Ammo.speed = 1
Ammo.range = 500
Ammo.img = ""
Ammo.size = {w = 10, h = 10}
Ammo.transition = nil

function Ammo:new(group, position)
	local instance = {}
	setmetatable(instance, self)
	self.__index = self
	instance.image = self:loadImage(group, position, instance)
	instance:move()
	return instance
end

function Ammo:loadImage(group, position, instance)
	local width, height = self.size.w, self.size.h
	local image = display.newRect(group, 0, 0, width, height)
	--local image = display.newImageRect(group, img, size.w, size.h)
	physics.addBody(image, "dynamic", {isSensor = true})
	image.isBullet = true
	image:toBack()
	image.x, image.y = position.x, position.y
	image.object = instance
	return image
end

function Ammo:move()
	local image = self.image
	self.transition = transition.to(image, {
			y = image.y + self.range,
			onComplete = function() self.remove(self) end
		})
end

function Ammo:remove()
	transition.cancel(self.transition)
	local image = self.image
	image:removeSelf()
	image.object = nil
	self.image = nil
end

return Ammo