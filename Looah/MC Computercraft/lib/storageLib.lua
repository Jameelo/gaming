--[[
    This library deals with interacting with inventories, both internal and external
]]

os.loadAPI("common/systemLib.lua")

CHESTS = {"minecraft:chest", "minecraft:barrel", "minecraft:trapped_chest", "aether:treasure_chest", "twilightforest:twilight_oak_chest",
          "twilightforest:canopy_chest", "twilightforest:mangrove_chest", "twilightforest:dark_chest", "twilightforest:time_chest", "twilightforest:transformation_chest",
          "twilightforest:mining_chest", "twilightforest:sorting_chest"}
ECHESTS = {"enderstorage:ender_chest", "minecraft:ender_chest", "enderchests:ender_chest"}

ALLCHESTS = {table.unpack(CHESTS), table.unpack(ECHESTS)}

function emptyInv(direction, EChestPlaced) -- Dump everything except chests.
    local directions = {up    = turtle.dropUp,
                        down  = turtle.dropDown,
                        front = turtle.drop}
    local drop = true

    for n = 1,16,1 do -- for all inventory cells
        if turtle.getItemCount(n) ~= 0 then -- if the item count in this cell is more than zero
            if systemLib.contains(CHESTS,turtle.getItemDetail(n).name) and not EChestPlaced then -- If the item is a chest, don't dump it unless we've placed an echest
                drop = false
            end
            if drop then
                turtle.select(n)
                directions[direction]()
            end
        end
        drop = true
    end
end

function dumpItems() -- Empty the inventory, prioritising ender chest usage
    local chestIndex = findChest(ECHESTS) -- Get the index of the ender chest in the inventory, if it exists.
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
            emptyInv("up",eChest)
            if eChest then
                turtle.digUp()
            end
            return
        else
            -- If you cannot place the chest above you
            for _ = 1,4,1 do
                turtle.turnLeft()
                leftCount = leftCount + 1
                if not turtle.detect() then
                    -- Can place the chest in this direction
                    turtle.place()
                    emptyInv("front",eChest)
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

function findChest(chestArray) -- loops through
    local currChest
    for _,chestID in pairs(chestArray) do
        currChest = findItemBF(chestID)
        if currChest > 0 then
            return currChest
        end
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
            if not systemLib.contains(CHESTS,turtle.getItemDetail(index).name) then
                isRefueled = turtle.refuel() -- Om nom nom
            end
        end
    end
    return isRefueled
end

function calculateFuelPresent() -- Based on the amount of burnables in the inventory, multiplied by their burn time (Will I need to make a dict for this?)
    local fuelCount = 0
    for slot in 1,16,1 do
        turtle.select(slot)
        if turtle.refuel(0) then
            -- If we're looking at something burnable right now, calculate how much fuel it can get us by burning one of it (if there's only on in the stack, womp womp)
            d0 = turtle.getFuelLevel()
            turtle.refuel(1)
            fuelDelta = d0 - turtle.getFuelLevel()
            fuelcount = fuelcount + fuelDelta*turtle.getItemCount(slot)
        end
    end
    return fuelCount
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