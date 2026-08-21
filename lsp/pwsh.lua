local mason_path = vim.fn.stdpath("data") .. "/mason/packages/powershell-editor-services"

return {
    cmd = {
        "pwsh",
        "-NoLogo",
        "-NoProfile",
        "-Command",
        string.format(
            "& '%s/PowerShellEditorServices/Start-EditorServices.ps1' -BundledModulesPath '%s' -LogPath '%s/powershell_es.log' -LogLevel Normal -SessionDetailsPath '%s/powershell_es.session.json' -Stdio",
            mason_path,
            mason_path,
            vim.fn.stdpath("cache"),
            vim.fn.stdpath("cache")
        ),
    },
    filetypes = { "ps1", "psm1", "psd1" },
    root_markers = { ".git", "*.ps1" },
    on_attach = function(client, bufnr)
        client.server_capabilities.signatureHelpProvider = nil
    end,
}
