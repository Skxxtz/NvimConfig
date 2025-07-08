local ls = require("luasnip")

vim.keymap.set({ "i", "s" }, "<Tab>", function()
  if ls.jumpable(1) then
    ls.jump(1)
  else
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, true, true), "n", true)
  end
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
  if ls.jumpable(-1) then
    ls.jump(-1)
  end
end, { silent = true })

