local M = {}

function M.setup()
	vim.lsp.config("*", {
		capabilities = {
			textDocument = {
				-- semanticTokens = {},
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
	vim.lsp.document_color.enable(true, nil, { style = "virtual" })
end

return M
