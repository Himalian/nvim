return {
	"saghen/blink.cmp",
	cond = true,
	dependencies = {
		"rafamadriz/friendly-snippets",
		"onsails/lspkind.nvim",
		"xzbdmw/colorful-menu.nvim",
	},
	version = "1.*",

	opts = {
		enabled = function()
			return vim.fn.mode() == "c"
		end,
		cmdline = {
			keymap = {
				["<Tab>"] = { "show", "accept" },
			},
			completion = {
				menu = {
					auto_show = true,
				},
			},
		},
	},
}
