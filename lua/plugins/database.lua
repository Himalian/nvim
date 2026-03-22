return {
	{
		"kndndrj/nvim-dbee",
		cond = false,
		lazy = true,
		cmd = "Dbee",
		dependencies = {
			"MunifTanjim/nui.nvim",
			{
				"MattiasMTS/cmp-dbee",
				-- cond = false,
				ft = "sql", -- optional but good to have
				opts = {}, -- needed
			},
		},
		keys = {
			{ mode = "n", "<leader>dbe", ":Dbee<CR>" },
		},
		build = function()
			-- Install tries to automatically detect the install method.
			-- if it fails, try calling it with one of these parameters:
			--    "curl", "wget", "bitsadmin", "go"
			require("dbee").install("cgo")
		end,
		config = function()
			require("dbee").setup(--[[optional config]])
		end,
	},

	{
		"kristijanhusak/vim-dadbod-ui",
		url = "https://github.com/Doekeb/vim-dadbod-ui",
		enabled = true,
		dependencies = {
			{
				"tpope/vim-dadbod",
				lazy = true,
				url = "https://github.com/Doekeb/vim-dadbod", -- for early duckdb support
			},
			{
				"kristijanhusak/vim-dadbod-completion",
				url = "https://github.com/Doekeb/vim-dadbod-completion",
				ft = { "sql", "mysql", "plsql" },
				lazy = true,
			},
		},
		cmd = {
			"DBUI",
			"DBUIToggle",
			"DBUIAddConnection",
			"DBUIFindBuffer",
		},
		init = function()
			-- Your DBUI configuration
			vim.g.db_ui_use_nerd_fonts = 1
		end,
	},
}
