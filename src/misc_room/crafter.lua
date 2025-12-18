local BG_C = colors.white
local FONT_C = colors.black

local PROMPT_TEXT = "Craft"

local writecenter = require("src.lib.writecenter")
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
