local Ammo = {}

Ammo.isAmmo = true
Ammo.damage = 1
Ammo.speed = 1000
Ammo.range = 600
Ammo.img = ""
Ammo.size = {w = 10, h = 20}
Ammo.countdown = nil

function Ammo:new(group, position, angle)
	local instance = {}
	setmetatable(instance, self)
	self.__index = self
	instance.angle = angle
	instance.image = self:loadImage(group, position, instance)
	instance:move()
	return instance
end

function Ammo:loadImage(group, position, instance)
	local width, height = self.size.w, self.size.h
	local image = display.newRect(group, 0, 0, width, height)
	--local image = display.newImageRect(group, img, size.w, size.h)
	physics.addBody(image, "dynamic")
	image.isSensor = true
	image.isBullet = true
	image:toBack()
	image.x, image.y = position.x, position.y
	image.object = instance
	image.rotation = instance.angle
	return image
end

function Ammo:collideMonster(monster)
	self:remove()
end

function Ammo:move()
	local image = self.image
	local angle = math.rad(self.angle) + math.rad(90)
	local vx, vy = self.speed * math.cos(angle), self.speed * math.sin(angle)
	image:setLinearVelocity(vx, vy)
	local lifeTime = self.range / self.speed * 1000
	self.countdown = timer.performWithDelay(lifeTime, function() self.remove(self) end)
end

function Ammo:remove()
	if self.countdown then timer.cancel(self.countdown) end
	local image = self.image
	image:removeSelf()
	image.object = nil
	self.image = nil
end

return Ammo