--- custon.lua
---
--- load custom configurations on startup
-- vim.o.guifont = vim.env.NVIM_GUI_FONT
vim.o.guifontwide = vim.env.NVIM_GUI_FONT_WIDE

-- Shell settings
if vim.env.PWSH == "true" then
	vim.o.shell = vim.fn.executable("pwsh") == 1 and "pwsh" or "powershell"
	vim.o.shellcmdflag =
		"-NoLogo -NonInteractive -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new(); $PSDefaultParameterValues['Out-File:Encoding']='utf8'; $PSStyle.OutputRendering='plaintext'; Remove-Alias -Force -ErrorAction SilentlyContinue tee;"
	vim.o.shellredir = "2>&1 | ForEach-Object { '$_' } | Out-File %s; exit $LastExitCode"
	vim.o.shellpipe = "2>&1 | ForEach-Object { '$_' } | Tee-Object %s; exit $LastExitCode"
	vim.o.shellquote = ""
	vim.o.shellxquote = ""
elseif vim.env.NU == "true" then
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
