local cmp = require("cmp")
local cmp_autopairs = require("nvim-autopairs.completion.cmp")

require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip.loaders.from_lua").lazy_load({paths = "~/.config/nvim/lua/snippets/"})

cmp.setup({
    completion = {
        completeopt = 'menu,menuone,noinsert',
    },
    window = {
        completion = cmp.config.window.bordered(),
        -- documentation = cmp.config.window.bordered(),
        documentation = cmp.config.disable
    },

    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-o>'] = cmp.mapping.complete(),
        ['<C-CR>'] = cmp.mapping(function(_)
            cmp.abort()
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, true, true), "n", true)
        end, { "i", "s" }),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
    }),
    snippet = {
        expand = function(args)
            local ls = require("luasnip")
            ls.lsp_expand(args.body)
        end,
    },
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'path' },
    }, {
        { name = 'buffer' },
    }),

})

cmp.event:on(
   "confirm_done",
   cmp_autopairs.on_confirm_done()
)



