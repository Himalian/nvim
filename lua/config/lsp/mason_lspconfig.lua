local M = {}

M.opts = {
	automatic_enable = {
		-- The following servers are manually configured
		exclude = {
			"lua_ls",
			"basedpyright",
			"powershell_es",
			"ruff",
			"sourcekit",
			"nu",
			"ty",
			--  Sourcekit is not available in mason, but I need to disable
			--  automatically setup(especially for c and cpp, they use clangd
			--  for diagnosticing). I'm not sure if it's correct to disable at
			--  here
			"sourcekit" --
		},
	},
	ensure_installed = {
		"basedpyright",
		"lua_ls",
		"ruff",
	},
}

return M
