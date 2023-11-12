--[[
    Quarry code for a turtle
    Digs an WIDTH by WIDTH hole, DEPTH blocks deep; specified by the input
    Calculates fuel efficiency
    Recognises a full inventory & dumps excess into ender chest
    TODO:
    - Move setup into a single function, maybe even allow values to be passed in before runtime as an option?
    - Make code support rectangular paths
    - Change the way it calculates a full inventory, as currently it slows down mining a lot
    - Add a refuel program that doesn't burn chests??
]]

os.loadAPI("commonUtils")

RETURNCOND = 0
DEPTH = 0
WIDTH = 0
ECPRESENT = false

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

    local reverse,right

    if layer%2 == 0 and not EVENWIDTH then
        -- if the width is odd and the current layer count is even
        reverse = true
    end

    for n = 1,WIDTH,1 do -- Theoretically should be easy to make rectuangular
        -- The first block in a line is mined differently, as the turtle needs to move into said ine.
        if n == 1 then -- if its the first iteration, then the turtle needs to move down a layer
            turtle.digDown()
            turtle.down()
        end
        commonUtils.digForward(WIDTH-1) -- mine out the rest of the line
        if n < WIDTH then -- if the turtle hasn't finished this layer yet
            -- There was a huge bug with odd width quarries, so I'm trying out a boolean "am I turning right or left" value
            if reverse then
                right = false
            else
                right = true
            end
            if n%2 == 0 then
                right = not right
            end
            if right then -- alternate between turning right and left at the end of a line
                turtle.turnRight()
                commonUtils.digForward()
                turtle.turnRight()
            else
                turtle.turnLeft()
                commonUtils.digForward()
                turtle.turnLeft()
            end
            if reverse then
                right = not right
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

function main()
    setDimensions()
    setReturnCond()
    for i = 1,DEPTH,1 do
        minesquare(i)
    end

    if RETURNCOND == 1 then
        for _ = 1, DEPTH, 1 do
            turtle.up()
        end
    end
    commonUtils.dumpItems()
end

if calculateFuelExpenditure() == true then
    main()
else
    if commonUtils.refuelChestSafe() then
        if calculateFuelExpenditure() == true then
            main()
        else
            print("Failed refuel attempt, shutting down...")
        end
    else
        print("Not enough fuel!")
    end
end