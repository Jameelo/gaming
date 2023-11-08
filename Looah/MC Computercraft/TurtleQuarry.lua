--[[
    Quarry code for a turtle
    Digs an WIDTH by WIDTH hole, DEPTH blocks deep; specified by the input
    Calculates fuel efficiency
    Recognises a full inventory & dumps excess into ender chest
    TODO:
    - Move setup into a single function, maybe even allow values to be passed in before runtime as an option
    - Make code support rectangular paths
    - Change the way it calculates a full inventory, as currently it slows down mining a lot
]]

RETURNCOND = 0
DEPTH = 0
WIDTH = 0
ECPRESENT = false
CHESTS = {"enderstorage:ender_chest", "minecraft:chest"} -- LIST OF CHESTS ordered by importance
EC = CHESTS[1] -- Enderstorage Ender chest ID, this one is special as this chest will link to the main home storage system.

function setDimensions()
    print("Enter quarry depth")
    DEPTH = tonumber(read())
    print("Enter quarry width")
    WIDTH = tonumber(read())
    if WIDTH%2 == 0 then
        EVENWIDTH = true
    end
end

-- Can redo decisions in a different way
function setReturnCond()
    print("Shall I return to the original height?")
    local returnResponse = string.lower(tostring(read()))
    local acceptedConditions = {"yes","no",
                                "true","false",
                                "1","0",
                                "y","n",
                                "yeah","nah"}
    for k,v in pairs(acceptedConditions) do
        if returnResponse == v then
            if k%2==1 then
                RETURNCOND = 1
                break
            end
        end
    end 
end

function dumpItems()
    local chestIndex = findChest()
    if chestIndex ~= 0 then
        turtle.select(chestIndex)
        turtle.placeUp()
        emptyInv()
        if ECPRESENT then
            turtle.digUp()
        end
    else
        -- if there isn't a chest, ender or otherwise
        -- stop & wait until a new chest is inserted into the inventory.
        -- infinite loop but either a new chest is inserted or I'll restart it anyway so no big deal
        waitforChest()
        dumpItems()
    end
end

function waitforChest()
    local wait = true
    print("Waiting for chest to be inserted...")
    while wait do
        --Check for a new chest, ender or otherwise.
        --Infinitely loop until such conditions are met
        chestIndex = findChest()
        if chestIndex ~= 0 then
            wait = false
        end
    end
end

function emptyInv()
    -- for some reason, this only empties the chests in the inventory. too bad!
    for n = 1,16,1 do -- for all inventory cells
        if turtle.getItemCount(n) ~= 0 then -- if the item count in this cell is more than zero
            if not contains(CHESTS,turtle.getItemDetail(n)) then -- if the item in question in not a recognised chest
                turtle.dropUp()
            end
        end
    end
end

function findChest() -- loops through
    local currChest
    for k,_ in pairs(CHESTS) do
        currChest = findItemBF(CHESTS[k])
        if currChest ~= 0 then return currChest end
    end
    return 0
end

function findItemBF(ID) -- brute force finds any item passed to it, otherwise returns 0
    for n = 1,16,1 do
        if turtle.getItemCount(n) ~= 0 then
            if turtle.getItemDetail(n).name == ID then
                return n
            end
        end
    end
    return 0
end

function contains(table,element)
    for _, value in pairs(table) do
        if value == element then
          return true
        end
    end
    return false
end

function calculateFuelExpenditure() -- Consider return
    local distance = DEPTH*((WIDTH*WIDTH))

    if RETURNCOND == true then
        distance = distance + DEPTH
    end

    if turtle.getFuelLevel() > distance then
        return true
    else
        return false
    end
end

function minesquare(layer)
    local reverse
    if layer%2 == 0 and not EVENWIDTH then
        -- if the width is odd and the current layer count is even
        reverse = true
    end
    for n = 1,WIDTH,1 do

        -- The first block in a line is mined differently, as the turtle needs to move into said ine.
        if n == 1 then -- if its the first iteration, then the turtle needs to move down a layer
            turtle.digDown()
            turtle.down()
        end

        digForward(WIDTH-1) -- mine out the rest of the line

        if n < WIDTH then -- if the turtle hasn't finished this layer yet
            if reverse then
                n = n + 1 -- I hate doing it this way but it ain't broke so I won't fix it
            end
            if n%2 == 1 then -- alternate between turning right and left at the end of a line
                turtle.turnRight()
                digForward()
                turtle.turnRight()
            else
                turtle.turnLeft()
                digForward()
                turtle.turnLeft()
            end
            if reverse then
                n = n - 1
            end
        else
            if not EVENWIDTH and not reverse then
                turtle.turnLeft()
            else
                turtle.turnRight()
            end
        end
    end
end

function digForward(length)
    if length == nil then
        length = 1 -- default
    end
    for _ = 1,length,1 do
        if everySlotTaken() == true then
            print("Storage full! Dumping items...")
            dumpItems()
        end
        turtle.dig()
        turtle.forward()
    end
end

function getCoords()
    local coords = vector.new(gps.locate())
    return coords
end

function everySlotTaken()
    --Cycle through all the slots and get the inventory size

    for n = 1,16,1 do
        if turtle.getItemCount(n) == 0 then
            return false
        end
    end

    return true
end

function main()
    setDimensions()
    setReturnCond()
    for i = 1,DEPTH,1 do
        if findItemBF(EC) ~= 0 then
            ECPRESENT = true
        end
        minesquare(i)
    end

    if RETURNCOND == 1 then
        for _ = 1, DEPTH, 1 do
            turtle.up()
        end
    end
    dumpItems()
end

if findItemBF(EC) ~= 0 then
    ECPRESENT = true
end

if calculateFuelExpenditure() then
    main()
else
    if turtle.refuel() then
        if calculateFuelExpenditure() then
            main()
        else
            print("Failed refuel attempt, shutting down...")
        end
    else
        print("Not enough fuel!")
    end
end