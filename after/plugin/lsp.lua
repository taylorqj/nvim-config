-- Modern LSP setup without lsp-zero (following ThePrimeagen and modern Neovim patterns)

-- Disable verbose LSP logging
vim.lsp.set_log_level('off')

-- Setup Mason first
require('mason').setup({
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
    }
})

-- Get default capabilities from cmp_nvim_lsp
local cmp_lsp = require('cmp_nvim_lsp')
local capabilities = vim.tbl_deep_extend(
    "force",
    {},
    vim.lsp.protocol.make_client_capabilities(),
    cmp_lsp.default_capabilities()
)

-- Configure LSP servers using Neovim 0.11+ native API
-- Default setup for most servers
local servers = { 'ts_ls', 'rust_analyzer', 'eslint', 'ruff', 'pyright', 'golangci_lint_ls' }
for _, server in ipairs(servers) do
    vim.lsp.config(server, {
        capabilities = capabilities
    })
    vim.lsp.enable(server)
end

-- Custom setup for lua_ls
vim.lsp.config('lua_ls', {
    capabilities = capabilities,
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' }
            },
            workspace = {
                library = {
                    [vim.fn.expand('$VIMRUNTIME/lua')] = true,
                    [vim.fn.stdpath('config') .. '/lua'] = true,
                }
            }
        }
    }
})
vim.lsp.enable('lua_ls')

-- Global diagnostic keybindings
vim.keymap.set('n', 'gl', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)

-- LSP keybindings on attach
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
    callback = function(event)
        local opts = { buffer = event.buf }

        vim.keymap.set('n', 'gd', function() vim.lsp.buf.definition() end, opts)
        vim.keymap.set('n', 'K', function() vim.lsp.buf.hover() end, opts)
        vim.keymap.set('n', '<leader>vws', function() vim.lsp.buf.workspace_symbol() end, opts)
        vim.keymap.set('n', '<leader>vd', function() vim.diagnostic.open_float() end, opts)
        vim.keymap.set('n', '<leader>vca', function() vim.lsp.buf.code_action() end, opts)
        vim.keymap.set('n', '<leader>vrr', function() vim.lsp.buf.references() end, opts)
        vim.keymap.set('n', '<leader>vrn', function() vim.lsp.buf.rename() end, opts)
        vim.keymap.set('i', '<C-h>', function() vim.lsp.buf.signature_help() end, opts)
    end,
})

-- Completion setup
local cmp = require('cmp')
local luasnip = require('luasnip')

local has_words_before = function()
    unpack = unpack or table.unpack
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
    }, {
        { name = 'buffer' },
        { name = 'path' },
    }),
    mapping = cmp.mapping.preset.insert({
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-y>'] = cmp.mapping.confirm({ select = true }),
        ['<C-Space>'] = cmp.mapping.complete(),

        -- Tab/S-Tab for completion navigation (better integration)
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            elseif has_words_before() then
                cmp.complete()
            else
                fallback()
            end
        end, { 'i', 's' }),

        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' }),
    }),
})

-- Diagnostic configuration
vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    update_in_insert = false,
    underline = true,
    severity_sort = true,
    float = {
        focusable = false,
        style = 'minimal',
        border = 'rounded',
        source = 'always',
        header = '',
        prefix = '',
    },
})
