--[[
    Not much wbu
    Same as my normal quarry code but it digs up
]]

print("Enter quarry depth")
DEPTH = string.lower(tostring(read()))

print("Enter quarry width")
WIDTH = string.lower(tostring(read()))

print("Shall I return to the original height?")
returnResponse = string.lower(tostring(read()))

acceptedConditions = {"yes","no","true","false","1","0","y","n"}
RETURNCOND = 0

for k,v in pairs(acceptedConditions) do
    if returnResponse == v then
        if k%2==1 then
            RETURNCOND = 1
            break
        else
            RETURNCOND = 0
        end
    end
end

function dumpItems()
    eSlot = findEChest()
    if eSlot ~= false then
        turtle.refuel()
        turtle.select(eSlot)
        turtle.placeDown()
        emptyInv()
        turtle.digDown()   
    else
        print("No E-Chest detected, skill issue")  
    end
end

function emptyInv()
    for n = 1,16,1 do
        turtle.select(n)
        if turtle.getItemCount(n) ~= 0 then
            turtle.dropDown()
        end        
    end
end

function findEChest()
    for n = 1,16,1 do
        if turtle.getItemCount(n) ~= 0 then
            if turtle.getItemDetail(n).name == "enderstorage:ender_chest" then
                return n
            end
        end
    end
    return false
end

function existsTable(tableIn, element)
    for _, value in pairs(tableIn) do
      if value == element then
        return true
      end
    end
    return false
end

function calculateFuelExpenditure()
    local distance
    if WIDTH%2 == 0 then
        distance = DEPTH*((WIDTH*WIDTH)+(WIDTH-1)) + DEPTH
    else
        distance = DEPTH*((WIDTH*WIDTH)+2*(WIDTH-1)) + DEPTH
    end
    if turtle.getFuelLevel() > distance then
        return true
    else
        return false
    end
end

function minesquare() --assumes the square is untouched and level
    turtle.digUp()
    turtle.up()

    if WIDTH%2 == 0 then
        for count = 1,WIDTH/2,1 do
            digForward(WIDTH-1)
            turtle.turnRight()
            digForward()
            turtle.turnRight()
            digForward(WIDTH-1)
            if count == WIDTH/2 then
                turtle.turnRight()
                digForward(WIDTH-1)
                turtle.turnRight()
                break
            end
            turtle.turnLeft()
            digForward()
            turtle.turnLeft()
        end
    else
        for count = 1,math.floor(WIDTH/2),1 do
            digForward(WIDTH-1)
            turtle.turnRight()
            digForward()
            turtle.turnRight()
            digForward(WIDTH-1)
            if count == math.floor(WIDTH/2) then
                turtle.turnLeft()
                digForward()
                turtle.turnLeft()
                digForward(WIDTH-1)
                turtle.turnLeft()
                digForward(WIDTH-1)
                turtle.turnLeft()
                digForward(WIDTH-1)
                turtle.turnLeft()
                turtle.turnLeft()
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
            print("Storage full")
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
    local takenSlots = 0

    for n = 1,16,1 do
        if turtle.getItemCount(n) > 0 then
            takenSlots = takenSlots + 1
        end
    end
    if takenSlots == 16 then
        return true
    else
        return false
    end
end

function main()
    for count = 1,DEPTH,1 do
        minesquare()
    end

    if RETURNCOND == 1 then
        for i = 1, DEPTH, 1 do
            turtle.down()
        end
    end
    dumpItems()
end

if calculateFuelExpenditure() then
    main()
else
    if turtle.refuel() then
        if calculateFuelExpenditure() then
            main()
        else
            print("Failed refuel attempt, skill issue ig")
        end
    else
        print("Not enough fuel!")
    end
end