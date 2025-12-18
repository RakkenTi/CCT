local BG_C = colors.white
local TEXT_C = colors.blue

local HEADER_TEXT = "Processing Room Chute"

local writecenter = require("src.lib.writecenter")

local LR_T = {
    "Smelt",
    "Smoke",
    "Haunt",
    "Wash",
    "Enrich",
}

local monitor = peripheral.wrap("back")
---@cast monitor ccTweaked.peripherals.Monitor

monitor.setTextScale(1.5)
monitor.setBackgroundColor(BG_C)
monitor.clear()
monitor.setTextColor(TEXT_C)

local w, h = monitor.getSize()
local center_y = math.ceil(h / 2)
local cell_width = w / #LR_T

-- Header
monitor.setCursorPos(1, 1)
writecenter(monitor, HEADER_TEXT, center_y)

-- Fan Chutes
for i = 1, #LR_T do
    local text = LR_T[i]
    monitor.setCursorPos(((cell_width - #text) / 2) + (cell_width * (i - 1)) + 1, h - 1)
    monitor.write(text)
end
