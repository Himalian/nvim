local M = {}
local snacks = require("snacks")

function M.setup()
	vim.keymap.set("n", "gD", snacks.picker.lsp_declarations, { desc = "Go to declaration" })
	vim.keymap.set("n", "gd", snacks.picker.lsp_definitions, { desc = "Go to definition" })
	vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Show infomation" })
	vim.keymap.set("n", "gI", snacks.picker.lsp_implementations, { desc = "Go to implementation" })
	vim.keymap.set("n", "gR", snacks.picker.lsp_references, { desc = "View references" })

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

	vim.keymap.set("n", "<leader>lr", function()
		vim.cmd("lsp restart")
	end, { desc = "Restart lsp server" })
end
return M
