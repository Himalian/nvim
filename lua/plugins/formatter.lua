return {
	"stevearc/conform.nvim",
	event = "VeryLazy",
	opts = {
		formatters_by_ft = {
			lua = { "stylua", lsp_format = "fallback" },
			-- Conform will run multiple formatters sequentially
			python = { "ruff", "black", "isort", stop_after_first = true },
			-- You can customize some of the format options for the filetype (:help conform.format)
			rust = { "rustfmt", lsp_format = "fallback" },
			-- Conform will run the first available formatter
			javascript = { "biome", "prettier", stop_after_first = true, lsp_format = "fallback" },
			cpp = { "clang-format" },
			nix = { "nixfmt" },
			go = { "gofmt" },
		},
		formatters = {
			ruff = {
				command = "ruff",
				args = { "format", "--stdin-filename", "$FILENAME" },
			},
		},
	},
	keys = {
		{
			"<leader>fc",
			function()
				require("conform").format({
					lsp_format = "fallback",
				})
			end,
			desc = "Format Code",
		},
	},
}
