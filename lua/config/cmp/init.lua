local insert = require("config.cmp.insert")
local cmdline = require("config.cmp.cmdline")
local M = {}

function M.setup()
	insert.setup()
	-- cmdline.setup()
end
return M
