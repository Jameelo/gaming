--[[
    This code will make a turtle dig a downwards staircase with enough headroom to place a staircase in.
    The algorithm I made is periodic repeating at T=2, so a half period will need to be executed for odd values of depth.
    Fuel efficient but I wouldn't say it's code efficient.
]]

ODD_DEPTH = false

local function initialize()
    print("Enter staircase depth, minimum value 5.")
    DEPTH = tonumber(read())

    while DEPTH < 5 do
        print("Invalid input! The depth must be at least 5.")
        DEPTH = tonumber(read())
    end

    if DEPTH%2 == 1 then
        ODD_DEPTH = true
    end

    return true
end

local function calculateFuelExpenditure()
    local startEXP = 5 -- Amount of fuel needed to reach the periodic mining pattern from start
    local loopsEXP = 6 -- Amount of fuel needed to mine 2 steps in the staircase.

    local totalConsumption = startEXP

    for i = 1,math.floor(DEPTH/2),1 do -- math floor in case DEPTH is odd
        totalConsumption = totalConsumption + loopsEXP
    end

    if ODD_DEPTH then
        totalConsumption = totalConsumption + loopsEXP/2 --Gotta mine out that awkward half period
    end

    if totalConsumption < turtle.getFuelLevel() then -- If there's enough fuel
        return true
    end

    return false
end

local function beginStairs() -- Mine out the starting pattern
    -- This code is to run at the start of the mining sequence, to reach a point where the periodic mining pattern can begin.

    -- Mine the initial block
    turtle.digDown()
    turtle.down()

    -- Next stage is a 2x3 area
    for _ = 1,3,1 do
        turtle.dig()
        turtle.forward()
        turtle.digDown()
    end

    -- Move into position to begin periodic staircase mining
    turtle.down()
end

local function twoStairs() -- Mine two stair layers
    -- This funciton mines out the actual stairs and ends at a known position
    -- This algorithm isn't exactly efficient or clean. But it works!
    turtle.digDown()    -- 1
    turtle.down()
    turtle.turnLeft()   -- turning around
    turtle.turnLeft()
    turtle.dig()        -- 2
    turtle.digDown()    -- 3
    turtle.turnLeft()
    turtle.turnLeft()
    turtle.dig()        -- 4
    turtle.forward()
    turtle.dig()        -- 5
    turtle.digDown()    -- 6
    turtle.digUp()      -- 7
    turtle.up()
    turtle.digUp()      -- 8
    turtle.dig()        -- 9
    turtle.forward()
    turtle.down()
    turtle.digDown()    -- and 10!
    turtle.down()
end

local function finalStep()
    turtle.up()
    turtle.dig()        -- 1
    turtle.down()
    turtle.dig()        -- 2
    turtle.digDown()    -- 3
    turtle.down()
    turtle.dig()
    turtle.turnLeft()
    turtle.turnLeft()
    turtle.dig()
    turtle.turnLeft()
    turtle.turnLeft()
end

local function mineStairs()
    beginStairs()

    for _ = 1,math.floor((DEPTH-2)/2),1 do -- as this funciton mines two layers, only need to call it n/2 times.
        twoStairs()
    end

    if ODD_DEPTH then
        finalStep()
    end
end

local function main()
    if calculateFuelExpenditure() == true then
        mineStairs()
    else
        print("Not enough fuel.")
    end
end

if initialize() then
    main()
end

print("Runtime finished, exiting program")