--[[
    This is just to make sure I know how lua works lmao
    It's a todo list, I can add stuff I need to do so I don't forget & stuff
    To do file is called "toDoList"
]]

local toDo = {} --Table :)

function addFunc()
    --append to list
    print("What would you like to add to the list?")
    local task = string.lower(tostring(read()))
    table.insert(toDo,task)
    saveFile(toDo)
end

function editFunc(taskIndex, newTask)
    --change existing entry
    print("What entry number do you want to edit?")
    local index = tonumber(read())
    print("And replace it with what?")
    local answer = string.lower(tostring(read()))
    toDo[index] = answer
    saveFile(toDo)
    lookFunc()
end

function lookFunc()
    --print list
    for i,k in pairs(toDo) do
        print(i,k)
    end
end

function removeFunc()
    --remove an entry
    print("What entry number do you want to remove?")
    local input = tonumber(read())
    table.remove(toDo,input)
    saveFile(toDo)
end

function saveFile(table)
    local tableString = textutils.serialize(table)
    --save tableString to file
    local tFile = fs.open("ToDoList", "w")
    tFile.write(tableString)
    tFile.close()
end

function loadFile(tableName)
    --read string from file
    local tFile = fs.open(tableName, "r")
    local fileContents = tFile.readAll()
    local readTable = textutils.unserialize(fileContents)
    return readTable
end

local exit = false
local paths = {add = addFunc, edit = editFunc, look = lookFunc, remove = removeFunc}


if fs.exists("ToDoList") then
    toDo = loadFile("ToDoList")
end

while exit == false do
    print("Would you like to add, edit, look or remove an item?")
    print("Simply say: Add, Edit, Look or Remove")

    local uInput = string.lower(tostring(read()))
    term.clear()

    if paths[uInput] ~= nil then
        paths[uInput]()
    else    
        print("Error, command not in function table")
    end

    if uInput == "exit" then
        exit = true
    end
end