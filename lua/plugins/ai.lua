return {
	{
		"yetone/avante.nvim",
		-- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
		-- ⚠️ must add this setting! ! !
		build = vim.fn.has("win32") ~= 0
				and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
			or "make",
		event = "VeryLazy",
		version = false, -- Never set this value to "*"! Never!
		---@module 'avante'
		---@type avante.Config
		opts = {
			-- add any opts here
			-- this file can contain specific instructions for your project
			instructions_file = { "AGENTS.md", "CLAUDE.md", "GEMINI.md" },
			-- for example
			--- @type "gemini-cli" | "claude-code" | "codex" | "opencode"
			provider = "gemini-cli",
			providers = {
				openai = {
					endpoint = "https://api.deepseek.com",
					model = "deepseek-coder", -- 您想要的模型（或使用 gpt-4o 等）
					timeout = 30000, -- 超时时间（毫秒），增加此值以适应推理模型
					extra_request_body = {
						temperature = 0,
						max_completion_tokens = 8192, -- Increase this to include reasoning tokens (for reasoning models)
						reasoning_effort = "medium", -- low|medium|high, only used for reasoning models
					},
					max_tokens = 8192, -- 增加此值以包括推理模型的推理令牌
					api_key_name = vim.env.DEEPSEEK_API_KEY,
					--reasoning_effort = "medium", -- low|medium|high，仅用于推理模型
				},
			},

			acp_providers = {
				["gemini-cli"] = {
					command = "gemini",
					args = { "--acp" },
				},
				["claude-code"] = {
					command = "bunx",
					args = { "@zed-industries/claude-code-acp" },
					env = {
						NODE_NO_WARNINGS = "1",
						-- ANTHROPIC_API_KEY = os.getenv("ANTHROPIC_API_KEY"),
					},
				},
				["goose"] = {
					command = "goose",
					args = { "acp" },
				},
				["codex"] = {
					command = "npx",
					args = { "@zed-industries/codex-acp" },
					env = {
						NODE_NO_WARNINGS = "1",
						-- OPENAI_API_KEY = os.getenv("OPENAI_API_KEY"),
					},
				},
			},
			-- other configuration options...
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			--- The below dependencies are optional,
			"nvim-mini/mini.pick", -- for file_selector provider mini.pick
			"nvim-telescope/telescope.nvim", -- for file_selector provider telescope
			"hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
			"ibhagwan/fzf-lua", -- for file_selector provider fzf
			"stevearc/dressing.nvim", -- for input provider dressing
			"folke/snacks.nvim", -- for input provider snacks
			"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
			"zbirenbaum/copilot.lua", -- for providers='copilot'
			{
				-- support for image pasting
				"HakonHarnes/img-clip.nvim",
				event = "VeryLazy",
				opts = {
					-- recommended settings
					default = {
						embed_image_as_base64 = false,
						prompt_for_file_name = false,
						drag_and_drop = {
							insert_mode = true,
						},
						-- required for Windows users
						use_absolute_path = true,
					},
				},
			},
			{
				-- Make sure to set this up properly if you have lazy=true
				"MeanderingProgrammer/render-markdown.nvim",
				opts = {
					file_types = { "markdown", "Avante" },
				},
				ft = { "markdown", "Avante" },
			},
		},
	},
	{
		"Exafunction/windsurf.nvim",
		---@return boolean
		cond = function()
			-- vim.print(vim.env.CODEIUM)
			local enabled = vim.env.CODEIUM == "true"
			if vim.env.DEBUG == "true" then
				vim.print("Codeium cond: " .. tostring(enabled))
			end
			return enabled
		end,
		-- priority = 42,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"hrsh7th/nvim-cmp",
		},
		config = function(opts)
			require("codeium").setup(opts)
		end,
		event = "InsertEnter",
		opts = {},
	},
	{
		"Butterblock233/CLIAgents.nvim",
		cond = false,
		dependencies = {
			"nvim-lua/plenary.nvim", -- Required for git operations
		},
		keys = {
			{ "<leader>cc", "<cmd>CLIAgents<CR>", mode = { "t", "n" }, desc = "Toggle CLI Agents" },
			{ "<C-S-C>", "<cmd>CLIAgents<CR>", mode = { "t", "n" }, desc = "Toggle CLI Agents" },
			{ "<A-c>", "<cmd>CLIAgents<CR>", mode = { "t", "n" }, desc = "Toggle CLI Agents" },
		},
		cmd = {
			"CLIAgents",
			"CLIAgentsResume",
		},
		opts = {
			-- 新的多提供商配置
			providers = {
				default_provider = "claude", -- Default value
				providers = {
					gemini = {
						command = "gemini",
						default_variants = {
							-- model = "--model=gemini-pro",
						},
					},
					codex = {
						command = "codex",
						default_variants = {
							model = "-m deepseek/deepseek-chat-v3.1",
						},
					},
				},
			},
			shell = {
				separator = ";",
			},
			window = {
				split_ratio = 0.3, -- Percentage of screen for the terminal window (height for horizontal, width for vertical splits)
				---@type "botright" | "topleft" | "vertical" | "float"
				position = "float", -- Position of the window: "botright", "topleft", "vertical", "float", etc.
			},
			keymaps = {
				toggle = {
					-- normal = "<C-l>", -- Normal mode keymap for toggling Claude Code, false to disable
					-- terminal = "<C-l>", -- Terminal mode keymap for toggling Claude Code, false to disable
					variants = {
						continue = "<leader>cC", -- Normal mode keymap for Claude Code with continue flag
						verbose = "<leader>cV", -- Normal mode keymap for Claude Code with verbose flag
					},
				},
				window_navigation = true, -- Enable window navigation keymaps (<C-h/j/k/l>)
				scrolling = true, -- Enable scrolling keymaps (<C-f/b>) for page up/down
			},
		},
	},
	{
		"supermaven-inc/supermaven-nvim",
		cond = true,
		event = { "InsertEnter" },
		cmd = {
			"SupermavenStart",
			"SupermavenStop",
			"SupermavenRestart",
			"SupermavenToggle",
			"SupermavenUseFreeVersion",
			"SupermavenUsePro",
			"SupermavenLogout",
			"SupermavenShowLog",
			"SupermavenClearLog",
		},
		keymaps = {
			{ "n", "<leader>smt", "<cmd>SupermavenToggle<CR>", mode = "n", desc = "Toggle Supermaven" },
		},
		opts = {
			keymaps = {
				accept_suggestion = "",
				clear_suggestion = "",
				accept_word = "",
			},
			disable_keymaps = true, -- defined in cmp
			disable_inline_completion = false,
		},
		build = function()
			-- You dont want to see a pop-up windows to ask you
			-- login to supermaven to use pro version every ten seconds or so, right?
			local api = require("supermaven-nvim.api")
			api.use_free_version()
		end,
		config = function(opts)
			if vim.env.SUPERMAVEN == "false" or vim.env.SUPERMAVEN == nil then
				vim.g.SUPERMAVEN_DISABLED = 1 -- use internal impletion directely to disable warnings
			else
				require("supermaven-nvim").setup(opts)
			end
		end,
	},
}
