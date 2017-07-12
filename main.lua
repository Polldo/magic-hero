local composer = require("composer")
display.setStatusBar(display.HiddenStatusBar)
system.activate("multitouch")

math.randomseed(os.time())

composer.gotoScene("scenes.game")

local button = require "classes.button"
local left = button.newButton("left", 70)
	left.x, left.y = display.screenOriginX + left.width/2, display.actualContentHeight - left.height/2
local right = button.newButton("right", 70)
	right.x, right.y = left.x + left.width/2 + right.width/2, left.y
local action = button.newButton("action", 90)
	action.x, action.y = display.actualContentWidth - action.width/2, display.actualContentHeight - action.height/2


