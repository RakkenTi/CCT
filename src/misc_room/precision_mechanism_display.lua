local monitor = peripheral.wrap((function()
    local all = peripheral.getNames()
    for _, v in ipairs(all) do
        if v:match("monitor") then
            return v
        end
    end
end)())
print("Starting Display..")

if not monitor then return end

local sg = peripheral.wrap("create_target_1")
local bg = peripheral.wrap("create_target_2")
local ing = peripheral.wrap("create_target_3")
local all_targets = {
    { "Small Cog",    sg },
    { "Big Cog",      bg },
    { "Iron Nuggets", ing }
}
local TITLE = "Precision Mechanism"
local w, h = monitor.getSize()
local Y_STEP = math.floor(2)

monitor.setBackgroundColor(colors.white)
monitor.setTextColor(colours.white)
monitor.setCursorPos(1, 1)
monitor.clear()
monitor.setTextScale(2)
monitor.write("Starting..")
monitor.setTextScale(1)
os.sleep(1)
print("Display Started!")
while true do
    monitor.clear()
    monitor.setCursorPos((w - #TITLE) / 2, 2)
    monitor.setTextColor(colours.black)
    monitor.write(TITLE)
    local i = 1
    for _, target_data in ipairs(all_targets) do
        local name = target_data[1]
        local target = target_data[2]
        assert(target)
        local status = target.getLine(1):gsub(" ", "")
        local text = " " .. name .. " | " .. status
        monitor.setTextColor(colours.green)
        local x = (w - #text) / 2
        if status == "0%" then
            monitor.setTextColor(colours.red)
        end
        monitor.setCursorPos(x, i * Y_STEP + 4)
        monitor.write(text)
        i = i + 1
    end
    os.sleep(1)
end
