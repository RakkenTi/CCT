---@param monitor ccTweaked.peripherals.Monitor
---@param t string | number
---@param y integer
return function(monitor, t, y)
    if not monitor["getSize"] then
        error("Monitor is not a wrapped peripheral!")
        return
    end

    if type(t) ~= "string" then
        error("Second parameter must be a string!")
    end

    local w = monitor.getSize()
    local px = ((w - #t) / 2) + 1
    local cx, cy = monitor.getCursorPos()
    local rx, ry = monitor.setCursorPos(px, y)
    monitor.write(t)
    monitor.setCursorPos(cx, cy)
    return rx, ry
end
