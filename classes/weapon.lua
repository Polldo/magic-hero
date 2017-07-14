local Weapon = {}

Weapon.hero = nil
Weapon.heroDelay = nil
Weapon.delay = 10
Weapon.isCharged = true
Weapon.isShooting = false
Weapon.imgPath = ""
Weapon.size = {w = 50, h = 50}
Weapon.ammo = require"classes.ammo"

function Weapon:new(group, hero)
	local instance = {}
	setmetatable(instance, self)
	self.__index = self
	instance.image = self:loadImage(group, instance)
	instance.group = group
	instance.hero = hero
	instance.heroDelay = hero.shootDelay
	instance:activateShoot()
	return instance
end

function Weapon:loadImage(group, instance)
	local width, height = self.size.w, self.size.h
	local image = display.newRect(group, 222, 2, width, height)
	--local image = display.newImageRect(group, img, size.w, size.h)
	physics.addBody(image, "dynamic", {box = { halfWidth=64, halfHeight=8, x=0, y=8, angle=0 }})
	image.isSensor = true
	image.object = instance
	image:setFillColor( 0.4, 0.4, 0.4, 0.9 )
	return image
end

function Weapon:setAmmo(ammo)
	self.ammo = ammo
end

function Weapon:activateShoot()
	local heroImage = self.hero.image
	function self.keyFunc(event)
		if event.phase == "began" then
			heroImage.rotation = event.angle
			self:startShoot()
		elseif event.phase == "ended" then 
			self:stopShoot()
		elseif event.phase == "moved" then
			heroImage.rotation = event.angle
		end
	end
	Runtime:addEventListener("shootAxis", self.keyFunc)  
end

function Weapon:startShoot()
	self.isShooting = true
	self:shoot()
end

function Weapon:shoot()
	if self.isCharged then
		--shoot
		self.ammo:new(self.group, {x = self.image.x, y = self.image.y}, self.hero.image.rotation)

		self.isCharged = false
		local delay = self.delay + self.heroDelay
		self.reloading = timer.performWithDelay(delay, function() self.reload(self) end)
	end
end

function Weapon:reload()
	self.isCharged = true
	if self.isShooting then
		self:shoot()
	end
end

function Weapon:stopShoot()
	self.isShooting = false
end

function Weapon:setHeroDelay(delay)
	self.heroDelay = delay
end

function Weapon:deactivate()
	self.stopShoot()
	timer.cancel(self.reloading)
	Runtime:removeEventListener("key", self.keyFunc)
end

return Weapon