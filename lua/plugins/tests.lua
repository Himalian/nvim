return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter",
		"arthur944/neotest-bun",
	},
	config = function()
		require("neotest").setup({
			adapters = {
				require("neotest-bun"),
			},
		})

		vim.api.nvim_create_user_command("NeotestRunAtCursor", function()
			require("neotest").run.run()
		end, {})

		vim.api.nvim_create_user_command("NeotestRunProject", function()
			require("neotest").run.run(vim.uv.cwd())
		end, {})

		vim.api.nvim_create_user_command("NeotestWatch", function()
			require("neotest").watch.toggle()
		end, {})

		vim.api.nvim_create_user_command("NeotestFile", function()
			require("neotest").run.run(vim.fn.expand("%"))
		end, {})

		vim.api.nvim_create_user_command("NeotestSummary", function()
			require("neotest").summary.toggle()
		end, {})

		vim.api.nvim_create_user_command("NeotestOutput", function()
			require("neotest").output_panel.toggle()
		end, {})
	end,
}
