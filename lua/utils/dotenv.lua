-- Dotenv module from https://gist.github.com/veeponym/6a8f7ba661032ddce1e941095a998a69

-- Define a dotenv object
local dotenv = {}

-- Define a function to read a file and return its contents as a string
local function readFile(filename)
	-- Open the file in read mode
	local file = io.open(filename, "r")
	-- Check if the file exists
	if not file then
		-- Return nil and an error message
		return nil, "File not found: " .. filename
	end
	-- Read the whole file content
	local content = file:read("*a")
	-- Close the file
	file:close()
	-- Return the content
	return content
end

-- Define a function to parse a .env file and return a table of key-value pairs
local function parseEnv(content)
	-- Create an empty table to store the pairs
	local pairs = {}
	-- Loop through each line in the content
	for line in content:gmatch("[^\r\n]+") do
		-- Trim any leading or trailing whitespace from the line
		line = line:match("^%s*(.-)%s*$")
		-- Ignore empty lines or lines starting with #
		if line ~= "" and line:sub(1, 1) ~= "#" then
			-- Split the line by the first = sign
			local key, value = line:match("([^=]+)=(.*)")
			-- Trim any leading or trailing whitespace from the key and value
			key = key:match("^%s*(.-)%s*$")
			value = value:match("^%s*(.-)%s*$")
			-- Check if the value is surrounded by double quotes
			if value:sub(1, 1) == '"' and value:sub(-1, -1) == '"' then
				-- Remove the quotes and unescape any escaped characters
				value = value:sub(2, -2):gsub('\\"', '"')
			end
			-- Check if the value is surrounded by single quotes
			if value:sub(1, 1) == "'" and value:sub(-1, -1) == "'" then
				-- Remove the quotes
				value = value:sub(2, -2)
			end
			-- Store the key-value pair in the table
			pairs[key] = value
		end
	end
	-- Return the table
	return pairs
end

--- Define a function to load the environment variables from a .env file into the _G table
---@param filename string
---@param path string | nil
function dotenv.load(filename, path)
	filename = filename or ".env"
	path = path or vim.fn.stdpath("config")
	local full_path = vim.fs.abspath(vim.fs.joinpath(path,filename))
	-- check file exists before read
	if not vim.uv.fs_stat(full_path) then
		vim.schedule(function()
			vim.notify("environment file " .. vim.fs.normalize(full_path) .. " not found", vim.log.levels.WARN)
		end)
		return
	end

	-- Read the file content
	local content, err = readFile(full_path)
	-- Check if there was an error
	if not content then
		-- Return nil and the error message
		return nil, err
	end
	-- Parse the file content
	local parsed_pairs = parseEnv(content)
	-- Loop through the pairs
	for key, value in pairs(parsed_pairs) do
		-- Check if the key is not already in the vim.env table
		if not vim.env[key] then
			-- Set the key-value pair in the vim.env table
			vim.env[key] = value
		end
		-- Optionally, also set in the _G table if needed
		-- if not _G[key] then
		--     _G[key] = value
		-- end
	end
	-- Return true
	return true
end

-- Add a debug function to print loaded environment variables
function dotenv:debug()
	print("Loaded environment variables:")
	for key, value in pairs(vim.env) do
		print(key .. " = " .. tostring(value))
	end
end

-- Return the dotenv object
return dotenv
