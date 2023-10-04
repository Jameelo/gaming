--[[
    I'm too lazy to use ladders to reach my mining turtle
    So I'm gonna make the turtle into an elevator
    TRUE == UP
]]

print("Elevator mode activated")

while DIRECTION == nil do
    print("Up or down?")
    directionChoice = string.lower(tostring(read()))
    acceptedResponses = {"up","down","u","d"}

    for index,value in pairs(acceptedResponses) do
        if directionChoice == value then
            if index%2==1 then
                DIRECTION = 1
                break
            else
                DIRECTION = 0
                break
            end
        end
    end
    if DIRECTION == nil then
        print("Invalid input, try again")
    end
end

print("By how many blocks")
distance = string.lower(tostring(read()))


if DIRECTION == 1 then
    for _ = 1,distance do
        turtle.up()
    end
elseif DIRECTION == 0 then
    for _ = 1,distance do
        turtle.down()
    end
else
    print("error!")
end