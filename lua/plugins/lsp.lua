local lspsaga = require("config.lsp.lspsaga")
local lsp_signature = require("config.lsp.lsp_signature")

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
			{ "neovim/nvim-lspconfig", event = "VeryLazy", keys = require("config.lsp.lspconfig").keymaps },
		},
	},
	{
		"ray-x/lsp_signature.nvim",
		cond = true,
		event = "InsertEnter",
		opts = lsp_signature.opts,
		-- keys = lsp_signature.keys,
		config = function()
			require("lsp_signature").setup(lsp_signature.opts)
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
	},
	{
		"nvimdev/lspsaga.nvim",
		event = "LspAttach",
		lazy = true,
		dependencies = {
			"mason-org/mason-lspconfig.nvim",
			"nvim-treesitter/nvim-treesitter", -- optional
			"nvim-tree/nvim-web-devicons", -- optional
		},
		keys = lspsaga.keys,
		config = function()
			require("lspsaga").setup(require("config.lsp.lspsaga").opts)
			-- vim.api.nvim_create_autocmd("ColorScheme", {
			-- 	callback = function()
			-- 		local bg = vim.api.nvim_get_hl(0, { name = "NormalFloat", link = false }).bg
			-- 			or vim.api.nvim_get_hl(0, { name = "Normal", link = false }).bg
			--
			-- 		vim.api.nvim_set_hl(0, "HoverBorder", { fg = bg, bg = bg })
			-- 	end,
			-- })
		end,
	},
	{
		"stevearc/aerial.nvim",
		keys = {
			{ "<leader>ll", "<cmd>AerialToggle!<CR>", mode = "n", desc = "Toggle LSP Outline" },
		},
		opts = {
			{
				layout = {
					max_width = { 40, 0.2 },
					width = 30,
					min_width = 30,
					placement = "right",
					default_direction = "prefer_right",
				},

				attach_mode = "window",
				highlight_on_hover = true,
				autojump = false,

				keymaps = {
					["?"] = "actions.show_help",
					["g?"] = "actions.show_help",
					["<CR>"] = "actions.jump",
					["e"] = "actions.jump",
					["o"] = "actions.tree_toggle",
					["v"] = "actions.jump_vsplit",
					["s"] = "actions.jump_split",
					["q"] = "actions.close",
					["<Esc>"] = "actions.close",
				},

				icons = {},
			},
		},
		-- Optional dependencies
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
	},
	{
		"seblyng/roslyn.nvim",
		enabled = false,
		---@module 'roslyn.config'
		---@type RoslynNvimConfig
		opts = {
			-- your configuration comes here; leave empty for default settings
		},
	},
	{
		"Sunrisepeak/mcpp-language-server",
		event = "User ProjectEnter mcpp.toml",
		cond = true,
		config = function(plugin)
			vim.opt.rtp:append(plugin.dir .. "/editors/nvim")
			require("mcppls").setup({
			-- Automatically stop clangd/ccls on buffers mcppls also serves
				disable_conflicting = true,
				detect_conflicts = true,
				semantic_tokens_modules = true,

				init_options = {
					-- Limit background workers to prevent maxing out CPU cores
					["engine.workers"] = "2",

					-- Disable aggressive background implementation indexing to save CPU
					["index.primeImplementationUnits"] = "off",

					-- Keep preambles in memory if possible to avoid disk I/O churn
					["engine.preambleStorage"] = "memory",

					-- Keep build tool execution offline
					buildTool = "offline",

					-- Prevent space from triggering unnecessary completion RPC requests
					completion = {
						triggerOnSpace = false,
					},
				},
			})
		end,
	},
}
