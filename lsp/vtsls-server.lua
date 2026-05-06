---@brief
---
--- https://github.com/yioneko/vtsls
---
--- `vtsls` can be installed with npm:
--- ```sh
--- npm install -g @vtsls/language-server
--- ```
---
--- To configure a TypeScript project, add a
--- [`tsconfig.json`](https://www.typescriptlang.org/docs/handbook/tsconfig-json.html)
--- or [`jsconfig.json`](https://code.visualstudio.com/docs/languages/jsconfig) to
--- the root of your project.
---
--- ### Vue support
---
--- Since v3.0.0, the Vue language server requires `vtsls` to support TypeScript.
---
--- ```
--- -- If you are using mason.nvim, you can get the ts_plugin_path like this
--- -- For Mason v1,
--- -- local mason_registry = require('mason-registry')
--- -- local vue_language_server_path = mason_registry.get_package('vue-language-server'):get_install_path() .. '/node_modules/@vue/language-server'
--- -- For Mason v2,
--- -- local vue_language_server_path = vim.fn.expand '$MASON/packages' .. '/vue-language-server' .. '/node_modules/@vue/language-server'
--- -- or even
--- -- local vue_language_server_path = vim.fn.stdpath('data') .. "/mason/packages/vue-language-server/node_modules/@vue/language-server"
--- local vue_language_server_path = '/path/to/@vue/language-server'
--- local vue_plugin = {
---   name = '@vue/typescript-plugin',
---   location = vue_language_server_path,
---   languages = { 'vue' },
---   configNamespace = 'typescript',
--- }
--- vim.lsp.config('vtsls', {
---   settings = {
---     vtsls = {
---       tsserver = {
---         globalPlugins = {
---           vue_plugin,
---         },
---       },
---     },
---   },
---   filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
--- })
--- ```
---
--- - `location` MUST be defined. If the plugin is installed in `node_modules`, `location` can have any value.
--- - `languages` must include vue even if it is listed in filetypes.
--- - `filetypes` is extended here to include Vue SFC.
---
--- You must make sure the Vue language server is setup. For example,
---
--- ```
--- vim.lsp.enable('vue_ls')
--- ```
---
--- See `vue_ls` section and https://github.com/vuejs/language-tools/wiki/Neovim for more information.
---
--- ### Monorepo support
---
--- `vtsls` supports monorepos by default. It will automatically find the `tsconfig.json` or `jsconfig.json` corresponding to the package you are working on.
--- This works without the need of spawning multiple instances of `vtsls`, saving memory.
---
--- It is recommended to use the same version of TypeScript in all packages, and therefore have it available in your workspace root. The location of the TypeScript binary will be determined automatically, but only once.
---
--- This includes the same Deno-excluding logic from `ts_ls`. It is not recommended to enable both `vtsls` and `ts_ls` at the same time!

---@type vim.lsp.Config
return {
	cmd = { "vtsls", "--stdio" },
	name = "vtsls",
	init_options = {
		hostInfo = "neovim",
	},
	filetypes = {
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
		"vue",
	},
	root_dir = function(bufnr, on_dir)
		-- The project root is where the LSP can be started from
		-- As stated in the documentation above, this LSP supports monorepos and simple projects.
		-- We select then from the project root, which is identified by the presence of a package
		-- manager lock file.
		local root_markers = { "package-lock.json", "yarn.lock", "pnpm-lock.yaml", "bun.lockb", "bun.lock" }
		-- Give the root markers equal priority by wrapping them in a table
		root_markers = vim.fn.has("nvim-0.11.3") == 1 and { root_markers, { ".git" } }
			or vim.list_extend(root_markers, { ".git" })

		local project_root = vim.fs.root(bufnr, root_markers)

		local is_vue_file = vim.bo[bufnr].filetype == "vue"
		local vite_root = vim.fs.root(bufnr, { "vite.config.ts", "vite.config.js" })

		-- 扩展检测 Vue 标记的搜索目录：锁文件根、deno 配置根、deno.lock 根
		local deno_root = vim.fs.root(bufnr, { "deno.json", "deno.jsonc" })
		local deno_lock_root = vim.fs.root(bufnr, { "deno.lock" })
		local function has_vue_files(dir)
			if not dir then
				return false
			end
			return #vim.fs.find(function(name)
				return name:match("%.vue$")
			end, {
				limit = 1,
				path = dir,
			}) > 0
		end
		local search_roots = {}
		if project_root then
			table.insert(search_roots, project_root)
		end
		if deno_root then
			table.insert(search_roots, deno_root)
		end
		if deno_lock_root then
			table.insert(search_roots, deno_lock_root)
		end
		local has_vue_marker = vite_root ~= nil
		if not has_vue_marker then
			for _, dir in ipairs(search_roots) do
				if has_vue_files(dir) then
					has_vue_marker = true
					break
				end
			end
		end
		if not has_vue_marker and #search_roots == 0 then
			has_vue_marker = has_vue_files(vim.fn.getcwd())
		end
		local is_vue_project = is_vue_file or has_vue_marker

		-- exclude deno, but enable in deno+Vue projects
		if not is_vue_project then
			if deno_lock_root and (not project_root or #deno_lock_root > #project_root) then
				return -- return nil, so the vtsls will never enabled.
			end
			if deno_root and (not project_root or #deno_root >= #project_root) then
				return
			end
		end

		-- project is standard TS, not deno (OR it is bypassed by Vue project logic)
		-- We fallback to the current working directory if no project root is found
		on_dir(project_root or vim.fn.getcwd())
	end,
}
