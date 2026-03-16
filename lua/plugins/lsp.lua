local lspsaga = require("config.lsp.lspsaga")
local conf = require("config.lsp.lsp_signature")

return {
	{
		--LSP三件套
		"mason-org/mason-lspconfig.nvim",
		event = "VeryLazy",
		cond = true,
		opts = require("config.lsp.mason_lspconfig").opts,
		build = function(opts)
			require("mason").setup(opts)
			vim.cmd(":MasonUpdate")
		end,
		dependencies = {
			{ "mason-org/mason.nvim", opts = require("config.lsp.mason").opts },
			{ "neovim/nvim-lspconfig", keys = require("config.lsp.lspconfig").keymaps },
		},
	},
	{
		"ray-x/lsp_signature.nvim",
		cond = false,
		event = "InsertEnter",
		opts = conf.opts,
		keys = conf.keys,
		config = function()
			require("lsp_signature").setup(conf.opts)
			-- require("lsp_signature").on_attach(conf.on_attach
		end,
	},
	{
		"VidocqH/lsp-lens.nvim",
		lazy = true,
		cond = false,
		priprity = 50,
		-- event = "BufReadPost",
		opts = {
			enable = true,
			include_declaration = false, -- Reference include declaration
			sections = { -- Enable / Disable specific request, formatter example looks 'Format Requests'
				definition = false,
				references = true,
				implements = true,
				git_authors = true,
			},
			ignore_filetype = {
				"prisma",
			},
		},
		{
			"nvimdev/lspsaga.nvim",
			-- event = "BufReadPost",
			event = "LspAttach",
			lazy = true,
			dependencies = {
				"mason-org/mason-lspconfig.nvim",
				"nvim-treesitter/nvim-treesitter", -- optional
				"nvim-tree/nvim-web-devicons", -- optional
			},
			keys = lspsaga.keys,
			opts = lspsaga.opts,
		},
	},
}
