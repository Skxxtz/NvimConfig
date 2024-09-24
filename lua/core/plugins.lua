require("lazy").setup({
    { "EdenEast/nightfox.nvim", name = "nightfox",   priority = 998 },
    { "catppuccin/nvim",        name = "catppuccin", priority = 999 },
    { "rose-pine/nvim",         name = "rose-pine",  priority = 1000 },

    "tpope/vim-commentary",
    "mattn/emmet-vim",
    "nvim-tree/nvim-web-devicons",
    "ellisonleao/gruvbox.nvim",
    "nvim-lualine/lualine.nvim",
    "nvim-treesitter/nvim-treesitter",
    "vim-test/vim-test",
    "lewis6991/gitsigns.nvim",
    "tpope/vim-fugitive",
    'tpope/vim-surround',
    "theprimeagen/harpoon",
    { "lukas-reineke/indent-blankline.nvim",       main = "ibl", opts = {} },
    -- completion
    "windwp/nvim-autopairs",

    { "MeanderingProgrammer/render-markdown.nvim", opts = {} },

    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",


    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
    "rafamadriz/friendly-snippets",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
    {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },
})
