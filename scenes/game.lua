-- Requirements
local composer = require "composer"
local Joystick = require "classes.joystick"
local Button = require "classes.button"
local Hero = require "classes.hero"
local Weapon = require "classes.weapon"
local Monster = require "classes.monster"

local physics = require("physics")

local scene = composer.newScene()
local backGroup
local mainGroup
local uiGroup
local jsGroup

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
  weapon.image.x, weapon.image.y = hero.image.x + weapon.image.width/2, hero.image.y
  local joint = physics.newJoint("weld", hero.image, weapon.image, hero.image.x, hero.image.y)

  local monster = Monster:new(mainGroup)
    monster.image.x, monster.image.y = hero.image.x, display.actualContentHeight

  local action = Button.newButton(uiGroup, "action", 90)
    action.x, action.y = display.actualContentWidth - action.width/2, display.actualContentHeight - action.height/2

  local joystick = Joystick.new(20, 100)
    joystick.x, joystick.y = display.screenOriginX + joystick.width/2, display.actualContentHeight - joystick.height/2
    jsGroup = joystick.group


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