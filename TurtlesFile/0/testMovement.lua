local mineAzonAPI = require "Mine-azon"

local greenPosition = vector.new(44, 66, -180)

local redPosition = vector.new(53, 66, -177)

determinePosition()
determineDirection()

moveToPoint(greenPosition)
moveToPoint(redPosition)

settings.save(".settings")