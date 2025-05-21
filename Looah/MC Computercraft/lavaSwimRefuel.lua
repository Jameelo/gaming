--[[
    This project will make the turtle refuel x amount of times by wading through lava, because I'm lazy and don't want to constantly feed it coal
]]

term.clear()

os.loadAPI("common/systemLib.lua")
os.loadAPI("common/storageLib.lua")

LENGTH = 0
ODOMETER = 0

local args = {...}

print("Welcome to the lava swim refuel program.")
os.sleep(1)
print("I will move forwards and down to begin swimming.")
os.sleep(1)
print("After finishing, I'll make my way back to you :)\n")
os.sleep(3)

term.clear()

local function setup()
    if #args > 1 then
        -- if the user specified a distance in the args
        LENGTH = args[1]
    else
        local incompleteInput = true
        while incompleteInput do
            print("How many blocks of lava shall I eat?\n 0 means I will go until I'm full or hit an obstruction.")
            LENGTH = tonumber(read())
            if LENGTH then
                incompleteInput = false
                return
            end
            term.clear()
            print("Error! Enter a proper value please!\n")
        end
    end
end


local function main()
    setup()

    if LENGTH == 0 then
        LENGTH = 65535
    end

    local bucket = storageLib.findItemBF("minecraft:bucket")
    if bucket > 0 then
        turtle.select(bucket)
    else
        term.clear()
        print("I don't have a bucket!!")
        return
    end

    -- Don't waste the lava below!
    turtle.forward()
    turtle.placeDown()
    turtle.refuel()
    turtle.down()

    for _ = 1,LENGTH-1,1 do -- Fill bucket, eat bucket contents, move forward.
        turtle.place()
        turtle.refuel()
        turtle.forward()
        if LENGTH > 0 then
            ODOMETER = ODOMETER + 1
        end
    end

    -- return journey
    turtle.up()
    turtle.turnLeft()
    turtle.turnLeft()

    if LENGTH > 0 then
        for _ = 1,LENGTH,1 do
            turtle.forward()
        end
    else
        for _ = 1,ODOMETER,1 do
            turtle.forward()
        end
    end

    write("Finished with new fuel level = ")
    print(turtle.getFuelLevel())
    print("")
end


if turtle.getFuelLevel() > 2 then -- You only need 1 fuel to start refueling.
    main()
else
    print("You need some level of fuel to use this program. Please get at least 3 fuel to proceed.")
end