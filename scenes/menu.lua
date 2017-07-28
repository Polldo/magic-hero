-- Requirements
local composer = require "composer"

-- Variables local to scene
local scene = composer.newScene()

local function gotoGame()
  composer.gotoScene("scenes.game")
end

local function gotoHangar()
  composer.gotoScene("scenes.hangar")
end

function scene:create( event )
  local sceneGroup = self.view -- add display objects to this group

  local playButton = display.newText(sceneGroup, "Play", 50, 100, native.systemFont, 30)
    playButton:addEventListener("tap", gotoGame)

  local hangarButton = display.newText(sceneGroup, "Hangar", 400, 100, native.systemFont, 30)
    hangarButton:addEventListener("tap", gotoHangar)

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