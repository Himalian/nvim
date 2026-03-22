local M = {}
M.opts = {
	ui = {},
	code_action = {
		num_shortcut = true,
		show_server_name = false,
		extend_gitsigns = false,
		only_in_cursor = true,
		max_height = 0.3,
		cursorline = true,
		keys = {
			quit = "q",
			exec = "<CR>",
		},
	},
	outline = {
		detail = false,
	},
	lightbulb = {
		enable = false,
		sign = true,
		debounce = 10,
		sign_priority = 40,
		virtual_text = true,
		enable_in_insert = false,
		ignore = {
			clients = {},
			ft = {},
		},
	},
}
M.keys = {
	{ "ga", "<cmd>Lspsaga code_action<CR>", mode = "n", desc = "Code Action" },
	{ "gr", "<cmd>Lspsaga rename<CR>", mode = "n", desc = "Rename" },
	{ "<f2>", "<cmd>Lspsaga rename<CR>", mode = "n", desc = "Rename" },
	-- { "<leader>l", "<cmd>Lspsaga outline<CR>", mode = { "n" }, desc = "Open outline" },
}
return M
