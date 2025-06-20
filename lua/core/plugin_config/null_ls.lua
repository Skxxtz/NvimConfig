local null_ls = require("null-ls")
local mason_null = require("mason-null-ls")

mason_null.setup({
    ensure_installed = {
        "black",
        "markdownlint",
    }
})

null_ls.setup({
    sources = {
        null_ls.builtins.formatting.black,
        null_ls.builtins.formatting.markdownlint,
    }
})
