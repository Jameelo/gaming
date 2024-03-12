--[[
    Startup file, could be useful later but was made at first to resume quarry code when I log back in
]]

function checkQuarryInterrupted() -- See if the quarry needs resuming
    -- if the save file exists, then run the quarry program as it'll handle the rest.
    if fs.exists("common/QPROG") then
        shell.run("quarry.lua")
    else
        print("Quarry program was not in progress when runtime ended.")
    end
end

-- Need to check if commonUtils is installed, if not then do a full install
if fs.exists("commonUtils.lua") == false then
    print("Reinstalling common utility library...")
    shell.run(string.format("pastebin run qMyK5xrK")) -- run full package installer
end

--os.loadAPI("commonUtils.lua")
-- print("Checking for updates...")
--function checkUpdate(address,programName)
    -- This function should actually be on startup, but for now I'll write the idea down here.
    -- Download the program in question under a temp name and check if it matches the currently installed version.
    -- If there is a SINGLE difference, use the newly downloaded program as the new version.
--end

-- Can make this next bit optional by having the quarry program raise a flag when running, and lowering it when not, all inside a save file.
print("")
print("Resuming quarry program...")

checkQuarryInterrupted()