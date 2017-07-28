local Monster = require("classes.Monster")

local MonsterChaser = Monster:new()

MonsterChaser.size = {w = 40, h = 50}

function MonsterChaser:new(group, hero)
	local instance = self.__index.new(self)
	instance:activate(group, hero)
	return instance
end

function MonsterChaser:activate(group, hero)
	getmetatable(self.__index).activate(self, group)
	self.hero = hero
end

function MonsterChaser:movement()
	local image = self.image
	local heroImage = self.hero.image
	if image.y < -10 then
		self:remove()
	else
		if image.x > heroImage.x + self.speed then image.x = image.x - self.speed 
			elseif image.x < heroImage.x - self.speed then image.x = image.x + self.speed end
		if image.y > heroImage.y + self.speed then image.y = image.y - self.speed 
			elseif image.y < heroImage.y - self.speed then image.y = image.y + self.speed end
	end
end

return MonsterChaser