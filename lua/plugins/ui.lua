return {
	-- using lazy.nvim
	{
		"akinsho/bufferline.nvim",
		-- name = "BuffefLine",
		dependencies = "nvim-tree/nvim-web-devicons",
		-- event = "VeryLazy",
		init = function()
			require("bufferline").setup({})
		end,
		opts = {
			options = {
				hover = {
					enabled = true,
					delay = 150,
					reveal = { "close" },
				},
				highlights = {
					fill = {
						bg = {
							attribute = "fg",
							highlight = "Pmenu",
						},
					},
				},
				-- sepatarot_style=""
			},
		},
		keys = {
			{ "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle pin" },
			{ "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete non-pinned buffers" },
			{ "<leader>bo", "<Cmd>BufferLineCloseOthers<CR>", desc = "Delete other buffers" },
			{ "<leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete buffers to the right" },
			{ "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete buffers to the left" },
			{ "<leader>bc", "<Cmd>bw<CR>", desc = "Delete current buffer" },
			{ "<leader>ba", "<Cmd>BufferLineCloseOthers<CR><cmd>bw<CR>", desc = "Delete all buffers" },
			{ "<C-S-Tab>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev buffer" },
			{ "<C-Tab>", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
			{ "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev buffer" },
			{ "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
		},
	},
	{
		"nvim-lualine/lualine.nvim",
		priority = 100,
		-- event = "VeryLazy",
		init = function()
			vim.g.lualine_laststatus = vim.o.laststatus
			if vim.fn.argc(-1) > 0 then
				-- set an empty statusline till lualine loads
				vim.o.statusline = " "
			else
				-- hide the statusline on the starter page
				vim.o.laststatus = 0
			end
		end,
		opts = require("config.colorshemes.lualine").opts,
	},
	{
		"equalsraf/neovim-gui-shim",
		-- lazy = true,
	},
	{
		"lewis6991/gitsigns.nvim",
		event = "User ProjectEnter .git",
		opts = {
			signs = {
				add = { text = "│" },
				change = { text = "│" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
				untracked = { text = "┆" },
			},
			signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
			numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
			linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
			word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
			watch_gitdir = {
				follow_files = true,
			},
			auto_attach = true,
			attach_to_untracked = false,
			current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
			current_line_blame_opts = {
				virt_text = true,
				virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
				delay = 1000,
				ignore_whitespace = false,
				virt_text_priority = 100,
			},
			current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
			sign_priority = 6,
			update_debounce = 100,
			status_formatter = nil, -- Use default
			max_file_length = 40000, -- Disable if file is longer than this (in lines)
			preview_config = {
				-- Options passed to nvim_open_win
				border = "single",
				style = "minimal",
				relative = "cursor",
				row = 0,
				col = 1,
			},
			-- yadm                         = {
			-- 	enable = false
			-- },
		},
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		event = "VeryLazy",
		--@module "ibl"
		--@type ibl.config
		opts = {},
	},
	{
		"goolord/alpha-nvim",
		dependencies = {
			"echasnovski/mini.icons",
			"nvim-lua/plenary.nvim",
		},
		config = function()
			require("alpha").setup(require("alpha.themes.theta").config)
		end,
	},
	{
		"nvchad/menu",
		dependencies = {
			"nvchad/base46",
			"nvchad/ui",
			"nvchad/volt",
		},
		lazy = true,
		-- config = function()
		-- 	-- Keyboard users
		-- 	vim.keymap.set("n", "<C-t>", function()
		-- 		require("menu").open("default")
		-- 	end, {})
		--
		-- 	-- mouse users + nvimtree users!
		-- 	vim.keymap.set("n", "<RightMouse>", function()
		-- 		vim.cmd.exec '"normal! \\<RightMouse>"'
		--
		-- 		local options = vim.bo.ft == "NvimTree" and "nvimtree" or "default"
		-- 		require("menu").open(options, { mouse = true })
		-- 	end, {})
		-- end,
		-- keys = {
		-- 	{ "n", "<C-t>", function() require("menu").open("default") end },
		-- 	{ "n", "<RightMouse>", function()
		-- 		vim.cmd.exec '"normal! \\<RightMouse>"'
		--
		-- 		local options = vim.bo.ft == "NvimTree" and "nvimtree" or "default"
		-- 		require("menu").open(options, { mouse = true })
		-- 	end },
		-- }
	},
	{
		"rcarriga/nvim-notify",
		desc = "Better notice showing UI",
		lazy = true,
		-- event = "VeryLazy"
	},
	{
		"numirias/semshi",
		cond = false,
		desc = "Provide a better highlight for Python",
		ft = "python",
		lazy = true,
		build = ":UpdateRemotePlugins",
		dependencies = {
			{ "neovim/pynvim" },
		},
	},
	{
		"nvim-tree/nvim-web-devicons",
		desc = "A plugin to show icons",
		lazy = true,
		opts = {
			override = {
				zsh = {
					icon = "",
					color = "#428850",
					cterm_color = "65",
					name = "Zsh",
				},
				go = {
					icon = "",
					name = "Go",
					cterm_color = 74,
					color = "#519aba",
				},
				ts = {
					icon = "",
					name = "Typescript",
					cterm_color = 74,
					color = "#519aba",
				},
				dart = {
					icon = "",
					name = "Dart",
					color = "#38bdf8",
					cterm_color = 74,
				},
				cs = {
					icon = "󰌛",
					name = "Cs",
					color = "#7355dd",
					cterm_color = 56
				}

			},
		},
	},
}
