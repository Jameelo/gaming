--[[
    This software will perform a fresh install of all programs in PACKAGES
]]

PACKAGES = {
    ["stairMaker"] = "QHf8evLE", -- Need to add item storage stuff to this
    ["quarry"] = "vqbJcqCk",
    ["upQuarry"] = "F19UiGCN",
    ["elevator"] = "5F9wdhrm",
    ["commonUtils"] = "qMyK5xrK"
}

INSTALLSHELL = "pastebin get %s %s" -- Replace first string with value, second with key
UNINSTALLSHELL = "delete %s"

print("Performing fresh install of packages\n\n")

for k,v in pairs(PACKAGES) do
    term.clear()
    print("Program: ",k,"\n\n")

    if fs.exists(k) == true then
        print("Uninstalling...\n")
        shell.run(string.format(UNINSTALLSHELL,k))
        print("Uninstallation complete :)\n\n")
    end
    print("Installing...\n")
    shell.run(string.format(INSTALLSHELL,v,k))
    print("Installation complete :)\n")
end

term.clear()
print("Packages installed.\n\n")