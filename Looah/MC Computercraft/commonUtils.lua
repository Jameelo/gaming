--[[
    This file will be an API that holds general-purpose funcitons cuz I don't wanna have to re-write them across programs.
    TO ADD:
    - emptyinv
    - findItemBF
    - findChest
    - contains
    - digForward
    - everySlotTaken

    to include these function in a program, type:
    os.loadAPI("myApiFile")
    myApiFile.functionName()
]]

CHESTS = {"enderstorage:ender_chest", "minecraft:ender_chest", "minecraft:chest"}
ECHESTS = {CHESTS[1],CHESTS[2]}

function dumpItems() -- Need to make this more robust for when a chest cannot be placed above.
    local chestIndex = findChest()
    if chestIndex ~= 0 then
        turtle.select(chestIndex)
        turtle.placeUp()
        emptyInv()
        if ECPRESENT then
            turtle.digUp()
        end
    else
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
        dumpItems()
    end
end

function emptyInvG()
    -- for some reason, this only empties the chests in the inventory. too bad!
    for n = 1,16,1 do -- for all inventory cells
        if turtle.getItemCount(n) ~= 0 then -- if the item count in this cell is more than zero
            turtle.dropUp()
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