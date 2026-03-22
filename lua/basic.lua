-- Hint: use `:h <option>` to figure out the meaning if needed
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.mouse = "a" -- allow the mouse to be used in Nvim
vim.g.mapleader = " "

-- Tab options
vim.opt.tabstop = 4 -- number of visual spaces per TAB
vim.opt.softtabstop = 4 -- number of spacesin tab when editing
vim.opt.shiftwidth = 4 -- insert 4 spaces on a tab
vim.opt.expandtab = false -- tabs are spaces, mainly because of python
-- Tab options for python
vim.api.nvim_create_autocmd("FileType", {
	pattern = "python",
	callback = function()
		vim.opt_local.tabstop = 4
		vim.opt_local.shiftwidth = 4
		vim.opt_local.expandtab = false
	end,
})

-- UI config
vim.opt.number = true -- show absolute number
--vim.opt.relativenumber = true 相对行号
vim.opt.cursorline = true -- highlight cursor line underneath the cursor horizontally
vim.opt.splitbelow = true -- open new vertical split bottom
vim.opt.splitright = true -- open new horizontal splits right
-- vim.opt.termguicolors = true        -- enabl 24-bit RGB color in the TUI
vim.opt.showmode = false -- we are experienced, wo don't need the "-- INSERT --" mode hint

-- Searching
vim.opt.incsearch = true -- search as characters are entered
vim.opt.hlsearch = false -- do not highlight matches
vim.opt.ignorecase = true -- ignore case in searches by default
vim.opt.smartcase = true -- but make it case sensitive if an uppercase is entered
-- map = vim.keymap.set
-- leader
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- 关闭Swap文件
--vim.opt.noswapfile = true
vim.opt.swapfile = true

--autoreload
vim.o.autoread = true
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
	command = "if mode() != 'c' | checktime | endif",
	pattern = { "*" },
})
vim.diagnostic.config({ update_in_insert = true }) -- 插入模式下启用代码诊断
--鼠标事件
vim.opt.mouse = "a"

-- session options
vim.o.sessionoptions = "buffers,curdir,folds,globals,tabpages,winpos,winsize"
--自动换行设置
vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function()
		vim.bo.formatoptions = vim.bo.formatoptions .. "ro"
	end,
})

-- Neovim clipboar config
vim.opt.clipboard = "unnamedplus"

if vim.fn.has("unix") == 1 then
	local clipboard_config = {}

	-- order of unix: WSL > Linux+Wayland > Linux+X11 > macOS
	if vim.fn.has("wsl") == 1 and vim.fn.executable("win32yank.exe") == 1 then
		-- WSL
		clipboard_config = {
			name = "win32yank-wsl",
			copy = {
				["+"] = "win32yank.exe -i --crlf",
				["*"] = "win32yank.exe -i --crlf",
			},
			paste = {
				["+"] = "win32yank.exe -o --lf",
				["*"] = "win32yank.exe -o --lf",
			},
		}
	elseif vim.fn.executable("wl-copy") == 1 and os.getenv("WAYLAND_DISPLAY") then
		-- Linux + Wayland
		clipboard_config = {
			name = "wl-clipboard",
			copy = {
				["+"] = "wl-copy",
				["*"] = "wl-copy --primary",
			},
			paste = {
				["+"] = "wl-paste",
				["*"] = "wl-paste --primary",
			},
		}
	elseif vim.fn.executable("xclip") == 1 then
		-- Linux + X11
		clipboard_config = {
			name = "xclip",
			copy = {
				["+"] = "xclip -selection clipboard",
				["*"] = "xclip -selection primary",
			},
			paste = {
				["+"] = "xclip -selection clipboard -o",
				["*"] = "xclip -selection primary -o",
			},
		}
	elseif vim.fn.has("mac") == 1 then
		-- macOS
		clipboard_config = {
			name = "pbcopy/pbpaste",
			copy = {
				["+"] = "pbcopy",
				["*"] = "pbcopy",
			},
			paste = {
				["+"] = "pbpaste",
				["*"] = "pbpaste",
			},
		}
	end

	if next(clipboard_config) ~= nil then
		vim.g.clipboard = clipboard_config
	end
end

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		-- 检查 LSP 是否支持 hover
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client ~= nil and client:supports_method("textDocument/hover") then
			vim.keymap.set("n", "K", function()
				vim.lsp.buf.hover({
					--- @type 'rounded' | 'solid' | 'none' | 'bold' | 'double' | 'none' | 'shadow' | 'single'
					border = "solid",
				})
			end, { buffer = args.buf, desc = "Hover documentation" })
		end
	end,
})
