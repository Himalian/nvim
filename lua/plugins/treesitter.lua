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
				pattern = "*",
				callback = function(args)
					if vim.bo[args.buf].buftype ~= "" or vim.bo[args.buf].filetype == "" then
						return
					end

					local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
					if not lang then
						return
					end

					-- ignore errors
					pcall(vim.treesitter.start, args.buf, lang)
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
