--[[
    This project will make the turtle refuel x amount of times by wading through lava, because I'm lazy :3
]]

term.clear()
os.loadAPI('commonUtils')
LENGTH = 0


print("Welcome to the lava swim refuel program.")
os.sleep(1)
print("I will move forwards and down to begin swimming.")
os.sleep(1)
print("After finishing, I'll make my way back to you :)\n")
os.sleep(3)

term.clear()


local function setup()
    local incompleteInput = true
    while incompleteInput do
        print("How many blocks of lava shall I eat?")
        LENGTH = tonumber(read())
        if LENGTH then
            incompleteInput = false
            return
        end
        term.clear()
        print("Error! Enter a proper value please!\n")
    end
end


local function main()
    setup()

    local bucket = commonUtils.findItemBF("minecraft:bucket")
    if bucket > 0 then
        turtle.select(bucket)
    else
        term.clear()
        print("I don't have a bucket!!")
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
    end

    -- return journey
    turtle.up()
    turtle.turnLeft()
    turtle.turnLeft()
    for _ = 1,LENGTH+1,1 do
        turtle.forward()
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