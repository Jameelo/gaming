--[[
    This is just to make sure I know how lua works lmao
    It's a TODOLIST list, I can add stuff I need to do so I don't forget & stuff
    To do file is called "toDoList"
]]

TODOLIST = {"Make a todo list!"} --To do list in table form
EXIT = false

function addFunc()
    --append to list
    print("What would you like to add to the list?")
    local task = string.lower(tostring(read()))
    table.insert(TODOLIST,task)
    saveFile(TODOLIST)
end

function editFunc(taskIndex, newTask)
    --change existing entry
    print("What entry number do you want to edit?")
    local index = tonumber(read())
    print("And replace it with what?")
    local answer = string.lower(tostring(read()))
    TODOLIST[index] = answer
    saveFile(TODOLIST)
    lookFunc()
end

function lookFunc()
    --print list
    for i,k in pairs(TODOLIST) do
        print(i,k)
    end
end

function removeFunc()
    --remove an entry
    print("What entry number do you want to remove?")
    local input = tonumber(read())
    table.remove(TODOLIST,input)
    saveFile(TODOLIST)
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

local paths = {add = addFunc, edit = editFunc, look = lookFunc, remove = removeFunc}

if fs.exists("ToDoList") then
    TODOLIST = loadFile("ToDoList")
end

while EXIT == false do
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
        EXIT = true
    end
end