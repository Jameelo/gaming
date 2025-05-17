--[[
    This library contains functions relating to data structures & stuff
]]

function apiExists(path) -- Check if an API is real or not
    if fs.exists(path) ~= false then
        return true
    end
    return false
end

function dictLookup(dict,item) -- Checks to see if item is a key in dict, and return its value
    for k,v in pairs(dict) do
        if k == item then
            return v
        end
    end
    return false
end

function contains(table,element) -- Check to see if element is in table
    for _, value in pairs(table) do
        if value == element then
          return true
        end
    end
    return false
end

function saveFile(table,saveFileID)
    local tableString = textutils.serialize(table)
    --save tableString to file
    local tFile = fs.open(saveFileID, "w")
    tFile.write(tableString)
    tFile.close()
end

function loadFile(fileID) -- read table from file
    local tFile = fs.open(fileID, "r")
    local fileContents = tFile.readAll()
    local readTable = textutils.unserialize(fileContents)
    return readTable
end

function getTableLength(tableIn)
    local count = 0
    for _ in pairs(tableIn) do count = count + 1 end
    return count
end

function printProgressBar(current, max)
    local progress = current/max -- Normalised progress
    local width,_,_ = term.getSize()
    local progressPips, n = width - 2, 0
    
    io.write("[")
    for n in progressPips do
        if (n/progressPips) > progress then
            io.write(".")
        else
            io.write("|")
        end
    end
    io.write("]")
end