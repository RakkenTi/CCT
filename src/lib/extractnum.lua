--- Extracts and concatenates all numbers from a string.
---@param s string
return function(s)
    return s:gsub("%D", "")
end
