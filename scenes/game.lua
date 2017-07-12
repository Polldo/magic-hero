-- Requirements
local composer = require "composer"
local Hero = require "classes.hero"
local Weapon = require "classes.weapon"

local physics = require("physics")

local scene = composer.newScene()
local backGroup
local mainGroup
local uiGroup

local hero
local weapon

function scene:create( event )
  local sceneGroup = self.view 
  physics.start()
  physics.setGravity(0, 0)

  backGroup = display.newGroup() 
  sceneGroup:insert( backGroup )  

  mainGroup = display.newGroup() 
  sceneGroup:insert( mainGroup )  

  uiGroup = display.newGroup()   
  sceneGroup:insert( uiGroup )    

  hero = Hero:new(mainGroup)
  hero.image.x, hero.image.y = display.actualContentWidth/2, hero.image.height*2
  weapon = Weapon:new(mainGroup, hero)
  hero.weapon = weapon
  weapon.image.x, weapon.image.y = hero.image.x + weapon.image.width/2, hero.image.y*3/2
  local joint = physics.newJoint("weld", hero.image, weapon.image, hero.image.x, hero.image.y)


end

local function enterFrame(event)
  local elapsed = event.time

end

function scene:show( event )
  local phase = event.phase
  if ( phase == "will" ) then
    Runtime:addEventListener("enterFrame", enterFrame)
  elseif ( phase == "did" ) then

  end
end

function scene:hide( event )
  local phase = event.phase
  if ( phase == "will" ) then

  elseif ( phase == "did" ) then
    Runtime:removeEventListener("enterFrame", enterFrame)  
  end
end

function scene:destroy( event )
  --collectgarbage()
end

scene:addEventListener("create")
scene:addEventListener("show")
scene:addEventListener("hide")
scene:addEventListener("destroy")

return scene