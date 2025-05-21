--[[
    Library focussed on moving about & mining
]]

os.loadAPI("common/storageLib.lua")

function digForward(length) -- Variable length dig forward command.
    if length == nil then
        length = 1 -- default
    end
    for _ = 1,length,1 do        
        -- keep digging until nothing remains in front of you
        repeat
            turtle.dig()
            os.sleep(0.1)
        until not turtle.detect()

        turtle.forward()
        if storageLib.everySlotTaken() == true then
            print("Storage full! Dumping items...")
            dumpItems()
        end
    end
end

function placeMoveForward(length, block) -- places the currently selected block & moves forward.
    --[[
        True - returned as length was reached
        False - returned due to lack of items
    ]]

    for _ = 1,length,1 do        
        if turtle.getItemCount() == 0 then -- if no blocks are left, reload.
            newSlot = storageLib.findItemBF(block)
            if newSlot > 0 then -- if there is another stack in the inventory
                turtle.select(newSlot) -- select another instance of the block
            else
                return false -- ran outta blocks
            end
        end

        if turtle.detect() then -- if there is an obstacle, even though there shouldn't be.
            turtle.dig() -- This opens up the possibility of filling the inventory I guess? Not an issue atm.
        end

        if not turtle.detectDown() then
            turtle.placeDown()
        end
        turtle.forward()
    end

    return true
end