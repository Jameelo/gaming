--[[
    This will make a rectangular platform, spanning forwards and right.
]]

term.clear()
os.loadAPI("commonUtils.lua")

LENGTH = 0
WIDTH = 0
BLOCK_ID = ""

-- This table holds a block's name as the key, and its actual block ID as the value.
BLOCKS_AVAILABLE = {
    ["cobblestone"] = "minecraft:cobblestone",
    ["granite"] = "minecraft:granite",
    ["diorite"] = "minecraft:diorite",
    ["andesite"] = "minecraft:andesite",
    ["dirt"] = "minecraft:dirt",
    ["oak planks"] = "minecraft:oak_planks",
    ["spruce planks"] = "minecraft:spruce_planks",
    ["netherrack"] = "minecraft:netherrack",
    ["netherack"] = "minecraft:netherrack"
}

print("Welcome to platform maker!")

local function setParams() -- Sets width and length of platform
    print("Platform length (forwards): ")
    LENGTH = tonumber(read())

    print("Platform width (to the right): ")
    WIDTH = tonumber(read())

    BLOCK_COUNT = LENGTH * WIDTH

    print("What type of block should I use to build this platform?")
    local chosenBlock = string.lower(tostring(read()))

    BLOCK_ID = commonUtils.dictLookup(BLOCKS_AVAILABLE,chosenBlock) -- Get the block ID from the blocks available dictionary using the user input
    if BLOCK_ID then -- If the user entered a valid block
        return true
    end
    return false
end

local function verifyPossible() -- Check if the turtle has enough blocks to make the platform & enough fuel.
    -- Returns:
    -- false if the platform cannot be made
    -- true if it can

    -- Fuel expenditure is equal to block count
    if turtle.getFuelLevel() < BLOCK_COUNT then -- if there isn't enough fuel
        return false
    end
    -- First, get a count of all blocks in the inventory that match the specified type.
    local totalCount = 0

    for n = 1,16,1 do
        local detail = turtle.getItemDetail(n)
        if detail ~= nil and detail.name == BLOCK_ID then
            totalCount = totalCount + detail.count -- add the number of the correct block to the counting variable
        end
    end

    if totalCount < BLOCK_COUNT then -- if there aren't enough blocks
        return false
    end

    return true
end

function main()
    print("Beginning platforming.")

    turtle.select(commonUtils.findItemBF(BLOCK_ID)) -- select item
    turtle.forward()

    for row = 1,WIDTH,1 do
        if commonUtils.placeMoveForward(LENGTH-1, BLOCK_ID) == false then -- if the function returns false
            return false
        end
        if row%2 == 1 and row ~= WIDTH then            
            turtle.turnRight()
            if commonUtils.placeMoveForward(1, BLOCK_ID) == false then -- if the function returns false
                return false
            end
            turtle.turnRight()
        else            
            turtle.turnLeft()
            if commonUtils.placeMoveForward(1, BLOCK_ID) == false then -- if the function returns false
                return false
            end
            turtle.turnLeft()
        end
    end
    return true
end

if setParams() then
    if verifyPossible() then
        if main() then
            print("Excecution ended successfully.")
        else
            print("Critical error, exiting program...")
        end
    else
        print("Not enough fuel or blocks")
    end
else
    print("There was an error entering the block ID.")
end