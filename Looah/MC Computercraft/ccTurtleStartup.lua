--[[
    Startup file, could be useful later but was made at first to resume quarry code when I log back in :3
]]

function checkQuarryInterrupted() -- See if the quarry needs resuming
    -- if the save file exists, then run the quarry program as it'll handle the rest.
    if fs.exists("common/QPROG") then
        -- Ideally will use arguments for this but its 1am and I'm tired
        shell.run("quarry.lua")
    else
        print("Quarry program was not in progress when runtime ended.")
    end
end

-- Need to check if commonUtils is installed, if not then do a full install
if fs.exists("commonUtils.lua") == false then
    print("Reinstalling common utility library...")
    shell.run(string.format("pastebin run qMyK5xrK")) -- run pastebin package installer so you get all of my apps >:) mwahaha
end

--os.loadAPI("commonUtils.lua")
-- print("Checking for updates...")
--[[
    To check for updates:
    Download a temp file & compare it to the current file, similar to my package installer program
    If there is a SINGLE difference, reinstall that program.
]]

-- Can make this next bit optional by having the quarry program raise a flag when running, and lowering it when not, all inside a save file.
print("")
print("Resuming quarry program...")

checkQuarryInterrupted()