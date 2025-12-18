local pt = (function()
--- Prints a table
---@param t table
return function(t)
    for k, v in pairs(t) do
        print(k, v)
    end
end
end)()
local connector = peripheral.wrap("bottom")
---@cast connector ccTweaked.peripherals.Inventory

while true do
    local t = connector.list()
    for i = 1, math.random(100, 200) do
        print(pt(t[i]))
    end
    os.sleep(1)
end
