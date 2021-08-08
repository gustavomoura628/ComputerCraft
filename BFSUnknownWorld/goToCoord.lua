local coordfile = fs.open("coordinates.txt", "r")
if coordfile == nil then print("Could not find coordinates.txt file") return nil end
local turtleX = tonumber(coordfile.readLine())
local turtleY = tonumber(coordfile.readLine())
local turtleZ = tonumber(coordfile.readLine())
local turtleW = tonumber(coordfile.readLine())
coordfile.close()

print("initial coordinates "..turtleX..", "..turtleY..", "..turtleZ..", "..turtleW)

local function updateCoordinatesFile()
    local coordfile = fs.open("coordinates.txt", "w")
    if coordfile == nil then print("Could not write to coordinates.txt file") return nil end
    coordfile.write(turtleX.."\n")
    coordfile.write(turtleY.."\n")
    coordfile.write(turtleZ.."\n")
    coordfile.write(turtleW.."\n")
    coordfile.close()
    return true
end

local translationDirection = { ['x']={[0]=0,1,0,-1}, ['z']={[0]=-1,0,1,0}}
local function forward(n)
    if(n==nil)then n=1 end
    if(n<=0)then print("Wrong input on movement function!") return nil end
    local i = 0
    while i < n do
        if(turtle.forward()) then
            turtleX = turtleX + translationDirection['x'][turtleW]
            turtleZ = turtleZ + translationDirection['z'][turtleW]
            i = i + 1
            if updateCoordinatesFile() == nil then break end
        else
            break
        end
    end
    local res = true
    if i ~= n then res = false end
    return res, i
end
local function back(n)
    if(n==nil)then n=1 end
    if(n<=0)then print("Wrong input on movement function!") return nil end
    local i = 0
    while i < n do
        if(turtle.back()) then
            turtleX = turtleX + translationDirection['x'][(turtleW+2)%4]
            turtleZ = turtleZ + translationDirection['z'][(turtleW+2)%4]
            i = i + 1
            if updateCoordinatesFile() == nil then break end
        else
            break
        end
    end
    local res = true
    if i ~= n then res = false end
    return res, i
end
local function up(n)
    if(n==nil)then n=1 end
    if(n<=0)then print("Wrong input on movement function!") return nil end
    local i = 0
    while i < n do
        if(turtle.up()) then
            turtleY = turtleY + 1
            i = i + 1
            if updateCoordinatesFile() == nil then break end
        else
            break
        end
    end
    local res = true
    if i ~= n then res = false end
    return res, i
end
local function down(n)
    if(n==nil)then n=1 end
    if(n<=0)then print("Wrong input on movement function!") return nil end
    local i = 0
    while i < n do
        if(turtle.down()) then
            turtleY = turtleY - 1
            i = i + 1
            if updateCoordinatesFile() == nil then break end
        else
            break
        end
    end
    local res = true
    if i ~= n then res = false end
    return res, i
end
local function turnRight(n)
    if(n==nil)then n=1 end
    if(n<=0)then print("Wrong input on movement function!") return nil end
    local i = 0
    while i < n do
        if(turtle.turnRight()) then
            turtleW = (turtleW + 1 + 4)%4
            i = i + 1
            if updateCoordinatesFile() == nil then break end
        else
            break
        end
    end
    local res = true
    if i ~= n then res = false end
    return res, i
end
local function turnLeft(n)
    if(n==nil)then n=1 end
    if(n<=0)then print("Wrong input on movement function!") return nil end
    local i = 0
    while i < n do
        if(turtle.turnLeft()) then
            turtleW = (turtleW - 1 + 4)%4
            i = i + 1
            if updateCoordinatesFile() == nil then break end
        else
            break
        end
    end
    local res = true
    if i ~= n then res = false end
    return res, i
end
local function turnTo(w)
    local diff = (w - turtleW + 4)%4
    if diff == 1 then turnRight() end
    if diff == 3 then turnLeft() end
    if diff == 2 then turnRight() turnRight() end
end
local function goToCoord(x,y,z,w)
    if x == nil then x = turtleX end
    if y == nil then y = turtleY end
    if z == nil then z = turtleZ end
    if w == nil then w = turtleW end
    local diffy = y-turtleY
    local res
    if diffy > 0 then res = up(diffy) end
    if diffy < 0 then res = down(-diffy) end
    if res==false then return false end
    if turtleW == 1 or turtleW == 3 then
        local diffx = x-turtleX
        print("diffx = "..diffx)
        local res
        if turtleW==1 then
            if diffx > 0 then res = forward(diffx) end
            if diffx < 0 then res = back(-diffx) end
        else
            if diffx > 0 then res = back(diffx) end
            if diffx < 0 then res = forward(-diffx) end
        end
        if res==false then return false end
    elseif turtleW == 0 or turtleW == 2 then
        local diffz = z-turtleZ
        print("diffz = "..diffz)
        local res
        if turtleW==2 then
            if diffz > 0 then res = forward(diffz) end
            if diffz < 0 then res = back(-diffz) end
        else
            if diffz > 0 then res = back(diffz) end
            if diffz < 0 then res = forward(-diffz) end
        end
        if res==false then return false end
    end
    local diffx = x-turtleX
    print("diffx = "..diffx)
    local res
    if diffx ~= 0 then
        if turtleW ~= 1 and turtleW~=3 then
            if diffx > 0 then 
                turnTo(1)
                else turnTo(3)
            end
        end
        if turtleW==1 then
            if diffx > 0 then res = forward(diffx) end
            if diffx < 0 then res = back(-diffx) end
        else
            if diffx > 0 then res = back(diffx) end
            if diffx < 0 then res = forward(-diffx) end
        end
        if res==false then return false end
    end
    local diffz = z-turtleZ
        print("diffz = "..diffz)
    local res
    if diffz ~= 0 then
        if turtleW~= 0 and turtleW~=2 then
            if diffz > 0 then 
                turnTo(2)
                else turnTo(0)
            end
        end
        if turtleW==2 then
            if diffz > 0 then res = forward(diffz) end
            if diffz < 0 then res = back(-diffz) end
        else
            if diffz > 0 then res = back(diffz) end
            if diffz < 0 then res = forward(-diffz) end
        end
        if res==false then return false end
    end
    turnTo(w)
    return true
end
goToCoord(tonumber(arg[1]),tonumber(arg[2]),tonumber(arg[3]),tonumber(arg[4]))
print("current coordinates "..turtleX..", "..turtleY..", "..turtleZ..", "..turtleW)
