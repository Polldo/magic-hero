local composer = require("composer")
display.setStatusBar(display.HiddenStatusBar)
system.activate("multitouch")

math.randomseed(os.time())

composer.gotoScene("scenes.game")