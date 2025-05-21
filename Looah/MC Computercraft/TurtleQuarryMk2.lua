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
    instructionName = instructionFunctionPointer, -- placeholder :3
}

local runtimeConfig = {}
local toolPath = {} -- Empty toolpath to be written to & decoded



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

local function generateTurtleToolpath(dimensions)
    --[[
        Generate toolpath instruction set & save to file.
        dimensions - object holding the length, width and depth values of the quarry
    ]]
    -- using the provided 3d dimensions, generate a predefined set of instructions to perform the quarry & save file
end

local function intructionDecoder(toolPathFile)
    -- load toolpath file
    -- read action & decode to excecution
    -- constantly write current progress to save (same?separate?) file to make it power safe
end

local function calculateFuelExpenditure()
    -- 
end

