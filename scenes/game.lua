-- Requirements
local composer = require "composer"

-- Variables local to scene
local scene = composer.newScene()

local storage

local function gotoPortal(event)
  local portal = event.target
  composer.gotoScene(portal.path)
end

function scene:create( event )
  local sceneGroup = self.view -- add display objects to this group

  storage = composer.getVariable("storage")
  local portals = storage.portals
  local portalListX, portalListY = 0, 30
  for i = 1, #portals, 1 do
    local portal = display.newRect(sceneGroup, 0, 0, 30, 30)
      portalListX = portalListX + 50
      portal.x, portal.y = portalListX, portalListY 
      portal.path = portals[i].path
      portal:addEventListener("tap", gotoPortal)
  end

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