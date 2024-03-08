--[[
    Idea is the same as the last quarry program, except this one can save & resume progress, and handles rectangular quarries.
    Digs an WIDTH by LENGTH hole, DEPTH blocks deep; specified by the input. Input can also be an argument
    Calculates fuel expenditure
    Recognises a full inventory & dumps excess into ender chest
    TODO:
    - Maybe fix the single restriction:
        - Length must be more than 1
    - Make it robust to server shutdowns, allowing it to resume (meybe automatically if possible)
        - Can do this by storing row & column values
        - Write counters to file, but only access them if the program resumes

    - SAVING:
        - have a save file that stores the block number the robot is currently on
        - Store in a table:
            - LENGTH
            - WIDTH
            - DEPTH
            - block
            - layer
            - upwards
            - returncond
        - Have a save function that saves on every block broken and every layer dropped.
        - Have a resume argument!
        - Also prompt user that a save file exists, cuz it should get deleted after loading (and at the end of the program)
        - Find a way to make it restart automatically. Maybe by editing startup?
]]

os.loadAPI("commonUtils.lua")
running = true

local args = {...}

-- Quarry progress save file ID
QSAVEPATH = "common/QPROG"

-- Forward and perpendicular widths
forwardAxis = 0
perpendicularAxis = 0

local function getInputInt(inputName,restriction)
    local illegalInput = true
    if restriction == nil then
        restriction = 0
    end
    while illegalInput do
        print(string.format("How %s should the quarry be?",inputName))
        input = tonumber(read())
        if input ~= nil and input > restriction then
            illegalInput = false
        else
            term.clear()
            print(string.format("%s must be an integer larger than %i"),inputName,restriction)
        end
    end
    return input
end

local function quarrySetup()
    -- Assume the turtle is facing the same direction as user

    -- Width (Left)
    WIDTH = getInputInt("Wide")
    QSAVE["width"] = WIDTH

    -- Length (Forwards)
    LENGTH = getInputInt("Long",1)
    QSAVE["length"] = LENGTH

    -- Depth (Up/Down)
    DEPTH = getInputInt("Deep")
    QSAVE["depth"] = DEPTH

    commonUtils.saveFile(QSAVE,QSAVEPATH)
end

-- I should really make a binary choice function in commonutils

local function upDownReturn() -- determine direction and return choice
    -- Up or down?
    print("Shall I go up, or down?")
    local directionChoice = string.lower(tostring((read())))
    local acceptedResponses = {"up","down",
                                "u","d"}
    for index,value in pairs(acceptedResponses) do -- find out what they said
        if directionChoice == value then
            if index%2==1 then
                UPWARDS = true
            else
                UPWARDS = false
            end
        end
    end
    QSAVE["upwards"] = UPWARDS

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
            else
                RETURNCOND = 0
            end
        end
    end
    QSAVE["return"] = RETURNCOND

    commonUtils.saveFile(QSAVE,QSAVEPATH)
end

local function calculateFuelExpenditure() -- Calculate how much fuel will be taken from the quarry volume. Need to add extra return fuel bits too

    local distance = DEPTH*WIDTH*LENGTH -- minimum distance travelled is the volume of the cube to mine out

    if RETURNCOND == true then
        distance = distance + DEPTH
        if math.fmod(WIDTH,2) == 1 then
            -- ODD width, ANY length
            if math.fmod(DEPTH,2) == 1 then
                distance = distance + LENGTH + WIDTH - 2
            end
        elseif math.fmod(LENGTH,2) == 1 then
            if math.fmod(DEPTH,2) == 1 then
                distance = distance + WIDTH - 1
            else
                distance = distance + LENGTH - 1
            end
        else
            -- EVEN width, EVEN length
            if math.fmod(DEPTH,4) == 1 then
                distance = distance + WIDTH - 1
            elseif math.fmod(DEPTH,4) == 2 then
                distance = distance + LENGTH + WIDTH - 2
            elseif math.fmod(DEPTH,4) == 3 then
                distance = distance + LENGTH - 1
            end
        end
    end

    if turtle.getFuelLevel() > distance then
        return true
    else
        return false
    end
end

local function mineLayer(layer,resumeBlock) -- Mines a layer of blocks LENGTH forwards & WIDTH to the right
    -- Odometer method.

    if resumeBlock == nil then
        startBlock = 2
    else
        startBlock = resumeBlock
    end

    -- DON'T LOOK
    -- I need to fix this fucking thing, it runs so much unnecessary code each loop
    if math.fmod(WIDTH,2) == 1 then
        -- if the width is odd
        forwardAxis = LENGTH
        perpendicularAxis = WIDTH
    else
        -- if the width is even
        if math.fmod(LENGTH,2) == 1 then -- if the length is odd
            forwardAxis = WIDTH
            perpendicularAxis = LENGTH
            if layer == 1 then
                forwardAxis = LENGTH
                perpendicularAxis = WIDTH
            end
        else -- if the length is even
            if math.fmod(layer,2) == 0 then
                forwardAxis = WIDTH
                perpendicularAxis = LENGTH
            else
                forwardAxis = LENGTH
                perpendicularAxis = WIDTH
            end
        end
    end

    turtle.digDown()
    turtle.down()

    for block = startBlock,WIDTH*LENGTH,1 do
        -- On every multiple + 1, turn around
        if math.fmod(block,forwardAxis) ~= 1 then
            commonUtils.digForward()
        else
            local goingLeft = false
            -- if odd multiple of LENGTH, turn right. else left.
            if math.fmod((block-1)/forwardAxis,2) == 0 then
                goingLeft = true
            end

            if goingLeft then
                turtle.turnLeft()
                commonUtils.digForward()
                turtle.turnLeft()
            else
                turtle.turnRight()
                commonUtils.digForward()
                turtle.turnRight()
            end
        end
    end

    if math.fmod(perpendicularAxis,2) == 1 then
        turtle.turnLeft()
        turtle.turnLeft()
    else
        turtle.turnRight()
    end
end

function returnToStart()
    -- Returns below the same spot it started in, then moves upwards.

    if math.fmod(WIDTH,2) == 1 then
        -- ODD width, ANY length
        if math.fmod(DEPTH,2) == 1 then
            commonUtils.digForward(LENGTH-1)
            turtle.turnRight()
            commonUtils.digForward(WIDTH-1)
            turtle.turnRight()
        end
    elseif math.fmod(LENGTH,2) == 1 then
        -- EVEN width, ODD length
        if math.fmod(DEPTH,2) == 1 then
            commonUtils.digForward(WIDTH-1)
            turtle.turnRight()
        else
            turtle.turnRight()
            commonUtils.digForward(LENGTH-1)
            turtle.turnRight()
            turtle.turnRight()
        end
    else
        -- EVEN width, EVEN length
        if math.fmod(DEPTH,4) == 1 then
            commonUtils.digForward(WIDTH-1)
            turtle.turnRight()
        elseif math.fmod(DEPTH,4) == 2 then
            commonUtils.digForward(LENGTH-1)
            turtle.turnRight()
            commonUtils.digForward(WIDTH-1)
            turtle.turnRight()
        elseif math.fmod(DEPTH,4) == 3 then
            turtle.turnRight()
            commonUtils.digForward(LENGTH-1)
            turtle.turnRight()
            turtle.turnRight()
        end
    end

    for _ = 1,DEPTH,1 do
        turtle.up()
    end
end

local function main()

    if QSAVE == nil then
        -- Initiate this with the current dimensions given! This will be the first write of the file, current layer and block are both zero here
        QSAVE = {"width"; 0,"length"; 0, "depth"; 0, "currentLayer"; 0, "currentBlock"; 0, "upwards"; false, "return"; 0} -- In order: width, length, depth, current layer, current block, upwards, returncond
        startIndex = 1
        stBlock = nil
    else
        -- This is just to hold my note rn, maybe the for loop below doesn't
        -- change startIndex & startBlock here
        startIndex = QSAVE["currentLayer"]
        stBlock = QSAVE["currentBlock"]
    end

    term.clear()

    for i = startIndex,DEPTH,1 do
        QSAVE["currentLayer"] = i
        mineLayer(i,stBlock)
        if stBlock ~= nil then
            stBlock = nil
        end
    end

    shell.run(string.format("delete %s",QSAVEPATH))

    if RETURNCOND == 1 then
        returnToStart()
    end

    commonUtils.dumpItems()
    write("Execution complete, fuel remaining: ")
    print(turtle.getFuelLevel())
    running = false
end

-- Save file declaration
if fs.exists(QSAVEPATH) then
    -- UPWARDS AND RETURNCOND TOO!! 
    QSAVE = commonUtils.loadFile(QSAVEPATH)
    WIDTH  = QSAVE["width"]
    LENGTH = QSAVE["length"]
    DEPTH  = QSAVE["depth"]

    UPWARDS = QSAVE["upwards"]
    RETURNCOND = QSAVE["return"]

    main()
else
    QSAVE = nil -- to be declared later
    commonUtils.saveFile(QSAVE,QSAVEPATH)
end

if running then
    if #args == 3 then
        WIDTH = args[1]
        QSAVE["width"] = WIDTH
        LENGTH = args[2]
        QSAVE["length"] = LENGTH
        DEPTH = args[3]
        QSAVE["depth"] = DEPTH
    elseif #args > 0 then
        print("If you want to use arguments with this program, use the following three:")
        print("Width, Length then Depth.")
        quarrySetup()
    else
        quarrySetup()
    end

    upDownReturn()

    if calculateFuelExpenditure() == true then -- I know about the '== true' but it doesn't work otherwise so shut up
        main()
    else
        if commonUtils.refuelChestSafe() == true then
            if calculateFuelExpenditure() == true then
                main()
            else
                print("Refuel attempt insufficient, shutting down...")
            end
        else
            print("Failed refuel attempt, shutting down...")
        end
    end
end