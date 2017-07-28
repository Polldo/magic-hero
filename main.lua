local composer = require("composer")
display.setStatusBar(display.HiddenStatusBar)
system.activate("multitouch")

math.randomseed(os.time())

local storage = require "classes.storage"
composer.setVariable("storage", storage)

composer.gotoScene("scenes.menu")