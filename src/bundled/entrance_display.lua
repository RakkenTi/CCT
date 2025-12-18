local BG_C = colors.white
local HEADER_BG_C = colors.white
local HEADER_C = colors.black
local FONT_C = colors.black

local BAR_BG_C = colors.cyan
local BAR_C = colors.green
local MAX_BAR_WIDTH_PERCENTAGE = 80

local LOOP = true

print("Boiler Room Display Starting..")

local wc = (function()
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
end)()
local setlinebg = (function()
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
end)()
local extractnum = (function()
--- Extracts and concatenates all numbers from a string.
---@param s string
return function(s)
    return s:gsub("%D", "")
end
end)()
local clean = (function()
--- Cleans the output of target block .getLine() results
--- @param s string
return function(s)
    return s:gsub("%s*$", "")
end
end)()

local monitor = peripheral.wrap((function()
    local all = peripheral.getNames()
    for _, v in ipairs(all) do
        if v:match("monitor") then
            return v
        end
    end
end)())
---@cast monitor ccTweaked.peripherals.Monitor

local speedometer = peripheral.wrap("create_target_4")
local smt1 = peripheral.wrap("create_target_5")
local smt2 = peripheral.wrap("create_target_6")

if not smt1 or not smt2 or not speedometer then
    error("Failed to get stressometer or speedometer.")
    return
end

---@type string
local capacity = clean(smt1.getLine(1))
---@type string
local usage = clean(smt2.getLine(1))

---@type string
local rpm = clean(speedometer.getLine(1))

print("Initial Capacity: ")
print("Initial Usage: ", usage)
print("Initial RPM: ", rpm)

repeat
    capacity = clean(smt1.getLine(1))
    usage = clean(smt2.getLine(1))
    monitor.setBackgroundColor(BG_C)
    monitor.clear()
    monitor.setTextColor(colors.black)
    monitor.setTextScale(2)
    local y = 5

    for i = 1, 3 do
        setlinebg(monitor, i, HEADER_BG_C)
    end
    monitor.setTextColor(HEADER_C)
    wc(monitor, "Live Statistics", 2)

    monitor.setBackgroundColor(BG_C)
    monitor.setTextColor(FONT_C)

    wc(monitor, "Capacity: " .. capacity, y)
    wc(monitor, "Usage: " .. usage, y + 2)

    -- usage bar
    local monitor_width = monitor.getSize()
    local max_bar_width = monitor_width * MAX_BAR_WIDTH_PERCENTAGE / 100
    local raw_capacity = extractnum(capacity)
    local raw_usage = extractnum(usage)
    local factor = raw_usage / raw_capacity
    local current_bar_width = max_bar_width * factor
    local blank_width = monitor_width - max_bar_width
    local x_offset = (blank_width / 2)

    -- render the bar
    monitor.setCursorPos(x_offset + 1, y + 4)
    for i = 0, max_bar_width - 1 do
        if i < current_bar_width then
            monitor.setBackgroundColor(BAR_C)
        else
            monitor.setBackgroundColor(BAR_BG_C)
        end
        monitor.write(" ")
    end

    sleep(0.5)
until not LOOP
