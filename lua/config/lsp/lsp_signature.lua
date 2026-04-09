local M = {}

M.keys = {
	{
		mode = "i",
		"<C-i>",
		function()
			-- require("lsp_signature").toggle_float_win()
			M.toggle_float_win()
		end,
		{ silent = true, noremap = true, desc = "Toggle signature" },
	},
	{
		mode = "n",
		"<leader>if",
		function()
			-- require("lsp_signature").toggle_float_win()
			M.toggle_float_win()
		end,
		desc = "Toggle signature",
		{ silent = true, noremap = true, desc = "Toggle signature" },
	},
}

M.blacklist = {}

function M.setup(_, opts)
	vim.api.nvim_create_autocmd("LspAttach", {
		callback = function(args)
			local bufnr = args.buf
			local client = vim.lsp.get_client_by_id(args.data.client_id)
			if not client then
				return
			end
			local blacklist = {} -- blacklist
			if vim.tbl_contains(blacklist, client.name) then
				return
			end
			require("lsp_signature").on_attach(opts, bufnr)
		end,
	})
end

function M.toggle_float_win()
	if M.opts.floating_window then
		M.opts.floating_window = false
	else
		M.opts.floating_window = true
	end
end
M.opts = {
	bind = true,
	floating_window = false,
	hint_enable = true,
	hint_prefix = "",
	-- hint_prefix = "󰌶 ",

	--- @type "String" | "Comment"
	hint_scheme = "Comment",
	hi_parameter = "Search",
	handler_opts = {
		border = "rounded",
	},
	always_trigger = true,
	update_on_insert = true,
	check_completion_visible = true,
	max_width = 80,
	wrap = true,
	select_signature_key = "<M-n>",
}

return M
