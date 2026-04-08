return {
	{
		"olimorris/persisted.nvim",
		lazy = false,
		dependencies = { "nvim-telescope/telescope.nvim" },
		opts = {
			autostart = true,
			autoload = false,
			autosave = true,
			save_dir = vim.fn.stdpath("data") .. "/persisted/sessions/",
			use_git_branch = false,
		},
		config = function(_, opts)
			require("persisted").setup(opts)
			require("telescope").load_extension("persisted")
		end,
		keys = {
			{ "<leader>qs", "<cmd>Persisted load<CR>", desc = "Load session for current directory" },
			{ "<leader>qS", "<cmd>Persisted select<CR>", desc = "Select session to load" },
			{ "<leader>ql", "<cmd>Persisted load_last<CR>", desc = "Load last session" },
			{ "<leader>qw", "<cmd>Persisted save<CR>", desc = "Save current session" },
			{ "<leader>qd", "<cmd>Persisted delete<CR>", desc = "Delete current session" },
			{ "<leader>fs", "<cmd>Telescope persisted<CR>", desc = "Telescope find sessions" },
		},
	},
	{
		"folke/persistence.nvim",
		event = "BufReadPre", -- this will only start session saving when an actual file was opened
		enabled = false,
		opts = {
			-- add any custom options here
			{
				dir = vim.fn.stdpath("state") .. "persistence/sessions/", -- directory where session files are saved
				-- minimum number of file buffers that need to be open to save
				-- Set to 0 to always save
				need = 1,
				branch = true, -- use git branch to save session
			},
		},
		keys = {
			{
				"<leader>qs",
				function()
					require("persistence").load()
				end,
				desc = "Load session for the current directory",
			},
			{
				"<leader>qS",
				function()
					require("persistence").select()
				end,
				desc = "Select a session to load",
			},
			{
				"<leader>ql",
				function()
					require("persistence").load({ last = true })
				end,
				desc = "Load the last session",
			},
			{
				"<leader>qd",
				function()
					require("persistence").stop()
				end,
				desc = "Stop persistence (don't save on exit)",
			},
			-- { "<leader>qd", function() require("persistence").select end,                desc = "Stop persistence (don't save on exit)" },
		},
	},
}
