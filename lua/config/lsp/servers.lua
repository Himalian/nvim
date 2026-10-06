local M = {}
function M.setup()
	vim.lsp.enable({
		"clangd",
		"mcppls",
		"lua_ls",
		"pwsh",
		"gopls",
		"sourcekit-lsp",
		"basedpyright",
		"cue",
		"nu",
		"nil",
		"biome",
		"mojo",
	})
end
return M
