local Ammo = {}

Ammo.isAmmo = true
Ammo.damage = 1
Ammo.speed = 1
Ammo.range = 500
Ammo.img = ""
Ammo.size = {w = 10, h = 10}
Ammo.transition = nil

function Ammo:new(group, position, angle)
	local instance = {}
	setmetatable(instance, self)
	self.__index = self
	instance.image = self:loadImage(group, position, instance)
	instance.angle = angle
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
	local angle = math.rad(self.angle) + math.rad(90)
	local x, y = math.cos(angle)*self.range, math.sin(angle)*self.range
	self.transition = transition.to(image, {
			y = image.y + y, x = image.x + x,
			time = self.range / self.speed,
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