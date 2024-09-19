return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()

        require'nvim-treesitter.configs'.setup({
            -- A list of parser names, or "all"
            ensure_installed = {
                "bash",
                "c",
                "css",
                "html",
                "javascript",
                "jsdoc",
                "lua",
                "python",
                "regex",
                "rust",
                "typescript",
                "vim",
                "vimdoc",
            },

            -- Install parsers synchronously (only applied to `ensure_installed`)
            sync_install = false,
            auto_install = true,
            highlight = {
                enable = true,
                addidional_vim_regex_highlighting = { "markdown" },
            },
            indent = {
                enable = true
            },
        })

        local treesitter_parser_config = require("nvim-treesitter.parsers").get_parser_configs()
        treesitter_parser_config.templ = {
            install_info = {
                url = "https://github.com/vrischmann/tree-sitter-templ.git",
                files = {"src/parser.c", "src/scanner.c"},
                branch = "master",
            },
        }
        vim.treesitter.language.register("templ", "templ")
    end
}


