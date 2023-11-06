--[[
    Quarry code for a turtle
    Digs an WIDTH by WIDTH hole, DEPTH blocks deep; specified by the input
    Calculates fuel efficiency
    Recognises a full inventory & dumps excess into ender chest
    TODO:
    - Move setup into a single function
    - Make code support rectangular paths
    - Change the way it calculates a full inventory, as currently it slows down mining a lot
]]

RETURNCOND = 0
DEPTH = 0
WIDTH = 0
ECPRESENT = false
CHESTS = {"enderstorage:ender_chest", "minecraft:chest"} -- Just for future changes in case I wanna accept a bunch of different chests.
EC = CHESTS[1] -- Enderstorage Ender chest ID
VC = CHESTS[2] -- Vanilla Chest ID

function setDimensions()
    print("Enter quarry depth")
    DEPTH = string.lower(tostring(read()))

    print("Enter quarry width")
    WIDTH = string.lower(tostring(read()))
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
    local chestIndex = 0
    if ECPRESENT then -- if there is an ender chest detected in the inventory
        chestIndex = findItemBF(EC)
    else
        -- Else, ssume there is a regular chest in the inventory, and search for it
        chestIndex = findItemBF(VC)
    end
    if chestIndex ~= 0 then
        turtle.select(chestIndex)
        turtle.placeUp()
        emptyInv() -- easy as (IT EMPTIES CHESTS TOO DIPSHIT)
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
        chestIndex = findItemBF(VC) + findItemBF(EC) -- sum is zero if there are no chests that fit the bill
        if chestIndex ~= 0 then
            wait = false
        end
    end
end

function emptyInv()
    for n = 1,16,1 do
        if turtle.getItemCount(n) then -- if the item count is more than zero
            if contains(CHESTS,turtle.getItemDetail(n)) == false then -- if the item is not a recognised chest
                turtle.dropUp()
            end
        end
    end
end

function findItemBF(ID)
    -- finds any item passed to it, otherwise returns 0
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

function minesquare() --Can redo this, move WIDTH blocks and just toggle moving left & right
    --THE SPIRAL ALGORITHM!!

    -- dig down to square layer height
    turtle.digDown()
    turtle.down()

    local halfWidth = math.floor(WIDTH/2) -- floor function used in case of an odd width

    if EVENWIDTH == true then
        for count = 1,halfWidth,1 do
            digForward(WIDTH-1)
            turtle.turnRight()
            digForward()
            turtle.turnRight()
            digForward(WIDTH-1)
            if count == halfWidth then
                turtle.turnRight()
                break
            end
            turtle.turnLeft()
            digForward()
            turtle.turnLeft()
        end
    else        
        for count = 1,halfWidth,1 do
            digForward(WIDTH-1)
            turtle.turnRight()
            digForward()
            turtle.turnRight()
            digForward(WIDTH-1)
            if count == halfWidth then
                turtle.turnLeft()
                digForward()
                turtle.turnLeft()
                digForward(WIDTH-1)
                turtle.turnLeft()
                turtle.turnLeft() --2 left turns due to the odd width, the turtle needs to be in the bottom left of the square in the algorithm. redo this.
                break
            end
            turtle.turnLeft()
            digForward()
            turtle.turnLeft()
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
    for _ = 1,DEPTH,1 do
        if findItemBF(EC) ~= 0 then
            ECPRESENT = true
        end
        minesquare()
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