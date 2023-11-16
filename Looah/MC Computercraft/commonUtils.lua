--[[
    This file will be an API that holds general-purpose funcitons cuz I don't wanna have to re-write them across programs.

    to include these function in a program, type:
    os.loadAPI("myApiFile")
    myApiFile.functionName()
]]

CHESTS = {"enderstorage:ender_chest", "minecraft:ender_chest", "minecraft:chest"}
ECHESTS = {}
ECHESTMAX = 2 -- chests in CHESTS up to and including index 2 are all ender chests, anything after are regular chests.

for n = 1,ECHESTMAX,1 do -- make list of ender chests.
    table.insert(ECHESTS, CHESTS[n])
end


function apiExists(path) -- Check if an API is real or not
    if os.loadAPI(path) ~= false then
        return true
    end
    return false
end

function dumpItems() -- Need to make this more robust for when a chest cannot be placed above.
    -- Prioritise Ender chests obvs
    local chestIndex = findChest(ECHESTS)
    local eChest = false
    local leftCount = 0

    if chestIndex > 0 then -- Echest Present
        eChest = true
    else
        chestIndex = findChest(CHESTS)
    end

    -- Direction determination
    if chestIndex > 0 then
        turtle.select(chestIndex)
        if not turtle.detectUp() then
            -- We can place the chest above us
            turtle.placeUp()
            emptyInv("up",true)
            if eChest then
                turtle.digUp()
            end
            return
        else
            -- If you cannot place the chest above you
            for _ = 1,3,1 do
                turtle.turnLeft()
                leftCount = leftCount + 1
                if not turtle.detect() then
                    -- Can place the chest in this direction
                    turtle.place()
                    emptyInv("front",true)
                    if eChest then
                        turtle.dig()
                    end
                    for _ = 1,leftCount,1 do
                        turtle.turnRight()
                    end
                    return
                end
            end
            shell.run("os.shutdown()")
        end
    else
        -- If there are no chests whatsoever
        printError("No chests available!",0)
    end
end

function emptyInv(direction, EXCLUDE_CHEST) -- Empty all BUT chests.
    local directions = {   up = turtle.dropUp,
                         down = turtle.dropDown,
                        front = turtle.drop}
    for n = 1,16,1 do -- for all inventory cells
        local drop = true
        turtle.select(n)
        if turtle.getItemCount(n) ~= 0 then -- if the item count in this cell is more than zero
            if EXCLUDE_CHEST == true and contains(CHESTS,turtle.getItemDetail(n)) == true then -- If we want to ignore chests, and the item is a chest (also why do I need == true here???)
                drop = false
            end
            if drop then
                if directions[direction] then
                    directions[direction]()
                end
            end
        end
    end
end

function findChest(chestArray) -- loops through
    local currChest
    for k,_ in pairs(chestArray) do
        currChest = findItemBF(chestArray[k])
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

function refuelChestSafe() -- Refuel without comsuming any chests
    local isRefueled
    for index = 1,16,1 do
        turtle.select(index)
        local isFuel, _ = turtle.refuel(0) -- See if there's any fuel in this slot
        if isFuel then
            if not contains(CHESTS,turtle.getItemDetail(index)) then
                isRefueled = turtle.refuel() -- Om nom nom
            end
        end
    end
    return isRefueled
end

function contains(table,element) -- Check to see if element is in table
    for _, value in pairs(table) do
        if value == element then
          return true
        end
    end
    return false
end

function digForward(length) -- Variable length dig forward command.
    if length == nil then
        length = 1 -- default
    end
    for _ = 1,length,1 do
        turtle.dig()
        turtle.forward()
        if everySlotTaken() == true then
            print("Storage full! Dumping items...")
            dumpItems()
        end        
    end
end

function everySlotTaken()
    --Cycle through all the slots and get the inventory size, if every cell has at least 1 item in it then there's no space left for new items
    for n = 1,16,1 do
        if turtle.getItemCount(n) == 0 then
            return false
        end
    end
    return true
end

function dictLookup(dict,item) -- Checks to see if item is a key in dict, and return its value
    for k,v in pairs(dict) do
        if k == item then
            return v
        end
    end
    return false
end

function placeMoveForward(length, block) -- places the currently selected block & moves forward.
    --[[
        Returns:
        True - returned as length was reached
        False - returned due to lack of items
    ]]

    for _ = 1,length,1 do        
        if turtle.getItemCount() == 0 then -- if no blocks are left, reload.
            newSlot = findItemBF(block)
            if newSlot > 0 then -- if there is another stack in the inventory
                turtle.select(newSlot) -- select another instance of the block
            else
                return false -- ran outta blocks
            end
        end

        if turtle.detect() then -- if there is an obstacle, even though there shouldn't be.
            turtle.dig() -- This opens up the possibility of filling the inventory I guess? Not an issue atm.
        end

        if turtle.detectDown() then
            turtle.forward()
        else
            turtle.placeDown()
            turtle.forward()
        end
    end

    return true
end