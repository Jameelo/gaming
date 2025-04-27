--[[
    Code automatically excecuted on turtle startup
]]

-- should check to see if all required common libraries are installed

LIBRARIES = {
    ["systemLib.lua"] = "q4vfvQPk",
    ["storageLib.lua"] = "SzD8A2sq",
    ["mineLib.lua"] = "N0mkQCxV",
}

for lib, pbID in LIBRARIES do
    if fs.exists(lib) == false then
        print("Reacquiring library: %s", lib)
        shell.run(string.format("pastebin get %s %s", pbID, lib)) -- run full package installer
    end
end