--- custon.lua
---
--- load custom configurations on startup
-- vim.o.guifont = vim.env.NVIM_GUI_FONT
vim.o.guifontwide = vim.env.NVIM_GUI_FONT_WIDE

-- Shell settings
if vim.env.PWSH == "true" or vim.env.SHELL == "pwsh" then
	vim.o.shell = vim.fn.executable("pwsh") == 1 and "pwsh" or "powershell"
	vim.o.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command "
		.. "[Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();"
		.. " $PSStyle.OutputRendering = 'PlainText' "
	-- .. "$PSDefaultParameterValues['Out-File:Encoding]=UTF8;"

	vim.o.shellredir = "2>&1 | Out-File -Encoding UTF8 %s"
	vim.o.shellpipe = "2>&1 | Out-File -Encoding UTF8 %s"
	vim.o.shellquote = ""
	vim.o.shellxquote = ""
elseif vim.env.NU == "true" or vim.env.SHELL == "nu" then
	vim.o.shell = vim.fn.executable("nu") == 1 and "nu" or vim.env.SHELL
	vim.o.shellcmdflag = "-c"
	vim.o.shellquote = ""
	vim.o.shellxquote = ""
	-- nushell doesn't support direct redirection via shellredir/shellpipe, fallback to default
else
	vim.o.shell = vim.env.SHELL
end

vim.filetype.add({
	extension = {
		dae = "dae",
	},
	vim.api.nvim_create_autocmd("TermOpen", {
		group = vim.api.nvim_create_augroup("custom-terminal-keymaps", { clear = true }),
		callback = function()
			-- Disable leader keymaps in terminal
			vim.keymap.set("t", "<space>", "<space>", { buffer = true, nowait = true })
		end,
	}),
})
