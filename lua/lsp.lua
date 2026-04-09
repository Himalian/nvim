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

-- check for details:
-- https://neovim.io/doc/user/lsp/#lsp-document_color
-- https://notebooklm.google.com/notebook/dbfb47bb-5b82-4f5d-be12-702d5067dc2c
vim.lsp.document_color.enable(true, nil, { style = "virtual" })
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
