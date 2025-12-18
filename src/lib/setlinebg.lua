---Set the colour of a specific line on a monitor.
---@param monitor ccTweaked.peripherals.Monitor
---@param y number
---@param colour integer
return function(monitor, y, colour)
    monitor.setBackgroundColor(colour)
    local cx, cy = monitor.getCursorPos()
    monitor.setCursorPos(1, y)
    monitor.clearLine()
    monitor.setCursorPos(cx, cy)
end
