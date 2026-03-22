--- indent.lua
--- indent settings include toggle_indent and format_indent
--- toggle_indent: toggle between Tabs and Spaces
--- format_indent: format file indentation to match current settings (Tabs or Spaces)
--- About expandtab(`:h expandtab`):
--- 'expandtab' 'et'	boolean	(default off)
-- 		local to buffer
-- In Insert mode: Use the appropriate number of spaces to insert a
-- <Tab>.  Spaces are used in indents with the '>' and '<' commands and
-- when 'autoindent' is on.  To insert a real tab when 'expandtab' is
-- on, use CTRL-V<Tab>.  See also |:retab| and |ins-expandtab|.
--

--- toggle indentation between Tabs and Spaces
local function toggle_indent()
	if vim.opt.expandtab:get() then
		vim.opt.expandtab = false
		vim.opt.tabstop = 4
		vim.opt.shiftwidth = 4
		vim.notify("Set indent to Tabs", vim.log.levels.INFO)
	else
		vim.opt.expandtab = true
		vim.opt.tabstop = 4
		vim.opt.shiftwidth = 4
		vim.notify("Set indent to Spaces", vim.log.levels.INFO)
	end
end

--- format file indentation to match current settings (Tabs or Spaces)
local function format_indent()
	if vim.opt.expandtab:get() then
		vim.cmd("%retab!")
		vim.notify("Formatted indentation to Spaces", vim.log.levels.INFO)
	else
		vim.cmd("%retab!")
		vim.notify("Formatted indentation to Tabs", vim.log.levels.INFO)
	end
end

local function indent_status()
	if vim.opt.expandtab:get() then
		vim.notify("Indentation status: Using Spaces")
	else
		vim.notify("Indentation status: Using Tabs")
	end
end

vim.api.nvim_create_user_command("ToggleIndent", toggle_indent, {
	desc = "Toggle between Tab and Space indentation",
})

vim.api.nvim_create_user_command("FormatIndent", format_indent, {
	desc = "Format indentation to match current settings (Tabs or Spaces)",
})
vim.api.nvim_create_user_command("IndentStatus", indent_status, {
	desc = "Format indentation to match current settings (Tabs or Spaces)",
})
