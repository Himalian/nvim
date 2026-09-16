local M = {}
-- 记录已被拦截处理过的 LSP Client，避免往 vim.lsp.Client 结构注入私有字段导致 inject-field 警告
local intercepted_clients = setmetatable({}, { __mode = "k" })

--- 将全文件的 0-based UTF-16 绝对字符偏移量 (caretOffset) 转换为 Neovim 的 (lnum, byte_col)
---@param bufnr integer
---@param offset integer 0-indexed UTF-16 文件绝对偏移量
---@return integer, integer 1-indexed 行号, 0-indexed 字节列号
local function offset_to_position(bufnr, offset)
	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
	local eol_len = (vim.bo[bufnr].fileformat == "dos") and 2 or 1
	local current_offset = 0

	for lnum, line in ipairs(lines) do
		---@diagnostic disable-next-line: param-type-mismatch
		local _, utf16_len = vim.str_utfindex(line, #line)
		local line_total = utf16_len + eol_len

		if current_offset + line_total > offset or lnum == #lines then
			---@type integer | nil
			local line_offset = offset - current_offset
			if line_offset < 0 then
				line_offset = 0
			elseif line_offset > utf16_len then
				line_offset = utf16_len
			end
			-- 将 UTF-16 列偏移换算为 Neovim API 识别的字节偏移
			---@diagnostic disable-next-line: param-type-mismatch
			local byte_col = (vim.str_byteindex(line, line_offset, true) or 0)
			---@cast byte_col integer
			return lnum, byte_col
		end
		current_offset = current_offset + line_total
	end

	local last_line = lines[#lines] or ""
	return #lines, #last_line
end

--- 处理 Roslyn completionComplexEdit 指令
---@param args any[]?
---@param client vim.lsp.Client?
local function handle_roslyn_complex_edit(args, client)
	if not args or #args < 2 then
		return
	end

	local doc = args[1]
	local edit = args[2]
	---@cast edit lsp.TextEdit
	local is_snippet = args[3]
	local caret_offset = args[4] -- Roslyn 期望的目标光标偏移量

	if not (doc and doc.uri and edit and edit.range and edit.newText) then
		return
	end

	local target_buf = vim.uri_to_bufnr(doc.uri)
	if not vim.api.nvim_buf_is_loaded(target_buf) then
		vim.fn.bufload(target_buf)
	end

	local offset_encoding = client and client.offset_encoding or "utf-16"

	-- 1. 替换文本或展开 Snippet
	if is_snippet and vim.snippet then
		vim.lsp.util.apply_text_edits({ { range = edit.range, newText = "" } }, target_buf, offset_encoding)
		vim.snippet.expand(edit.newText)
	else
		vim.lsp.util.apply_text_edits({ edit }, target_buf, offset_encoding)
	end

	-- 2. 重定位光标至 Roslyn 指定坐标
	if type(caret_offset) == "number" then
		local function set_cursor()
			local win = vim.api.nvim_get_current_win()
			if vim.api.nvim_win_get_buf(win) == target_buf then
				local lnum, col = offset_to_position(target_buf, caret_offset)
				pcall(vim.api.nvim_win_set_cursor, win, { lnum, col })
			end
		end

		set_cursor()
		-- 延迟一帧避开补全引擎退出补全菜单时的光标复位钩子
		vim.schedule(set_cursor)
	end
end

function M.setup()
	-- 全局注册兜底：兼容由 client:exec_cmd 或 vim.lsp.buf.execute_command 分发的调用
	vim.lsp.commands["roslyn.client.completionComplexEdit"] = function(command, ctx)
		local client = ctx and ctx.client_id and vim.lsp.get_client_by_id(ctx.client_id)
		handle_roslyn_complex_edit(command.arguments, client)
	end

	vim.api.nvim_create_autocmd("LspAttach", {
		desc = "Intercept Roslyn private client commands",
		callback = function(args)
			local client = vim.lsp.get_client_by_id(args.data.client_id)
			if not client or not client.name:match("roslyn") then
				return
			end

			-- 防止重复包装 client.request
			if intercepted_clients[client] then
				return
			end
			intercepted_clients[client] = true

			local orig_request = client.request
			---@diagnostic disable-next-line: duplicate-set-field
			client.request = function(self, method, params, handler, bufnr)
				-- 兼容处理 client:request(...) 和 client.request(...) 两种调用习惯
				if type(self) == "string" then
					bufnr = handler
					handler = params
					params = method
					method = self
					self = client
				end

				if
					method == "workspace/executeCommand"
					and params
					and params.command == "roslyn.client.completionComplexEdit"
				then
					handle_roslyn_complex_edit(params.arguments, client)

					-- 正常回调成功以满足补全插件的就绪状态
					if handler then
						---@diagnostic disable-next-line: missing-parameter
						handler(nil, vim.NIL)
					end
					return true, nil
				end

				---@diagnostic disable-next-line: param-type-mismatch
				return orig_request(self, method, params, handler, bufnr)
			end
		end,
	})
end
return M
