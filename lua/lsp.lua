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
	virtual_text = true,
	signs = true,
	underline = true,
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
	-- "ty"
})
