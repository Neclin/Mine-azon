local mineAzonAPI = require "Mine-azon"

local saplingSpots = {}

function generatePlantPattern(width, height, wSpace, hSpace)
    local saplingsWide = math.floor(width / (wSpace + 1) + 1)
    local saplingsHigh = math.floor(height / (hSpace + 1) + 1)
    
    for z = 0, height, hSpace+1 do
        for x = 0, width, wSpace+1 do
            table.insert(saplingSpots, vector.new(x, 0, z))
        end
    end
end

function plant(saplingType)
    local area = textutils.unserialise(settings.get("area"))
    local areaPosition = tableToVector(area.position)

    local inventory = readInvetoryData()
    local count = 0
    local flag = false
    for index, item in pairs(inventory) do
        if item.name == saplingType then
            if count + item.count > #saplingSpots then
                flag = true
                break
            else count = count + item.count end
        end
    end
    if flag == false then
        return "Not enough " .. saplingType
    end

    moveToPoint(areaPosition)

    for index, position in pairs(saplingSpots) do
        -- move above the position
        moveToPoint(areaPosition + position + vector.new(0, 1, 0))
        turtle.placeDown()
    end

    moveToPoint(areaPosition - vector.new(1, 0, 1))
end

determinePosition()
determineDirection()

generatePlantPattern(16, 16, 4, 4)

plantStatus = plant("minecraft:oak_sapling")
print(plantStatus)