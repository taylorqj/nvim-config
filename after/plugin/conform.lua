-- Modern formatting with conform.nvim (replaces none-ls + prettier)
require("conform").setup({
    formatters_by_ft = {
        javascript = { "prettierd", "prettier", stop_after_first = true },
        javascriptreact = { "prettierd", "prettier", stop_after_first = true },
        typescript = { "prettierd", "prettier", stop_after_first = true },
        typescriptreact = { "prettierd", "prettier", stop_after_first = true },
        css = { "prettierd", "prettier", stop_after_first = true },
        html = { "prettierd", "prettier", stop_after_first = true },
        json = { "prettierd", "prettier", stop_after_first = true },
        yaml = { "prettierd", "prettier", stop_after_first = true },
        markdown = { "prettierd", "prettier", stop_after_first = true },
        graphql = { "prettierd", "prettier", stop_after_first = true },
        less = { "prettierd", "prettier", stop_after_first = true },
        scss = { "prettierd", "prettier", stop_after_first = true },
        go = { "gofmt" },
        python = { "ruff_format" },
        rust = { "rustfmt" },
        lua = { "stylua" },
    },
    -- Format on save
    format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
    },
})

-- Manual format keybinding
vim.keymap.set({ "n", "v" }, '<leader>f', function()
    require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Format buffer" })
