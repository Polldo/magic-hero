local Drop = {}

Drop.isDrop = true
Drop.size = {w = 20, h = 20}
Drop.imgPath = ""

function Drop:new(position)
	local instance = {}
	setmetatable(instance, self)
	self.__index = self
	instance.image = self:loadImage(group, instance)
	return instance
end

function Drop:loadImage(group, instance)
	local width, height = self.size.w, self.size.h
	local image = display.newRect(group, 0, 0, width, height)
	--local image = display.newImageRect(group, img, size.w, size.h)
	physics.addBody(image, "dynamic")
	image.isSensor = true
	image.object = instance
	return image
end

function Drop:collideHero(hero)
	self.remove()
end

function Drop:remove()
	self.image.object = nil
	self.image:removeSelf()
	self.image = nil
end

return Drop