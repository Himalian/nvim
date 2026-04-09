local M = {}

function M.setup()
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
	vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Show infomation" })
	vim.keymap.set("n", "gI", vim.lsp.buf.implementation, { desc = "Go to implementation" })
	-- vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, { desc = "Show help" })
	vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition)
	vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename" })
	vim.keymap.set("n", "gR", vim.lsp.buf.references)

	vim.keymap.set("i", "<C-i>", require("lsp_signature").toggle_float_win, { desc = "Toggle Signature Help" })

	vim.keymap.set("n", "<leader>ih", function()
		if not vim.lsp.inlay_hint.is_enabled() then
			vim.lsp.inlay_hint.enable(true)
			vim.print("Inlay hint enabled")
		else
			vim.lsp.inlay_hint.enable(false)
			vim.print("Inlay hint disabled")
		end
	end, { desc = "Toggle inlay_hint" })
end
return M
