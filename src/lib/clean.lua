--- Cleans the output of target block .getLine() results
--- @param s string
return function(s)
    return s:gsub("%s*$", "")
end
