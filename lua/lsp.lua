vim.lsp.config("*", {
	capabilities = {
		textDocument = {
			semanticTokens = {
				multilineTokenSupport = true,
			},
		},
	},
	root_markers = { ".git" },
})

vim.diagnostic.config({
	virtual_text = false,
	virtual_lines = true,
	signs = true,
	underline = true,
	update_in_insert = true,
})

vim.lsp.config.sourcekit = {
	root_markers = { ".git", "Package.swift" },
}

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
