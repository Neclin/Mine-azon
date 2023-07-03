-- An API for the Mine-azon delivery service

-- Movement systems

function initialisePosition()
    print("Enter the X, Y and Z coordinates of the turtle with spaces between using the F3 menu")
    local positionString = read()
    position = {}
    for coordinate in positionString:gmatch("%S+") do
         table.insert(position, coordinate) 
    end
    position = vector.new(position[1], position[2], position[3])
    settings.set("position", textutils.serialise(position))

    print("Enter the currect direction number")
    print("West is 1 North is 2 East is 3 South is 4")
    local direction = read()
    settings.set("direction", textutils.serialise(direction))
end

function determinePosition()
    local position = vector.new(gps.locate())
    if position.x == nil then return end

    settings.set("position", textutils.serialise(position))
end

function determineDirection()
    local startPosition = vector.new(gps.locate())
    if startPosition.x == nil then return end

    if turtle.detect() then turtle.dig() end
    turtle.forward()
    local endPosition = vector.new(gps.locate())
    local heading = endPosition - startPosition
    local direction = ((heading.x + math.abs(heading.x) * 2) + (heading.z + math.abs(heading.z) * 3))
    settings.set("direction", textutils.serialise(direction))
    turtle.back()
end

function moveForward(amount)
    local direction = textutils.unserialise(settings.get("direction"))
    local xMovement = (direction - 2) * (direction % 2) * amount
    local zMovement = (direction - 3) * ((direction + 1) % 2) * amount
    
    local position = textutils.unserialise(settings.get("position"))
    position = position + vector.new(xMovement, 0, zMovement)
    settings.set("position", textutils.serialise(position))
    
    for i = 1, math.abs(amount) do
        if amount > 0 then turtle.forward() 
        else turtle.back() end
    end
    settings.save(".settings")

end

function changeDirection(signedAmount)
    local direction = textutils.unserialise(settings.get("direction"))
    direction = (direction + signedAmount) % 4
    if direction == 0 then direction = 4 end
    settings.set("direction", textutils.serialise(direction))
end

function moveLeft(amount)
    changeDirection(-1)

    turtle.turnLeft()
    moveForward(amount)
end

function moveRight(amount)
    changeDirection(1)

    turtle.turnRight()
    moveForward(amount)
end

function shiftLeft(amount)
    moveLeft(amount)
    changeDirection(1)
    turtle.turnRight()
end

function shiftRight(amount)
    moveRight(amount)
    changeDirection(-1)
    turtle.turnLeft()
end

function moveUp(amount)
    local position = textutils.unserialise(settings.get("position"))
    position = position + vector.new(0, amount, 0)
    settings.set("position", textutils.serialise(position))

    for i = 1, math.abs(amount) do
        if amount > 0 then turtle.up() 
        else turtle.down() end
    end
end

function faceDirection(direcitonNumber)
    local direction = textutils.unserialise(settings.get("direction"))
    if direction == direcitonNumber then return end
    local rightAmount = (direcitonNumber - direction) % 4
    local leftAmount = (direction - direcitonNumber) % 4
    local amount = rightAmount
    local turnDirection = 1
    if rightAmount > leftAmount then
        amount = leftAmount
        turnDirection = -1
    end

    for i=1, amount do
        if turnDirection == 1 then turtle.turnRight() 
        else turtle.turnLeft() end
    end
    changeDirection(amount * turnDirection)
end

function moveToPoint(endPosition)
    local position = textutils.unserialise(settings.get("position"))
    local directionToMove = endPosition - position
    
    -- Move Up first
    if directionToMove.y > 0 then 
        moveUp(directionToMove.y)
    end
    
    -- move X
    if directionToMove.x > 0 then
        faceDirection(3)
    else
        faceDirection(1)
    end
    moveForward(math.abs(directionToMove.x))

    -- Move Y
    if directionToMove.z > 0 then
        faceDirection(4)
    else
        faceDirection(2)
    end
    moveForward(math.abs(directionToMove.z))

    -- move down last
    if directionToMove.y < 0 then
        moveUp(directionToMove.y)
    end
end

function tableToVector(table)
    return vector.new(table.x, table.y, table.z)
end

function readShulkerData(invetorySlot)
    turtle.select(invetorySlot)
    local item = turtle.getItemDetail()

    if item.name ~= "minecraft:shulker_box" then
        return "There is not a shulker in slot " .. textutils.serialise(invetorySlot)
    end

    local blockInfront = turtle.detect()
    if blockInfront then
        return "Block Not Free"
    end

    -- Place the shulker and read its data
    local placed = false
    while not placed do -- Keep trying to place the shulker until its placed
        placed = turtle.place()
    end
    sleep(0.076) -- Wait so it can detect the block has been placed
    
    local shulker = peripheral.wrap("front")
    local shulkerData = shulker.list()

    -- Pick the shulker back up
    turtle.dig()
    return shulkerData
end


function setUpArea()
    local position = textutils.unserialise(settings.get("position"))
    print("right the size of the area X / width, Y / height, Z/ depth")
    local sizeString = read()
    size = {}
    for dimention in sizeString:gmatch("%S+") do
         table.insert(size, dimention) 
    end
    local area = { position = position, size = size }
    settings.set("area", textutils.serialise(area))
end

return { 
        moveForward = moveForward, 
        moveLeft = moveLeft,
        moveRight = moveRight,
        shiftLeft = shiftLeft,
        shiftRight = shiftRight, 
        faceDirection = faceDirection,
        determineDirection = determineDirection,
        determinePosition = determinePosition,
        moveToPoint = moveToPoint,
        initialisePosition = initialisePosition, 

        tableToVector = tableToVector,

        readShulkerData = readShulkerData,
        setUpArea = setUpArea,
    }