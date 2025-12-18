local BG_C = colors.white
local FONT_C = colors.black

local PROMPT_TEXT = "Craft"

local writecenter = (function()
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
local pull = os.pullEvent

local monitor = peripheral.find("monitor")
---@cast monitor ccTweaked.peripherals.Monitor

monitor.setBackgroundColor(BG_C)
monitor.setTextColor(FONT_C)
monitor.setTextScale(1)
monitor.clear()

local w, h = monitor.getSize()
local y_center = math.ceil(h / 2)

writecenter(monitor, PROMPT_TEXT, y_center)
while true do
    pull("monitor_touch")
    redstone.setOutput("top", true)
    sleep(0.1)
    redstone.setOutput("top", false)
end
