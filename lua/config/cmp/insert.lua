local M = {}

function M.setup()
	local cmp = require("cmp")
	local lspkind = require("lspkind")
	local types = require("cmp.types")
	local compare = require("cmp.config.compare")
	local suggestion = require("supermaven-nvim.completion_preview")

	local cmp_sources = {
		{ name = "nvim_lsp" },
		{ name = "vim-dadbod-completion" },
		-- { name = "cmp-dbee" },
		{ name = "luasnip" },
		{ name = "buffer" },
		{ name = "path" },
	}
	if vim.env.CODEIUM == "true" then
		do
			table.insert(cmp_sources, { name = "codeium" })
		end
	end

	cmp.setup({
		--默认选择第一项
		preselect = types.cmp.PreselectMode.Item,
		completion = {
			completeopt = "menu,menuone,noinsert",
		},
		snippet = {
			expand = function(args)
				require("luasnip").lsp_expand(args.body)
			end,
		},

		sources = cmp.config.sources(cmp_sources),

		formatting = {
			fields = { "abbr", "icon", "kind" },
			format = lspkind.cmp_format({
				mode = "symbol_text",
				-- maxwidth = {
				-- 	abbr = 40,
				-- 	menu = 30,
				-- },
				show_labelDetails = false,

				before = function(entry, vim_item)
					-- append highlight to abbr
					local highlights_info = require("colorful-menu").cmp_highlights(entry)
					if highlights_info ~= nil then
						vim_item.abbr_hl_group = highlights_info.highlights
						vim_item.abbr = highlights_info.text
					end

					-- Source Aliases
					-- local source_names = {
					-- 	nvim_lsp = "LSP",
					-- 	luasnip = "Snippets",
					-- 	buffer = "Buffer",
					-- 	path = "Path",
					-- 	codeium = "Codeium",
					-- }
					-- vim_item.menu = source_names[entry.source.name] or entry.source.name

					return vim_item
				end,
			}),
		},
		-- formatting = {
		-- 	format = function(entry, vim_item)
		-- 		-- 使用 lspkind 为每个补全项类型加上图标
		-- 		vim_item.kind = (lspkind.presets.default[vim_item.kind] or "") .. " " .. vim_item.kind
		--
		-- 		local highlights_info = require("colorful-menu").cmp_highlights(entry)
		--
		-- 		-- if highlight_info==nil, which means missing ts parser, let's fallback to use default `vim_item.abbr`.
		-- 		-- What this plugin offers is two fields: `vim_item.abbr_hl_group` and `vim_item.abbr`.
		-- 		if highlights_info ~= nil then
		-- 			vim_item.abbr_hl_group = highlights_info.highlights
		-- 			vim_item.abbr = highlights_info.text
		-- 		end
		-- 		return vim_item
		-- 	end,
		-- },
		-- 快捷键绑定
		mapping = {
			-- 上一个
			["<C-p>"] = cmp.mapping.select_prev_item(),
			["<Up>"] = cmp.mapping.select_prev_item(),
			-- 下一个
			["<C-n>"] = cmp.mapping.select_next_item(),
			["<Down>"] = cmp.mapping.select_next_item(),
			-- 出现补全
			["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
			["<C-e>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
			-- 取消
			["<Esc>"] = cmp.mapping(function(fallback)
				if cmp.visible() then
					-- cmp
					cmp.abort()
				elseif suggestion.has_suggestion() then
					-- clean suggestion first
					suggestion:dispose_inlay()
				else
					fallback()
				end
			end, { "i" }),
			-- 确认
			-- Accept currently selected item. If none selected, `select` first item.
			-- Set `select` to `false` to only confirm explicitly selected items.
			["<tab>"] = cmp.mapping(function(fallback)
				local ls = require("luasnip")
				if vim.env.SUPERMAVEN == "true" then
					-- cmp
					if cmp.visible() then
						cmp.confirm()
					-- supermaven: AI completion
					elseif suggestion.has_suggestion() then
						suggestion.on_accept_suggestion()
					-- luasnip snippets
					elseif ls.expand_or_jumpable() then
						ls.jump(1)
					else
						fallback()
					end
				-- when supermaven disabled
				elseif vim.env.SUPERMAVEN == "false" or vim.env.SUPERMAVEN == nil then
					if cmp.visible() then
						cmp.confirm()
					elseif ls.expand_or_jumpable() then
						ls.jump(1)
					else
						fallback()
					end
				end
			end, { "i" }),
			["<C-CR>"] = cmp.mapping(function() end),
			["<C-k>"] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.mapping.scroll_docs(4)
				else
					fallback()
				end
			end, { "i" }),
			-- ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
			["<C-j>"] = cmp.mapping(function(fallback)
				if cmp.visible_docs() then
					cmp.mapping.scroll_docs(-4)
				-- elseif require("supermaven-nvim.api").is_running() then
				-- 	vim.cmd("norm! j")
				else
					-- fallback()
					-- Force trigger scroll down
					vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Down>", true, true, true), "n", true)
				end
			end, { "i", "c" }),
			-- ["<C-k>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
			-- ['<C-j>'] = cmp.scroll_docs
		},
		sorting = {
			priority_weight = 2,
			comparators = {
				compare.offset,
				compare.exact,
				-- compare.scopes,
				compare.score,
				compare.recently_used,
				compare.locality,
				compare.kind,
				-- compare.sort_text,
				compare.length,
				compare.order,
			},
		},
		window = {
			documentation = {
				border = { "┌", "─", "┐", "│", "┘", "─", "└", "│" },
			},
		},
	})
end

return M
