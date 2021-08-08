function pqueueInitialize()
    local q = {}
    q.size=0
    return q
end

function pqueuePush(q,x,val)
    print("Adding "..x.." with priority "..val)
    local newv = {x,val}
    if q.size == 0 then 
        print("queue has size 0, initializing...")
        q.front = newv
        q.back = newv
    elseif q.front[2] > newv[2] then
        print("first value is already bigger than priority")
        newv[3] = q.front
        q.front = newv
    else
        local v = q.front
        while v[3] ~= nil do
            print("testing "..v[3][1].." "..v[3][2])
            if v[3][2] > newv[2] then
                if v[3][3] == nil then q.back = newv end
                newv[3] = v[3]
                v[3] = newv
                break
            end
            v = v[3]
        end
        if v[3] == nil then
            v[3] = newv
            q.back = newv
        end
    end
    q.size = q.size + 1
end

function pqueuePop(q)
    q.size = q.size - 1
    local x = q.front[1]
    local val = q.front[2]
    q.front = q.front[3]
    return x, val
end

function pqueueFront(q)
    local x = q.front[1]
    local val = q.front[2]
    return x, val
end

function pqueueBack(q)
    local x = q.back[1]
    local val = q.back[2]
    return x, val
end

function pqueueSize(q)
    return q.size
end

local q = pqueueInitialize()
pqueuePush(q,10,0)
pqueuePush(q,14,1)
pqueuePush(q,16,-1)
print(pqueueFront(q))
