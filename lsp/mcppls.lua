local function has_mcpp(bufnr)
	-- Check if mcpp.toml exists in the current working directory (pwd)
	if vim.uv.fs_stat(vim.fs.joinpath(vim.fn.getcwd(), "mcpp.toml")) ~= nil then
		return true
	end
	-- Check if mcpp.toml exists in any parent directory of the buffer
	if bufnr and vim.fs.root(bufnr, { "mcpp.toml" }) ~= nil then
		return true
	end
	return false
end

return {
	name = "mcppls",
	cmd = { "mcppls", "serve" },
	filetypes = { "cpp", "c", "h", "hpp" },
	offsetEncoding = { "utf-8" },
	init_options = {
		conflictArbitration = "client",
	},
	root_dir = function(bufnr, on_dir)
		-- Only activate mcppls when mcpp.toml is present
		if has_mcpp(bufnr) then
			local root = (bufnr and vim.fs.root(bufnr, { "mcpp.toml" })) or vim.fn.getcwd()
			on_dir(root)
		end
	end,
}

