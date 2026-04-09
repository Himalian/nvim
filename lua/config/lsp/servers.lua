local M = {}
function M.setup()
	vim.lsp.enable({
		"clangd",
		"lua_ls",
		"pwsh",
		"gopls",
		"sourcekit-lsp",
		"basedpyright",
		"cue",
		"nu",
		"nil",
		"biome",
		-- "ty"
	})
end
return M
