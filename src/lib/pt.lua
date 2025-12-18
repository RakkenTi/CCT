--- Prints a table
---@param t table
return function(t)
    for k, v in pairs(t) do
        print(k, v)
    end
end
