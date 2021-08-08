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
    if w ==nil then w = turtleW end
    local diffy = y-turtleY
    local res
    if diffy > 0 then res = up(diffy) end
    if diffy < 0 then res = down(-diffy) end
    if res==false then return false end
    if turtleW == 1 or turtleW == 3 then
        local diffx = x-turtleX
        --print("diffx = "..diffx)
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
        --print("diffz = "..diffz)
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
    --print("diffx = "..diffx)
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
    --print("diffz = "..diffz)
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
 
function getword(string, n)
    local word = ""
    local i = 1
    local j = 0
    while true do
        local c = string.char(string.byte(string, i))
        if c == ' ' or c == "" then
            j = j + 1
            if j == n then
                return word
            end
            word=""
        else
            word = word .. c
        end
        if c == "" then return nil end
        i = i + 1
    end
end
function queueInitialize()
    local q = {}
    q.front=0
    q.back=0
    q.size=0
    return q
end

function queuePush(q,x)
    q[q.back] = x
    --print("pushed "..q[q.back].." to q["..q.back.."]")
    q.size = q.size + 1
    q.back = q.back+1
end

function queuePop(q)
    q.size = q.size - 1
    local x = q[q.front]
    q.front = q.front + 1
    return x
end

function queueFront(q)
    return q[q.front]
end

function queueBack(q)
    return q[q.back-1]
end

function queueSize(q)
    return q.size
end

function findNeighbours(node)
    local x = tonumber(getword(node,1))
    local y = tonumber(getword(node,2))
    local z = tonumber(getword(node,3))
    local w = tonumber(getword(node,4))
    local neighbours = {}
    local n = 0
    if w == 1 then neighbours[n+1] = (x+1).." "..y.." "..z.." "..w n = n + 1 end
    if w == 3 then neighbours[n+1] = (x-1).." "..y.." "..z.." "..w n = n + 1 end
    if w == 2 then neighbours[n+1] = x.." "..y.." "..(z+1).." "..w n = n + 1 end
    if w == 0 then neighbours[n+1] = x.." "..y.." "..(z-1).." "..w n = n + 1 end
    neighbours[n+1] = x.." "..y.." "..z.." "..((w+1)%4) n = n + 1
    neighbours[n+1] = x.." "..y.." "..z.." "..((w+2)%4) n = n + 1
    neighbours[n+1] = x.." "..y.." "..z.." "..((w+3)%4) n = n + 1
    --neighbours[n+1] = x.." "..(y+1).." "..z.." "..w n = n + 1 
    --neighbours[n+1] = x.." "..(y-1).." "..z.." "..w n = n + 1
    return neighbours, n
end

local function manhattanDistance(node0, node1)
    local x0 = tonumber(getword(node0,1))
    local y0 = tonumber(getword(node0,2))
    local z0 = tonumber(getword(node0,3))
    local w0 = tonumber(getword(node0,4))
    local x1 = tonumber(getword(node1,1))
    local y1 = tonumber(getword(node1,2))
    local z1 = tonumber(getword(node1,3))
    local w1 = tonumber(getword(node1,4))
    return math.abs(x0-x1) + math.abs(y0-y1) + math.abs(z0-z1) + math.abs(w0-w1)
end

local function sortNeighbours(neighbours, nneighbours, target)
    local i, j
    for i = 1, nneighbours, 1 do
        for j = 1, nneighbours - i - 1, 1 do
            if manhattanDistance(neighbours[j],target) > manhattanDistance(neighbours[j+1],target) then
                local temp = neighbours[j]
                neighbours[j] = neighbours[j+1]
                neighbours[j+1] = temp
            end
        end
    end
    for i = 1, nneighbours, 1 do
        print(neighbours[i].." md = "..manhattanDistance(neighbours[i],target))
    end
    return neighbours
end

function bfs(world, start, target)
    local prev = {}
    local visited = {}
    local q = queueInitialize()
    queuePush(q, start)
    visited[start] = '1'
    local E
    while true do
        local neighbours, nneighbours = findNeighbours(queueFront(q))
        --neighbours = sortNeighbours(neighbours, nneighbours, target)
        local i
        for i = 1, nneighbours, 1 do
            local fn = neighbours[i]
            if world[fn] ~= '#' and visited[fn] == nil then
                --print("added "..fn.." to queue")
                queuePush(q,fn)
                visited[fn]='1'
                prev[fn]=queueFront(q)
                if world[fn] == 'E' then break end
            end
        end
        visited[queueFront(q)]='2'
        queuePop(q)
        if world[queueBack(q)] == 'E' or queueSize(q) == 0 then break end
    end
    if queueSize(q) == 0 then return nil end

    local nex = {}
    local v = queueBack(q)
    while v ~= start do
        nex[prev[v]] = v
        v = prev[v]
    end
    return nex
end

local function updateWorld(world,node,value)
    local x = tonumber(getword(node,1))
    local y = tonumber(getword(node,2))
    local z = tonumber(getword(node,3))
    world[x.." "..y.." "..z.." "..0] = value
    world[x.." "..y.." "..z.." "..1] = value
    world[x.." "..y.." "..z.." "..2] = value
    world[x.." "..y.." "..z.." "..3] = value
end

local function saveWorld(world)
    local worldfile = fs.open("world.txt", "w")
    if worldfile == nil then print("Could not write to world.txt file") return nil end
    for i, v in pairs(world) do
        worldfile.write(i.."\n")
        worldfile.write(v.."\n")
    end
    worldfile.close()
end
local function loadWorld()
    local worldfile = fs.open("world.txt", "r")
    if worldfile == nil then print("Could not read world.txt file, assuming empty world") return {} end
    world = {}
    local line
    while true do
        line = worldfile.readLine()
        if line == nil then break end
        local id = line
        
        line = worldfile.readLine()
        if line == nil then break end
        local value = line
        world[id] = value
    end
    worldfile.close()
    return world
end


--local world = {}
local world = loadWorld()
local E = "0 0 0 0"
if arg[4] ~= nil then E = arg[1].." "..arg[2].." "..arg[3].." "..arg[4] end
world[E] = "E"
--updateWorld(world,"10 0 0","E")
local hasToUpdate = true
local nex;
while true do
    local S = turtleX.." "..turtleY.." "..turtleZ.." "..turtleW
    if world[S] == "E" then print("Done!") break end
    if hasToUpdate then print("Calculating path...") nex = bfs(world,S,E) print("Path Calculated!") end
    if nex == nil then
        print("could not find a path to target...")
        return false
    end
    --local v = S
    --while v ~= nil do
    --    print(v)
    --    v=x[v]
    --end
    local go = nex[S]
    print("go to "..go)
    local x = tonumber(getword(go,1))
    local y = tonumber(getword(go,2))
    local z = tonumber(getword(go,3))
    local w = tonumber(getword(go,4))
    local couldMove = goToCoord(x,y,z,w)
    if not couldMove then 
        if turtle.detect() then print("has block "..go) updateWorld(world, go, '#') 
        else 
            print("does not have block, waiting for entity to leave")
            while not goToCoord(x,y,z,w) do sleep(1) end
            couldMove = true
        end
    end
    hasToUpdate = not couldMove
end
world[E]=nil
saveWorld(world)
