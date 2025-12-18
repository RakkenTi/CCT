--[[
    Lua bundler
    To use, call the file and give the root file to bundle as the first argument.
]]

local HEADER = "========================"
local SEPERATOR = "---------------------------"

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
assert(fs.exists(root_path), "File does not exist at", root_path)
print("\n")
print(HEADER)
print("BUNDLING FILE AT", root_path)
print(SEPERATOR)

---@param path string
local function openFile(path)
    local file = fs.open(path, "r+")
    assert(file, "File does not exist!")
    print("Opened", path)
    return file
end

local root_file = openFile(root_path)

local function parseFile(file)
    ---@cast file ccTweaked.fs.BinaryReadHandle|ccTweaked.fs.BinaryWriteHandle|ccTweaked.fs.ReadHandle|ccTweaked.fs.WriteHandle
    local source = ""
    while true do
        local current_line = file.readLine()
        if not current_line then break end
        local path = current_line:match("require%([" .. '"' .. "'" .. "](.*)[" .. '"' .. "'" .. "]%)")
        if path then
            ---@cast path string
            path = path:gsub("%.lua", ""):gsub("%.", "/") .. ".lua"
            local variable_name = current_line:match("local (.*) %=")
            local dependency_file = openFile(path)

            local parsed_dependency = parseFile(dependency_file)
            dependency_file.close()

            local r = "local " .. variable_name .. " = (function()\n" .. parsed_dependency .. "end)()"
            source = source .. r .. "\n"
        else
            source = source .. current_line .. "\n"
        end
    end

    return source
end

local function bundleFile(file)
    ---@cast file ccTweaked.fs.BinaryReadHandle|ccTweaked.fs.BinaryWriteHandle|ccTweaked.fs.ReadHandle|ccTweaked.fs.WriteHandle
    local new_source = parseFile(file)
    local result_file = fs.open(result_path, "w")
    assert(result_file, "Failed to open result file!")
    result_file.write(new_source)
    result_file.close()
    file.close()
end

bundleFile(root_file)
print(SEPERATOR)
print("BUNDLED FILE")
print("Bundled file location:", result_path)
print(HEADER)
print("\n")
