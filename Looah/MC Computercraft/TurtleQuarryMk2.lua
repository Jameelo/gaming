--[[
This will be the version of the turtle quarry that renders out it's entire toolpath before it begins mining the specified quarry
Most of the logic will need to be rewritten, hence me starting a whole new file.
Basic functionality will be:
    - The code will LOOK the exact same to the user, as the quarry dimension specification screen shouldn't need changing, same with the arguments
    - This version will generate a text file with the FULL instruction set for the lil guy to follow
        - Separate instruction set files for unique layer paths, which depends on the dimension of the quarry
        - Master instruction file tells the turtle what to do between layers
        - Progress will be tracked with a multidimensional counter tracking progress on the master file and any subsfiles.
]]

-- Load APIs

os.loadAPI("common/systemLib.lua")
os.loadAPI("common/storageLib.lua")
os.loadAPI("common/mineLib.lua")


-- Declare important variables

INSTRUCTIONS = {
    forwards = turtle.forward, -- placeholder :3
}

EXIT_CODES = {
    [0] = "Exited program normally",
}

local runtimeConfig = {}
local toolPath = {} -- Empty toolpath to be written to & decoded
-- The toolpath should be a 2d array
    -- Key = instruction number
    -- Value = table containing the instruction & an excecuted boolean


-- RECOGNISED CHESTS SHOULD INCLUDE BARRELS!!
-- ALSO MAKE IT GRAVEL SAFE
-- Return to same chest at spawn/start (option)
-- Optional calculateFuelExpenditure
    -- I don't have enough fuel, shall I go anyway?
-- When resuming, call the quarry code EXTERNALLY WITH THE SAVED DATA
-- Progress bar


-- What instructions are used?
    -- Forward, turn left/right, dig, digdown, digup
-- Meta-instructions
    -- Digline
-- Diglayer

local function generate_toolpath(dimensions)
    --[[
        Generate toolpath instruction set & save to file.
        dimensions - object holding the length, width and depth values of the quarry
    ]]
    -- using the provided 3d dimensions, generate a predefined set of instructions to perform the quarry & save file
    -- (0,0,0) based around point at time t=0, x = fwd/bwd, y = rgt/lft & z = dnw/upw
end

local function intruction_decoder(toolPathFile)
    -- load toolpath file
    -- read action & decode to excecution
    -- constantly write current progress to save (same?separate?) file to make it power safe
end

local function calculate_fuel_cost(quarry_data)
    --[[
        This will just be the length of the toolset, ideally
        Or can register instructions in the toolset as "Fuel-consuming": True
        And then count only the elements whit this property
    ]]
    local volume = quarry_data["x"] * quarry_data["y"] * quarry_data["z"]
    local fuel_cost = volume
    -- Add fuel for return path here, if specified
    if quarry_data["return_condition"] then
        volume = volume + quarry_data["z"]
        -- TODO: Finalise the logic going into this when appropriate <3
    end
    return fuel_cost
end



local function sufficient_fuel(quarry_data)
    fuel_after_quarry = turtle.getFuelLevel() - calculate_fuel_cost(quarry_data)
    if fuel_after_quarry >= 0 then
        -- Turtle has enough fuel to mine this quarry
        return true
    elseif fuel_after_quarry + calculateFuelPresent() >= 0 then
        -- Turtle has enough fuel if it uses the shit in its inventory
        -- refuel using all slots
        return true
    end
    return false
end

local function get_quarry_data()
    -- Prompts user or load file if it exists, to get input data
    local default_quarry_data = {
        ["width"] = 5,
        ["length"] = 5,
        ["depth"] = 5,
        ["return_condition"] = false,
        ["going_down"] = true
    }
    -- Check if the non-vol file exists, otherwise take user input?
    return default_quarry_data
end

local function start_quarry(quarry_data)
    -- Extract dimensions 
    if sufficient_fuel(quarry_data) then
        -- We can go!
    else
        -- The user should be able to tell the turtle to mine until it runs out of fuel
        print("Not enough fuel to do that, shall I look out for fuel while I'm mining and go anyway? :)")
        RAISE_ERROR("No fuel", false, nil)
        return 1
    end
end

function RAISE_ERROR(reason, action_required, action)
    print(reason)
    if shutdown_required then
        action()
    end
end

function MAIN()
    -- This will handle each stage of the program excecution
    local input_data = get_quarry_data()
    local exit_code = start_quarry(input_data)
end

---------------------------RUN PROGRAM---------------------------

main()