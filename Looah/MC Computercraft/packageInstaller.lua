--[[
    Package installer for the stuff I've made
    It also has a progress bar!
]]

-------------------------Constant Declarations-------------------------

-- Common Utility Libraries
local PACKAGES = {
    -- APIs
    ["common/systemLib.lua"] = "q4vfvQPk",
    ["common/storageLib.lua"] = "SzD8A2sq",
    ["common/mineLib.lua"] = "N0mkQCxV",
    -- Startup
    ["startup.lua"] = "tqVxm1HC",
    -- Programs
    ["stairMiner.lua"] = "QHf8evLE",
    ["quarry.lua"] = "aaNTTxMV",
    ["elevator.lua"] = "5F9wdhrm",
    ["platformBuilder.lua"] = "F0HQRDnX",
    ["lavaRefuel.lua"] = "yCMci8qT",
}

-- Generic command line strings
local INSTALLSHELL = "pastebin get %s %s"
local UNINSTALLSHELL = "delete %s"

local maxProgress, progressBar = 0, 0
for _ in pairs(PACKAGES) do maxProgress = maxProgress + 1 end

local function printProgressBar(current, max)
    local progress = current/max -- Normalised progress
    local width,_,_ = term.getSize()
    local progressPips, n = width - 2, 0

    term.clear()
    io.write("[")
    while n < progressPips do
        if (n/progressPips) > progress then
            io.write(".")
        else
            io.write("|")
        end
        n = n + 1
    end
    io.write("]")
    print("")
end

-------------------------Start Program-------------------------

-- Install required libraries, ensure they are done first
for k,v in pairs(PACKAGES) do
    printProgressBar(progressBar, maxProgress)
    print("Current package: ", k)
    print(" ")
    if fs.exists(k) == true then
        shell.run(string.format(UNINSTALLSHELL,k))
    end
    shell.run(string.format(INSTALLSHELL,v,k))
    progressBar = progressBar + 1
end

printProgressBar(maxProgress,maxProgress)
print("Installation complete\n:3")