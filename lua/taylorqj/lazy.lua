-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Configure lazy.nvim
require("lazy").setup({
    -- Essential plugins
    { 'nvim-lua/plenary.nvim' },

    -- Treesitter (configured in after/plugin/treesitter.lua)
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        event = { "BufReadPost", "BufNewFile" },
    },
    { 'nvim-treesitter/playground', cmd = "TSPlaygroundToggle" },

    -- Telescope (configured in after/plugin/telescope.lua)
    {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        dependencies = { 'nvim-lua/plenary.nvim' },
        cmd = "Telescope",
    },

    -- Color scheme (configured in after/plugin/colors.lua)
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
    },

    -- File explorer
    {
        'nvim-tree/nvim-tree.lua',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    },

    -- Status line
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        event = "VeryLazy",
    },

    -- LSP
    {
        'neovim/nvim-lspconfig',
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            { 'williamboman/mason.nvim', config = true },
            { 'williamboman/mason-lspconfig.nvim' },
        },
    },

    -- Completion
    {
        'hrsh7th/nvim-cmp',
        event = "InsertEnter",
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'saadparwaiz1/cmp_luasnip',
            {
                'L3MON4D3/LuaSnip',
                version = "v2.*",
                build = "make install_jsregexp",
            },
        },
    },

    -- Formatting (configured in after/plugin/conform.lua)
    {
        'stevearc/conform.nvim',
        event = { "BufWritePre" },
        cmd = { "ConformInfo" },
    },

    -- Git integration
    { 'tpope/vim-fugitive', cmd = { "Git", "G" } },
    {
        'lewis6991/gitsigns.nvim',
        event = { "BufReadPre", "BufNewFile" },
    },

    -- Which-key for keybinding hints (configured in after/plugin/which-key.lua)
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            preset = "modern",
        },
    },

    -- Mini.nvim modules (modern lua alternatives)
    {
        'echasnovski/mini.nvim',
        version = false,
        config = function()
            -- Better text objects
            require('mini.ai').setup()

            -- Surround functionality (replaces vim-surround)
            require('mini.surround').setup()

            -- Auto pairs (replaces autoclose.nvim)
            require('mini.pairs').setup()
        end,
    },

    -- Navigation
    { 'theprimeagen/harpoon', keys = { "<leader>a", "<C-e>", "<C-h>", "<C-t>", "<C-n>", "<C-s>" } },
    { 'mbbill/undotree', cmd = "UndotreeToggle" },

    -- Markdown
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        build = function() vim.fn["mkdp#util#install"]() end,
    },

    -- Claude Code
    {
        "coder/claudecode.nvim",
        dependencies = { "folke/snacks.nvim" },
    },

    -- Image clipboard
    { 'HakonHarnes/img-clip.nvim', cmd = "PasteImage" },
}, {
    ui = {
        border = "rounded",
    },
    performance = {
        rtp = {
            disabled_plugins = {
                "gzip",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
            },
        },
    },
})
