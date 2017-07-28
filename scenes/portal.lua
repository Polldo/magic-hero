-- Requirements

--USING THESE ONLY FOR THIS MOMENT. RESPONSIBILITY TO KNOW CLASSES BELONGS TO STORAGE SINGLETON CLASS. (TAKE IT FROM THE COMPOSER VARIABLES)
local composer = require "composer"
local Joystick = require "lib.joystick"
local Hero = require "classes.hero"
local Weapon = require "classes.weapon"
local Monster = require "classes.monster"
local MonsterChaser = require "classes.monster-chaser"

local physics = require("physics")

local scene = composer.newScene()
local backGroup
local mainGroup
local uiGroup
local jsSxGroup
local jsDxGroup

local hero
local weapon
local monsters = {}

local function spawnMonster(intWave)
  local numberMonsterPerWave = {5, 10, 6}
  --   local monster = Monster:new()
  --   monster:activate(mainGroup)
  --   monster.image.x, monster.image.y = hero.image.x, display.actualContentHeight
  -- monster = MonsterChaser:new(mainGroup, hero)
  --   monster.image.x, monster.image.y = hero.image.x, display.actualContentHeight

end

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
    weapon.image.x, weapon.image.y = hero.image.x + weapon.image.width/2, hero.image.y
  hero:setWeapon(weapon)
  local joint = physics.newJoint("weld", hero.image, weapon.image, hero.image.x, hero.image.y)

  local w = display.actualContentWidth/4
  local h = display.actualContentHeight/8
  local jsRadius = math.min(w, h)
  local joystickMov = Joystick.new("axis", jsRadius/2, jsRadius)
    joystickMov.x, joystickMov.y = display.screenOriginX + joystickMov.width/2, display.actualContentHeight - joystickMov.height/2
    jsSxGroup = joystickMov.group
  local joystickShoot = Joystick.new("shootAxis", jsRadius/3, jsRadius)
    joystickShoot.x, joystickShoot.y = display.actualContentWidth - joystickShoot.width/2, display.actualContentHeight - joystickShoot.height/2
    jsDxGroup = joystickShoot.group

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