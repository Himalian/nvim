---@return string
local function get_shell()
	if vim.o.shell == "pwsh" then
		local cmd = "pwsh" .. " -NoLogo -ExecutionPolicy RemoteSigned"
		return cmd
	elseif vim.o.shell == "powershell" then
		local cmd = "powershell" .. " -NoLogo -ExecutionPolicy RemoteSigned"
		return cmd
	else
		return vim.o.shell
	end
end
return {
	{
		"folke/snacks.nvim",
		priority = 1000,
		-- 不需要 lazy = true 和 event = "VeryLazy"，除非有特殊需求
		-- 使用 keys 字段来定义快捷键更符合 lazy.nvim 的最佳实践
		keys = {
			{
				"<leader>ps",
				function()
					require("snacks").profiler.scratch()
				end,
				desc = "Profiler Scratch Buffer",
			},
			-- 可以添加其他官方推荐的快捷键
			{
				"<leader>pp",
				function()
					require("snacks").toggle.profiler()
				end,
				desc = "Toggle Profiler",
			},
			{
				"<leader>ph",
				function()
					require("snacks").toggle.profiler_highlights()
				end,
				desc = "Toggle Profiler Highlights",
			},
			{
				"<leader>gg",
				function()
					require("snacks").lazygit.open()
				end,
				desc = "Open Lazygit",
			},
			{
				"<leader>tt",
				function()
					local cmd = get_shell()
					require("snacks").terminal.toggle(cmd, {
						win = { position = "bottom" },
					})
				end,
				desc = "Toggle Terminal",
			},
			{
				"<leader>gd",
				function ()
					require("snacks").picker.lsp_definitions()
				end
			}
		},
		opts = {
			-- 你的配置选项
			terminal = {
				enabled = true,
				{
					bo = {
						filetype = "terminal",
					},
					wo = {},
					keys = {
						q = "hide",
						gf = function(self)
							local f = vim.fn.findfile(vim.fn.expand("<cfile>"), "**")
							if f == "" then
								Snacks.notify.warn("No file under cursor")
							else
								self:hide()
								vim.schedule(function()
									vim.cmd("e " .. f)
								end)
							end
						end,
						term_normal = {
							"<esc>",
							function(self)
								self.esc_timer = self.esc_timer or vim.uv.new_timer()
								if self.esc_timer:is_active() then
									self.esc_timer:stop()
									vim.cmd("stopinsert")
								else
									self.esc_timer:start(200, 0, function() end)
									return "<esc>"
								end
							end,
							mode = "t",
							expr = true,
							desc = "Double escape to normal mode",
						},
					},
				},
			},
			dim = { enabled = true },
			lazygit = {
				enabled = true,
				term_normal = false,
			},
			profiler = {
				icons = {
					time = " ",
					pct = " ",
					count = " ",
					require = "󰋺 ",
					modname = "󰆼 ",
					plugin = " ",
					autocmd = "⚡",
					file = " ",
					fn = "󰊕 ",
					status = "󰈸 ",
				},
				globals = {
					"vim",
					"vim.api",
					"vim.keymap",
					-- "Snacks.dashboard.Dashboard",
				},
				enabled = true,
				-- notify = true,
				-- -- map = vim.keymap.set,
				-- which_key = true,
			},
			toggle = {
				enabled = true,
				map = vim.keymap.set,
				which_key = true,
				notify = true,
			},
		},
	},
}
-- 	{
-- 		"nvim-lualine/lualine.nvim",
-- 		cond = false,
-- 		priority = 2,
-- 		opts = function(_, opts)
-- 			table.insert(opts.sections.lualine_x, Snacks.profiler.status())
-- 		end,
-- 	}
-- }
