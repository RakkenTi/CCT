--[[
    Lua bundler
    To use, call the file and give the root file to bundle as the first argument.
]]

local args = { ... }
local root_path = args[1]
---@cast root_path string


---@param path string
local function getFileName(path)
    local r = path:match("[%/]([%w_]*)%.lua$")
    return r
end

local filename = getFileName(root_path)
local result_path = "src/bundled/" .. filename .. ".lua"
root_path:gsub(".lua", ".bundled.lua")
assert(fs.exists(root_path), "Given path does not exist!")

---@param path string
local function openFile(path)
    local file = fs.open(path, "r+")
    assert(file, "File does not exist!")
    return file
end

local root_file = openFile(root_path)

local function parseFile(file)
    ---@cast file ccTweaked.fs.BinaryReadHandle|ccTweaked.fs.BinaryWriteHandle|ccTweaked.fs.ReadHandle|ccTweaked.fs.WriteHandle
    local source = ""
    while true do
        local current_line = file.readLine()
        if not current_line then break end
        local has_require = current_line:match("require")
        if has_require then
            local path = current_line:match("require%([" .. '"' .. "'" .. "](.*)[" .. '"' .. "'" .. "]%)")
            ---@cast path string
            path = path:gsub("%.lua", ""):gsub("%.", "/") .. ".lua"
            local variable_name = current_line:match("local (.*) %=")
            print("Opening file: ", path)
            local dependency_file = openFile(path)

            local parsed_dependency = parseFile(dependency_file)
            dependency_file.close()

            local r = "local " .. variable_name .. " = (function()\n" .. parsed_dependency .. "end)()"
            source = source .. r .. "\n"
        else
            source = source .. current_line .. "\n"
        end
    end

    print("Returning source")
    return source
end

local function bundleFile(file)
    ---@cast file ccTweaked.fs.BinaryReadHandle|ccTweaked.fs.BinaryWriteHandle|ccTweaked.fs.ReadHandle|ccTweaked.fs.WriteHandle
    local new_source = parseFile(file)
    root_file.close()
    local result_file = fs.open(result_path, "w")
    assert(result_file, "Failed to open result file!")
    result_file.write(new_source)
    result_file.close()
end

bundleFile(root_file)
