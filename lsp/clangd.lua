local function has_mcpp(bufnr)
	-- 检查当前工作目录
	if vim.uv.fs_stat(vim.fs.joinpath(vim.fn.getcwd(), "mcpp.toml")) ~= nil then
		return true
	end
	-- 向上检索 buffer 所在的各级父目录
	if bufnr and bufnr > 0 and vim.fs.root(bufnr, { "mcpp.toml" }) ~= nil then
		return true
	end
	return false
end

vim.api.nvim_create_user_command("ClangdEnable", function()
	local bufnr = vim.api.nvim_get_current_buf()
	vim.b[bufnr].enable_clangd = true
	vim.lsp.start(vim.lsp.config.clangd, { bufnr = bufnr })
end, { desc = "Manually start clangd for current buffer in mcpp project" })

return {
	name = "clangd",
	cmd = { "clangd" },
	filetypes = { "cpp", "c", "h", "hpp" },
	offsetEncoding = { "utf-8" },

	-- 关键：禁用上游默认的 root_markers，防止其回退命中 .git 导致自动启动
	root_markers = false,

	root_dir = function(bufnr, on_dir)
		local root = (
			bufnr
			and vim.fs.root(bufnr, {
				".clangd",
				".clang-tidy",
				".clang-format",
				"compile_commands.json",
				"compile_flags.txt",
				"configure.ac",
				".git",
			})
		) or vim.fn.getcwd()

		-- 若当前 buffer 已被标记为手动强制开启，则直接放行
		if vim.b[bufnr].enable_clangd then
			on_dir(root)
			return
		end

		-- 若为 mcpp 项目，不调用 on_dir，静默阻止 clangd 自动启动
		if has_mcpp(bufnr) then
			return
		end

		on_dir(root)
	end,
}
