local MineAzonAPI = require "Mine-azon"

-- initialisePosition()

-- setUpArea()

settings.load(".settings")

-- determinePosition()
-- determineDirection()

-- moveForward(10)
-- moveForward(-10)

moveToPoint(vector.new(56, 66, -151))

moveToPoint(vector.new(50, 73, -154))

-- moveToPoint(vector.new(-500, 100, 0))

-- Area Position
local area = textutils.unserialise(settings.get("area"))

moveToPoint(tableToVector(area.position))

-- faceDirection(4)
-- faceDirection(3)

settings.save(".settings")