local M = {}

M.config = require("config.lsp.config")
M.servers = require("config.lsp.servers")
M.keymaps = require("config.lsp.keymaps")
M.signature_help = require("config.lsp.lsp_signature")

function M.setup()
	M.config.setup()
	M.servers.setup()
	M.keymaps.setup()
end

return M
