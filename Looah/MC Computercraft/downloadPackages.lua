--[[
    This software will perform a fresh install of all programs in PACKAGES for turtles.
]]

PACKAGES = {
    ["stairMaker"] = "QHf8evLE", -- Need to add item storage stuff to this
    ["quarry"] = "vqbJcqCk",
    ["elevator"] = "5F9wdhrm",
    ["commonUtils"] = "qMyK5xrK",
    ["platform"] = "F0HQRDnX",
    ["netherRefuel"] = "yCMci8qT"
}

INSTALLSHELL = "pastebin get %s %s" -- Replace first string with value, second with key
UNINSTALLSHELL = "delete %s"

print("Performing fresh install of packages\n\n")

-- MAKE A PROGRESS BAR INSTEAD OF SAYING WHAT ITS INSTALLING
--[[
    Using the length of PACKAGES, can make each iteration add a certain length to the loading bar variable.
    Bar length = local width, _ = term.getSize()
    clear terminal and then print bar, can still include text.
]]

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
print("Packages installed:")

for k,_ in pairs(PACKAGES) do
    print(k)
end