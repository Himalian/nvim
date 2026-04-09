return {
	name = "biome",
	cmd = { "biome", "lsp-proxy" },
	filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "json", "jsonc", "vue" },
	root_markers = { ".git", "package.json", "bun.lock", "tsconfig.json" },
	offsetEncoding = { "utf-8" },
}
