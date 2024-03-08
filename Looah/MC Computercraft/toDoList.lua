--[[
    This is just to make sure I know how lua works lmao
    It's a TODOLIST list, I can add stuff I need to do so I don't forget & stuff
    To do file is called "toDoList"
]]

TODOLIST = {} --To do list in table form
EXIT = false
TODOSAVEfilename = "common/ToDoList"

os.loadAPI("commonUtils.lua")

function addFunc()
    --append to list
    print("What would you like to add to the list?")
    local task = string.lower(tostring(read()))
    table.insert(TODOLIST,task)
    commonUtils.saveFile(TODOLIST,TODOSAVEfilename)
end

function editFunc(taskIndex, newTask)
    --change existing entry
    print("What entry number do you want to edit?")
    local index = tonumber(read())
    print("And replace it with what?")
    local answer = string.lower(tostring(read()))
    TODOLIST[index] = answer
    commonUtils.saveFile(TODOLIST,TODOSAVEfilename)
    lookFunc()
end

function lookFunc()
    --print list
    term.clear()
    for i,k in pairs(TODOLIST) do
        print(i,k)
    end
    print("")
end

function removeFunc()
    --remove an entry
    print("What entry number do you want to remove?")
    local input = tonumber(read())
    table.remove(TODOLIST,input)
    commonUtils.saveFile(TODOLIST,TODOSAVEfilename)
end

local paths = {add = addFunc, edit = editFunc, remove = removeFunc}

if fs.exists(TODOSAVEfilename) then
    TODOLIST = commonUtils.loadFile()
else
    TODOLIST = {"Make a to-do list!"}
    commonUtils.saveFile(TODOLIST)
    TODOLIST = commonUtils.loadFile(TODOSAVEfilename)
end

while EXIT == false do
    lookFunc()
    print("Would you like to do?")
    print("Simply say: Add, Edit, or Remove")

    local uInput = string.lower(tostring(read()))
    term.clear()

    if paths[uInput] ~= nil then
        paths[uInput]()
    elseif uInput == "exit" then
        EXIT = true
    else
        print("Error, unrecognised function")
    end
end