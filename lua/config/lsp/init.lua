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
local default_signature_help = vim.lsp.handlers["textDocument/signatureHelp"]

vim.lsp.handlers["textDocument/signatureHelp"] = function(err, result, ctx, config)
    if err then
        return
    end
    if default_signature_help then
        return default_signature_help(err, result, ctx, config)
    end
end

return M
