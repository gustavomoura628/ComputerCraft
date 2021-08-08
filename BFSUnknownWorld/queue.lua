function queueInitialize()
    local q = {}
    q.front=0
    q.back=0
    q.size=0
    return q
end

function queuePush(q,x)
    q[q.back] = x
    print("pushed "..q[q.back].." to q["..q.back.."]")
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

