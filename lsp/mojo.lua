---@type vim.lsp.Config
return {
	cmd = { "mojo-lsp-server" },
	filetypes = { "mojo" },
	root_markers = { ".git" },
}
