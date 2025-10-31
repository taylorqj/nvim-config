vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'
    use({ 'nvim-treesitter/playground' })
    use({ 'theprimeagen/harpoon' })
    use({ 'mbbill/undotree' })
    use({ 'tpope/vim-fugitive' })
    use({ 'tpope/vim-surround' })
    use({ 'm4xshen/autoclose.nvim' })
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.4',
        -- or                            , branch = '0.1.x',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }
    use { "catppuccin/nvim", as = "catppuccin" }
    use {
        'nvim-tree/nvim-tree.lua',
        requires = {
            'nvim-tree/nvim-web-devicons',
        },
    }
    use({
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
    })
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'nvim-tree/nvim-web-devicons', opt = true }
    }
    -- LSP Support (modern direct setup, no lsp-zero wrapper)
    use({ 'neovim/nvim-lspconfig' })
    use({ 'williamboman/mason.nvim' })
    use({ 'williamboman/mason-lspconfig.nvim' })

    -- Completion
    use({ 'hrsh7th/nvim-cmp' })
    use({ 'hrsh7th/cmp-nvim-lsp' })
    use({ 'hrsh7th/cmp-buffer' })
    use({ 'hrsh7th/cmp-path' })
    use({ 'saadparwaiz1/cmp_luasnip' })
    use({ 'L3MON4D3/LuaSnip' })
    use({ 'nvimtools/none-ls.nvim' })
    use({ 'MunifTanjim/prettier.nvim' })
    use({
        "kelly-lin/telescope-ag",
        requires = { "nvim-telescope/telescope.nvim" },
    })
    use({
        "iamcco/markdown-preview.nvim",
        run = function() vim.fn["mkdp#util#install"]() end,
    })

    use({
        "coder/claudecode.nvim",
        requires = { "folke/snacks.nvim" }, -- terminal helper
        -- Setup is done in after/plugin/claudecode.lua
    })

    -- Optional dependencies
    use 'HakonHarnes/img-clip.nvim'
end)
