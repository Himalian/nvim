local languages = {
	"c",
	"python",
	"lua",
	"vim",
	"vimdoc",
	"javascript",
	"html",
	"nu",
	"nix",
}
return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = true,
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter").install(languages)

			require("nvim-treesitter").setup({
				highlight = { enable = true },
				indent = { enable = true },
			})

			-- Enable highlighting per filetype (no longer automatic)
			vim.api.nvim_create_autocmd("FileType", {
				pattern = languages,
				callback = function()
					vim.treesitter.start()
				end,
			})

			-- Native incremental selection (replaces plugin module)
			vim.keymap.set("n", "<CR>", function()
				vim.cmd("normal! v")
				vim.treesitter.incremental_selection()
			end)
			vim.keymap.set("x", "<CR>", function()
				vim.treesitter.incremental_selection()
			end)
			vim.keymap.set("x", "<S-CR>", function()
				vim.treesitter.incremental_selection(-1)
			end)
		end,
	},
}
